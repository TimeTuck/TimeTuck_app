from werkzeug.security import generate_password_hash, check_password_hash
from validate_email import validate_email
from uuid import uuid4
import re

class user:
    def __init__(self, username, email, phone_number, id=None, active=False, activated=False):
        self.id = id
        self.username = username
        self.email = email
        self.phone_number = phone_number
        self.password = None
        self.activated = bool(activated)
        self.active = bool(active)

    @staticmethod
    def check_password(password, hashed):
        return check_password_hash(hashed, password)

    def set_password(self, password):
        self.password = generate_password_hash(password)

    def getdict(self):
        return {'id': self.id, 'username': self.username, 'phone_number': self.phone_number,
                'email': self.email, 'activated': self.activated, 'active': self.active}

    def validate(self):
        error_list = {}

        if validate_email(self.username):
            error_list['username'] = 'Username cannot be an email address'

        if not validate_email(self.email):
            error_list['email'] = 'Email address is not valid'

        self.phone_number = self.phone_number.replace("-", '')
        if not re.match(r'^\+?[0-9]+$', self.phone_number):
            error_list['phone_number'] = 'Phone number is invalid'

        return error_list

class session:
    def __init__(self, key, secret):
        self.key = str(key)
        self.secret = str(secret)

    @staticmethod
    def create():
        return session(str(uuid4()), str(uuid4()))

    def update(self):
        self.secret = str(uuid4())


class untuck_info:
    def __init__(self, id, owner_id, file_name):
        self.id = id
        self.owner_id = owner_id
        self.file_name = file_name