from flask import request
from timetuck.model import session

def get_session_data(data):
    data = request.get_json()

    if data is None:
        return None
    try:
        sess = session(data['session']['key'], data['session']['secret'])
    except KeyError:
        return None

    return sess