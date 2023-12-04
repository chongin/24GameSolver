from flask import Flask, jsonify, request
from flask_cors import CORS
from game import Game
from serial_comunication import SerialCommunication
import threading

app = Flask(__name__)
CORS(app) 

current_game = None

port = '/dev/cu.usbmodem1301'
serial_comunication = SerialCommunication(port)

serial_thread = threading.Thread(target=serial_comunication.run_communication)
serial_thread.start()

@app.route('/games/new_game', methods=['GET'])
def new_game():
   current_game = Game(serial_comunication)
   return jsonify({'digits': current_game.digits})

@app.route('/games/update/index/<int:index>/value/<string:value>', methods=['GET'])
def update_value(index, value):
   pass

@app.route('/games/calculate_result', methods=['POST'])
def calculate_result(formula):
   pass

if __name__ == '__main__':
    app.run(debug=True)
