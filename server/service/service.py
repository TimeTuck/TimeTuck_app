from flask import Flask, request, Response, g, abort
from flask.ext.principal import Principal, Permission, RoleNeed, Identity, identity_loaded, IdentityContext
from timetuck.database import access
from timetuck.model import user
from timetuck.model import session
from timetuck.helpers import respond
from service_info import get_session_data
from functools import wraps
import json

app = Flask(__name__)
app.config.from_object('config')

principals = Principal(app)
activated_user = Permission(RoleNeed('Activated'))

def activate_db():
    if not hasattr(g, 'db_main'):
        g.db_main = access(app.config['DB_CONNECTION'])

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not hasattr(g.identity, 'user') or g.identity.user is None:
            abort(401)
        return f(*args, **kwargs)
    return decorated_function

@app.before_request
def before_request():
    activate_db()

@principals.identity_loader
def identity_loader():
    sess = get_session_data(request.get_json())
    if sess is None:
        return None

    return Identity(sess.__dict__)

@identity_loaded.connect_via(app)
def on_identity_loaded(sender, identity):
    activate_db()
    identity.user = g.db_main.session_get_user(identity.id)

    if identity.user is None:
        return

    if identity.user.activated is True:
        identity.provides.add(RoleNeed("Activated"))

    g.identity = identity

@app.route('/register', methods=['post'])
def register():
    data = request.get_json()

    if data is None:
        abort(400)

    try:
        new_user = user(data['username'], data['email'], data['phone_number'])
        new_user.set_password(data['password'])
    except KeyError:
        abort(400)

    errors = new_user.validate()

    if errors != {}:
        return Response(response=json.dumps(respond(2, errors=errors, indent=4)),
                        status=200, mimetype='application/json')

    if g.db_main.user_create(new_user) is True:
        sess = session.create()
        g.db_main.session_create(new_user, sess)

        return Response(response=json.dumps(respond(0, user=new_user.getdict(), session=sess.__dict__), indent=4),
                        status=200, mimetype='application/json')
    else:
        result = g.db_main.check_username_phone_exits(new_user)
        return Response(response=json.dumps(respond(1, errors=result), indent=4),
                        status=200, mimetype='application/json')

@app.route('/login', methods=['post'])
def login():
    data = request.get_json()

    if data is None:
        abort(400)

    try:
        login = {'username': data['username'], 'passwd': data['password']}
    except KeyError:
        abort(400)

    u = g.db_main.user_login(login['username'])

    if u is None or not u.check_password(login['passwd'], u.password):
        return Response(response=json.dumps(respond(1), indent=4),
                        status=200, mimetype='application/json')

    sess = session.create()
    g.db_main.session_create(u, sess)
    
    return Response(response=json.dumps(respond(0, user=u.getdict(), session=sess.__dict__), indent=4),
                    status=200, mimetype='application/json')

@app.route('/logout', methods=['post'])
@login_required
def logout():
    sess = get_session_data(request.get_json())
    if sess is None:
        abort(400)

    g.db_main.session_logout(sess)
    return Response(response=json.dumps(respond(0), indent=4), status=200, mimetype='application/json')

@app.route('/check_user', methods=['post'])
@activated_user.require(http_exception=403)
def check_user():
    sess = session(**g.identity.id)
    user = g.identity.user
    sess.update()
    g.db_main.session_update(sess)
    return Response(response=json.dumps(respond(0, user=user.getdict(), session=sess.__dict__), indent=4),
                    status=200, mimetype='application/json')


if __name__ == '__main__':
    app.run()