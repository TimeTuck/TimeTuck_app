from flask import Flask
from timetuck.database import access
from timetuck.media import create_path_to_image
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

            tokens = db.timecapsule_get_device_of_friends(i.id)
            tokens = tokens + db.get_all_device_tokens(i.owner_id)

            notify(app.config, async=True).send_notification("You have a new TimeTuck!", tokens)
        except:
            pass

    time.sleep(60)





