from flask import Flask, render_template, request, session
from flask_socketio import SocketIO
from datetime import datetime
from pymongo import MongoClient
from pass_mongo import pass_mongo
import pytz
import time as t
import serial
import json

pass_mongo = pass_mongo()
CONNECTION_STRING = "mongodb://mikoalfandi2801:{}@ac-ot6qz3s-shard-00-00.0lhj5a0.mongodb.net:27017,ac-ot6qz3s-shard-00-01.0lhj5a0.mongodb.net:27017,ac-ot6qz3s-shard-00-02.0lhj5a0.mongodb.net:27017/?ssl=true&replicaSet=atlas-chy1ff-shard-0&authSource=admin&retryWrites=true&w=majority".format(
    pass_mongo)
client = MongoClient(CONNECTION_STRING)
dbname = client["ekgApp"]
db_ekg = dbname["ekg"]

ser = serial.Serial('COM8', '9600')

last_ekg_id = None

db_ekg.insert_one({'data': 0})

tmzone = pytz.timezone('asia/jakarta')

waktu = 0

async_mode = None
app = Flask(__name__)
app.config['SECRET_KEY'] = 'donsky!'
socketio = SocketIO(app, cors_allowed_origins='*', async_mode=async_mode)


def get_current_datetime():
    now = datetime.now()
    return now.strftime("%m/%d/%Y %H:%M:%S")


def background_thread(ev, last_data_id, db):
    while True:
        global last_ekg_id
        global tmzone

        if last_data_id == None:
            last_data_id = db.find().sort('_id', -1).limit(3)[0]['_id']
        last_data = db.find({
            '_id': {
                '$gt': last_data_id
            }
        }).limit(1)
        try:
            last_data_id = last_data[0]['_id']
            time = last_data_id.generation_time.astimezone(tmzone)
            data = last_data[0]['data']
            socketio.emit(ev, {'value': data, "date": "{}:{}".format(
                str(time.hour), str(time.minute))})
        except:
            None
        t.sleep(1)


def save_data(message):
    global db_ekg

    data_ekg = float(message['data_ekg'])
    data_waktu = message['data_waktu']

    db_ekg.insert_one({'data': data_ekg, 'data_waktu': data_waktu})

    socketio.emit('save_data', {'data': 'data_ekg : {}'.format(data_ekg)})


while True:
    while (ser.inWaiting() == 0):
        pass
    s = str(ser.readline(), 'utf-8')
    try:
        raw_ekg = float(s)
        ekg = raw_ekg * (1.5 / 1023)
        data_to_save = {'data_ekg': ekg, 'data_waktu': get_current_datetime()}
        save_data(data_to_save)
    except ValueError as e:
        print(e)


@socketio.event()
def ekg():
    socketio.start_background_task(
        background_thread('resp_ekg', last_ekg_id, db_ekg))


@socketio.on('connect')
def connect():
    print('connected')


@socketio.on('disconnect')
def disconnect():
    print('Client disconnected', request.sid)


if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', debug=True)
