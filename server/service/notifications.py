__author__ = 'adamgreenstein'
from apnsclient import *
import thread


class notify:
    def __init__(self, config, async=False):
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
    def send_notification(self, message, devices):
        if len(devices) <= 0:
            return

        con = Session().get_connection(self.config['PUSH_METHOD'], cert_file=self.config['PUSH_KEY_LOCATION'])
        message = Message(devices, alert=message, badge='increment')

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