import time
def convert_time(t):
    return time.strftime('%Y-%m-%d %H:%M:%S')

def respond(status, **kwargs):
    output = {'status': status}

    for key in kwargs:
        output[key] = kwargs[key]

    return output