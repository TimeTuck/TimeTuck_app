from flask import Flask
from timetuck.database import access
from timetuck.media import create_path_to_image
from timetuck.model import device_users
from service.notifications import notify
import time
import os

app = Flask(__name__)
app.config.from_object('config')
db = access(app.config['DB_CONNECTION'])

while True:
    untucks = db.timecapsule_get_need_untuck_sa(time.localtime())

    for i in iter(untucks):
        try:
            os.rename(os.path.join(create_path_to_image(app.config['UPLOAD_FOLDER'], str(i.owner_id)), i.file_name),
                      os.path.join(create_path_to_image(app.config['LIVE_FOLDER'], str(i.owner_id)), i.file_name))
            db.timecapsule_update_status(i.id)

            tokens = set(db.timecapsule_all_friends(i.id))
            tokens |= set(db.timecapsule_get_device_of_friends(i.id))
            tokens |= set(db.get_all_device_tokens(i.owner_id))

            users = device_users()
            users.add(tokens)

            notify(app.config, async=True).send_notification("You have a new TimeTuck!", users, "new_timetuck")

        except:
            pass

    time.sleep(60)





