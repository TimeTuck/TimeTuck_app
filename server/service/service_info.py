from flask import request
from timetuck.model import session

def get_session_data():
    data = request.get_json()

    if data is None:
        return None
    try:
        sess = session(data['session']['key'], data['session']['secret'])
    except KeyError:
        return None

    return sess

def get_session_form_data(form):
    try:
        sess = session(form['key'], form['secret'])
        return sess
    except:
        return None

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1] in set(['png',])

def respond(status, **kwargs):
    output = {'status': status}

    for key in kwargs:
        output[key] = kwargs[key]

    return output