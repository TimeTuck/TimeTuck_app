import os

def create_path_to_image(path, *paths):
    fullpath = os.path.join(path, *paths)
    if not os.path.exists(fullpath):
        try:
            os.makedirs(fullpath, mode=0o700)
        except:
            pass
    return fullpath


