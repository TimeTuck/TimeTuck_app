from flask import Flask, request, Response, g, abort
from flask.ext.principal import Principal, Permission, RoleNeed, Identity, identity_loaded
from timetuck.database import access
from timetuck.model import user
from timetuck.model import session
from notifications import notify
from service_info import get_session_data, get_session_form_data, allowed_file, respond
from functools import wraps
from werkzeug.utils import secure_filename
import os
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
    sess = None
    if request.method == 'POST':
        if request.content_type == 'application/json':
            sess = get_session_data()
        elif 'multipart/form-data' in request.content_type:
            sess = get_session_form_data(request.form)
    elif request.method == 'GET':
        try:
            sess = session(request.args['key'], request.args['secret'])
        except:
            pass

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

    token = None

    try:
        token = data['device_token'].replace(" ", "").replace("<", "").replace(">", "")
    except:
        pass

    errors = new_user.validate()

    if errors != {}:
        return Response(response=json.dumps(respond(2, errors=errors, indent=4)),
                        status=200, mimetype='application/json')

    if g.db_main.user_create(new_user) is True:
        sess = session.create()
        g.db_main.session_create(new_user, sess, token)

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

    try:
        login['device_token'] = data['device_token'].replace(" ", "").replace("<", "").replace(">", "")
    except:
        login['device_token'] = None

    u = g.db_main.user_login(login['username'])

    if u is None or not u.check_password(login['passwd'], u.password):
        return Response(response=json.dumps(respond(1), indent=4),
                        status=200, mimetype='application/json')

    sess = session.create()
    g.db_main.session_create(u, sess, login['device_token'])
    
    return Response(response=json.dumps(respond(0, user=u.getdict(), session=sess.__dict__), indent=4),
                    status=200, mimetype='application/json')

@app.route('/logout', methods=['post'])
@login_required
def logout():
    sess = get_session_data()
    if sess is None:
        abort(400)

    g.db_main.session_logout(sess)
    return Response(response=json.dumps(respond(0), indent=4), status=200, mimetype='application/json')

@app.route('/check_user', methods=['post'])
@login_required
def check_user():
    sess = session(**g.identity.id)
    user = g.identity.user
    sess.update()

    g.db_main.session_update(sess)
    token = g.db_main.get_device_token(sess)

    return Response(response=json.dumps(respond(0, user=user.getdict(), session=sess.__dict__, token=token), indent=4),
                    status=200, mimetype='application/json')

@app.route('/update_device_token', methods=['post'])
@login_required
def update_device_token():
    sess = session(**g.identity.id)
    deviceToken = None
    data = request.get_json()

    try:
        deviceToken = data['device_token']
    except:
        pass

    g.db_main.update_device_token(sess, deviceToken)

    return Response(response=json.dumps(respond(0), indent=4),
                    status=200, mimetype='application/json')


@app.route('/send_friend_request/<id>', methods=['post'])
@login_required
def send_friend_request(id):
    if id is None:
        abort(400)

    user = g.identity.user

    if user.id == id:
        return Response(response=json.dumps(respond(2), indent=4),
                    status=200, mimetype='application/json')

    returned_val = g.db_main.send_friend_request(user, id)
    devices = g.db_main.get_all_device_tokens(id)
    notify(app.config, async=True).send_notification("New Friend Request: %s" % user.username, devices)

    return Response(response=json.dumps(respond(returned_val), indent=4),
                    status=200, mimetype='application/json')

@app.route('/respond_friend_request/<id>', methods=['post'])
@login_required
def respond_friend_request(id):
    if id is None:
        abort(400)
    accept = True
    try:
        data = request.get_json()
        accept = data["accept"]
    except:
        abort(400)

    user = g.identity.user

    if user.id == id:
        return Response(response=json.dumps(respond(2), indent=4),
                    status=200, mimetype='application/json')

    returned_val = g.db_main.respond_friend_request(user, id, accept)

    if accept and returned_val == 0:
        devices = g.db_main.get_all_device_tokens(id)
        notify(app.config, async=True).send_notification("%s accepted you friend request!" % user.username, devices)


    return Response(response=json.dumps(respond(returned_val), indent=4),
                    status=200, mimetype='application/json')


@app.route('/get_friends', methods=['get'])
@login_required
def get_friends():
    user = g.identity.user

    results = g.db_main.get_friends(user)
    requests = g.db_main.get_friend_requests(user)

    return Response(response=json.dumps(respond(0,requests=requests,friends=results), indent=4),
                    status=200, mimetype='application/json')

@app.route('/search_users', methods=['get'])
@login_required
def search_users():
    user = g.identity.user
    try:
        search = request.args['search']
    except:
        abort(400)

    if search == '':
        results = []
    else:
        results = g.db_main.search_users(user, search)
    return Response(response=json.dumps(respond(0,users=results), indent=4),
                    status=200, mimetype='application/json')

@app.route('/image_upload', methods=['post'])
@login_required
def upload_image():
    if request.method == 'POST':
        try:
            file = request.files['image']
            if file and allowed_file(file.filename):
                filename = secure_filename(file.filename)
                file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        except:
            abort(400)

    return Response(response=json.dumps(respond(0, response=1), indent=4), status=200, mimetype='application/json')

if __name__ == '__main__':
    app.run()