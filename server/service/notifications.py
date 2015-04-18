import thread

from apnsclient import *
from timetuck.database import access

class notify:
    def __init__(self, config, async=False):
        self.db = access(config['DB_CONNECTION'])
        self.async = async
        self.config = config

    def _callMethod(fn):
        def inner(self, *args):
            if self.async:
                thread.start_new_thread(fn, (self,) + args);
            else:
                fn(self, *args)
        return inner

    @_callMethod
    def send_notification(self, message, device_users, type):
        if len(device_users) <= 0:
            return

        notification_id = self.db.notification_add(type, message)
        badge_dev = {}

        for user_id in iter(device_users.users):
            value = self.db.notification_associate(user_id, notification_id)

            for token in iter(device_users.users[user_id]):
                if value in badge_dev:
                    badge_dev[value] += [token]
                else:
                    badge_dev[value] = [token]

        for badge_count in iter(badge_dev):
            con = Session().get_connection(self.config['PUSH_METHOD'], cert_file=self.config['PUSH_KEY_LOCATION'])
            message = Message(badge_dev[badge_count], alert=message, badge=badge_count, type=type)

            # Send the message.
            srv = APNs(con)
            try:
                res = srv.send(message)
            except:
                pass
            else:

                # Check failures. Check codes in APNs reference docs.
                for token, reason in res.failed.items():
                    code, errmsg = reason
                    # according to APNs protocol the token reported here
                    # is garbage (invalid or empty), stop using and remove it.
                    print "Device failed: {0}, reason: {1}".format(token, errmsg)

                # Check failures not related to devices.
                for code, errmsg in res.errors:
                    print "Error: {}".format(errmsg)