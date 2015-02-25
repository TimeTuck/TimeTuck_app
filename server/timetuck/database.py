import MySQLdb
from contextlib import closing
from helpers import convert_time
from model import user
import time

class access:
    def __init__(self, config):
        self.config = config

    def open(self):
        return MySQLdb.connect(**self.config)

    def close(self, db):
        db.close()


    class db_connect:
        def __init__(self, outer):
            self.outer = outer
            self.db = None

        def __enter__(self):
            self.db = self.outer.open()
            return self.db

        def __exit__(self, exc_type, exc_val, exc_tb):
            if self.db is not None:
                self.outer.close(self.db)

    def connection(self):
        return self.db_connect(self)

    def user_create(self, user):
        with self.connection() as db:
            with closing(db.cursor(MySQLdb.cursors.DictCursor)) as cur:

                try:
                    cur.callproc("user_save", (user.username, user.password, user.phone_number,
                                               convert_time(time.localtime()), user.email))
                except MySQLdb.IntegrityError:
                    return False

                result = cur.fetchone()

                if result['id'] is not None:
                    val = True
                    user.id = result['id']
                    user.active = True
                else:
                    val = False

            db.commit()

        return val

    def user_login(self, uname):
        with self.connection() as db:
            with closing(db.cursor(MySQLdb.cursors.DictCursor)) as cur:
                cur.callproc("user_get_login", (uname,))
                result = cur.fetchone()

                if result is None:
                    return None

                u = user(result['username'], result['email'], result['phone_number'], result['id'], result['active'],
                        result['activated'])
                u.password = result['password']

                return u

    def check_username_phone_exits(self, user):
        with self.connection() as db:
            with closing(db.cursor(MySQLdb.cursors.DictCursor)) as cur:
                cur.callproc("user_check_info_exists", (user.username, user.phone_number, user.email))
                result = cur.fetchone()

                return {'username': bool(result['username']), 'phonenumber': bool(result['phonenumber']),
                        'email': bool(result['email'])}

    def session_create(self, user, session, token):
        if not isinstance(session, dict):
            sess = session.__dict__
        else:
            sess = session

        with self.connection() as db:
            with closing(db.cursor()) as cur:
                cur.callproc("session_create", (user.id, sess['key'], sess['secret'], convert_time(time.localtime()),
                                                token))
                db.commit()

    def session_update(self, session):
        if not isinstance(session, dict):
            sess = session.__dict__
        else:
            sess = session

        with self.connection() as db:
            with closing(db.cursor()) as cur:
                cur.callproc("session_update", (sess['key'], sess['secret'], convert_time(time.localtime())))
                db.commit()

    def session_get_user(self, session):
        if not isinstance(session, dict):
            sess = session.__dict__
        else:
            sess = session

        with self.connection() as db:
            with closing(db.cursor(MySQLdb.cursors.DictCursor)) as cur:
                cur.callproc("session_get_user", (sess['key'], sess['secret']))
                result = cur.fetchone()
                if result is None:
                    return None
                return user(result['username'], result['email'], result['phone_number'], result['id'], result['active'],
                            result['activated'])

    def session_logout(self, session):
        if not isinstance(session, dict):
            sess = session.__dict__
        else:
            sess = session

        with self.connection() as db:
            with closing(db.cursor()) as cur:
                cur.callproc("session_logout", (sess['key'], sess['secret']))
                db.commit()

    def get_device_token(self, session):
        if not isinstance(session, dict):
            sess = session.__dict__
        else:
            sess = session

        with self.connection() as db:
            with closing(db.cursor(MySQLdb.cursors.DictCursor)) as cur:
                cur.callproc("device_token_from_session", (sess['key'], sess['secret']))

                result = cur.fetchone()
                return result["result"]

    def get_all_device_tokens(self, id):
        with self.connection() as db:
            with closing(db.cursor(MySQLdb.cursors.DictCursor)) as cur:
                try:
                     cur.callproc("device_token_get_all", (id,))
                except:
                    return []

                devices = cur.fetchall()
                deviceList = []

                for v in iter(devices):
                    if v['device_token'] is not None:
                        deviceList.append(v['device_token'])
        return deviceList

    def update_device_token(self, session, token):
        if not isinstance(session, dict):
            sess = session.__dict__
        else:
            sess = session

        with self.connection() as db:
            with closing(db.cursor()) as cur:
                cur.callproc("device_token_update", (sess['key'], sess['secret'], token))
                db.commit()

    def send_friend_request(self, user, requested_id):
        with self.connection() as db:
            with closing(db.cursor(MySQLdb.cursors.DictCursor)) as cur:
                try:
                    cur.callproc("send_friend_request", (user.id, requested_id, convert_time(time.localtime())))
                except:
                    return 2
                result = cur.fetchone()
                if result["result"] == 1:
                    val = 0
                else:
                    val = 1

            db.commit()
            return val

    def respond_friend_request(self, user, requestors_id, accept):
        with self.connection() as db:
            with closing(db.cursor(MySQLdb.cursors.DictCursor)) as cur:
                try:
                    cur.callproc("respond_friend_request", (user.id, requestors_id, convert_time(time.localtime()),
                                                            accept))
                except:
                    return 1

                result = cur.fetchone()
                if result["result"] == 1:
                    val = 0
                else:
                    val = 2

            db.commit()
            return val

    def get_friends(self, user):
         with self.connection() as db:
            with closing(db.cursor(MySQLdb.cursors.DictCursor)) as cur:
                try:
                     cur.callproc("get_friends", (user.id,))
                except:
                    return []
                return cur.fetchall()

    def get_friend_requests(self, user):
         with self.connection() as db:
            with closing(db.cursor(MySQLdb.cursors.DictCursor)) as cur:
                try:
                     cur.callproc("get_friend_requests", (user.id,))
                except:
                    return []
                return cur.fetchall()

    def search_users(self, user, search):
        with self.connection() as db:
            with closing(db.cursor(MySQLdb.cursors.DictCursor)) as cur:
                try:
                    cur.callproc("search_users", (user.id, search))
                except:
                    return []
                results = cur.fetchall()
                return results

    def tuck_sa(self, user, filename, uncapsule, friends):
        with self.connection() as db:
            with closing(db.cursor(MySQLdb.cursors.DictCursor)) as cur:
                try:
                    cur.callproc("timecapsule_create_sa", (user.id, convert_time(time.localtime()), uncapsule, filename))
                except:
                    return None
                result = cur.fetchone()
                id = result["INSERT_ID"]

            with closing(db.cursor(MySQLdb.cursors.DictCursor)) as cur:
               for friend in iter(friends):
                    try:
                        cur.callproc("timecapsule_add_friend", (id, friend))
                    except:
                        pass


            db.commit()
            return None