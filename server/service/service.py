from flask import Flask
from flask import request
from flask import Response
from flask import g
import json
from timetuck.database import access
from timetuck.model import user
from timetuck.model import session
from timetuck.helpers import respond

app = Flask(__name__)
app.config.from_object('config')

@app.before_request
def before_request():
    g.db_main = access(app.config['DB_CONNECTION'])


@app.route('/create_user', methods=['post'])
def create_user():
    data = request.get_json()

    if data is None:
        return Response(status=400)

    try:
        new_user = user(data['username'], data['email'], data['phone_number'])
        new_user.set_password(data['password'])
    except KeyError:
        return Response(status=400)

    # Check username is not an email
    # Check email is valid
    # Check phone number is valid

    if g.db_main.user_create(new_user) is True:
        sess = session.create()
        g.db_main.session_create(new_user, sess)

        return Response(response=json.dumps(respond(1, user=new_user.getdict(), session=sess.__dict__), indent=4),
                        status=200, mimetype='application/json')
    else:
        result = g.db_main.check_username_phone_exits(new_user)
        return Response(response=json.dumps(respond(0, errors=result), indent=4),
                        status=200, mimetype='application/json')

@app.route('/login', methods=['post'])
def login():
    data = request.get_json()

    if data is None:
        return Response(status=400)

    try:
        login = {'username': data['username'], 'passwd': data['password']}
    except KeyError:
        return Response(status=400)

    u = g.db_main.user_login(login['username'])

    if u is None:
        return Response(response=json.dumps(respond(1), indent=4),
                        status=200, mimetype='application/json')

    if not u.check_password(login['passwd'], u.password):
        return Response(response=json.dumps(respond(1), indent=4),
                        status=200, mimetype='application/json')

    sess = session.create()
    g.db_main.session_create(u, sess)

    return Response(response=json.dumps(respond(0, user=u.getdict(), session=sess.__dict__), indent=4),
                    status=200, mimetype='application/json')


@app.route('/logout', methods=['post'])
def logout():
    data = request.get_json()

    if data is None:
        return Response(status=400)

    try:
        sess = session(data['key'], data['secret'])
    except KeyError:
        return Response(status=400)

    g.db_main.session_logout(sess)

    return Response(response=json.dumps(respond(0), indent=4), status=200, mimetype='application/json')



if __name__ == '__main__':
    app.run()
