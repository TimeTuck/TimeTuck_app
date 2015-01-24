from werkzeug.security import generate_password_hash, check_password_hash
from uuid import uuid4

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

class session:
    def __init__(self, key, secret):
        self.key = str(key)
        self.secret = str(secret)

    @staticmethod
    def create():
        return session(str(uuid4()), str(uuid4()))

    def update(self):
        self.secret = str(uuid4())
