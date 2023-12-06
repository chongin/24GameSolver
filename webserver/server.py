from flask import Flask, jsonify, request
from flask_cors import CORS
from game import Game
from serial_comunication import SerialCommunication
import threading
#from led import WinLED,LoseLED

app = Flask(__name__)
CORS(app) 

class MockSerialCommunication:
   def __init__(self, port):
      print("Mock serial communication")
      pass

   def send_data(self, command, data):
      pass

   def read_data(self):
      pass

   def run_communication(self):
      pass

class MockWinLed:
   def on(self):
      print("Win led on")

   def off(self):
      print("Win led off")

class MockLoseLed:
   def on(self):
      print("Lose led on")

   def off(self):
      print("Lose led off")

mock = False
current_game = None
port = '/dev/cu.usbmodem11401'
serial_comunication = SerialCommunication(port) if not mock else MockSerialCommunication(port)
win_led = MockWinLed()
lose_led = MockLoseLed()
serial_thread = threading.Thread(target=serial_comunication.run_communication)
serial_thread.start()

@app.route('/games/new_game', methods=['GET'])
def new_game():
   global current_game
   current_game = Game(serial_comunication, win_led, lose_led)
   return jsonify({'digits': current_game.digits})

@app.route('/games/update_value', methods=['POST'])
def update_value():
   data = request.get_json()
   index = data.get('index')
   value = data.get('value')
   result = current_game.update_value(index, value)
   return jsonify(result)

@app.route('/games/calculate_result', methods=['POST'])
def calculate_result():
   global current_game
   data = request.get_json()
   formula = data.get('formula')
   
   if formula is not None:
      print(f"333333 {formula}")
      result = current_game.calculate_result(formula)
      return jsonify(result)
   else:
        return jsonify({"error": "Missing 'formula' in the request body"})
   
@app.route('/games/clear_formula', methods=['POST'])
def clear_value():
   data = request.get_json()
   result = current_game.clear_value()
   return jsonify(result)

if __name__ == '__main__':
    app.run(debug=True)
