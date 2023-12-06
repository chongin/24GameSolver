from flask import Flask, jsonify, request
from flask_cors import CORS
from game import Game
from serial_comunication import SerialCommunication
import threading

app = Flask(__name__)
CORS(app) 

class MockSerialCommunication:
   def __init__(self, port):
      print("Mock serial communication")
      pass

   def send_data(self, command, data):
      print(f"mock send command: {command}, data: {data}")
      pass

   def read_data(self):
      pass

   def run_communication(self):
      pass

class MockWinLed:
   def handle_on(self):
      print("Win led on")

   def handle_off(self):
      print("Win led off")

class MockLoseLed:
   def handle_on(self):
      print("Lose led on")

   def off(self):
      handle_off("Lose led off")

mock = False
current_game = None
serial_comunication = None
win_led = None
lose_led = None

#port = '/dev/cu.usbmodem11401'
port = '/dev/ttyACM1'

if mock is True:
   serial_comunication = MockSerialCommunication(port)
   win_led = MockWinLed()
   lose_led = MockLoseLed()
else:
   serial_comunication = SerialCommunication(port)
   from led import WinLED,LoseLED
   win_led = WinLED()
   lose_led = LoseLED()


serial_thread = threading.Thread(target=serial_comunication.run_communication)
serial_thread.start()

def check_error_key(data):
    if "error" in data:
        return 400
    else:
        return 200

@app.route('/games/new_game', methods=['GET'])
def new_game():
   global current_game
   current_game = Game(serial_comunication, win_led, lose_led)
   print(f"response: {current_game.digits}")
   return jsonify({'digits': current_game.digits}), 200

@app.route('/games/update_value', methods=['POST'])
def update_value():
   data = request.get_json()
   index = data.get('index')
   value = data.get('value')
   result = current_game.update_value(index, value)
   print(f"response: {result}")
   return jsonify(result), check_error_key(result)

@app.route('/games/calculate_result', methods=['POST'])
def calculate_result():
   global current_game
   data = request.get_json()
   formula = data.get('formula')
   
   if formula is not None:
      result = current_game.calculate_result(formula)
      print(f"response: {result}")
      return jsonify(result), check_error_key(result)
   else:
        return jsonify({"error": "Missing 'formula' in the request body"}), 400
   
@app.route('/games/clear_formula', methods=['POST'])
def clear_value():
   data = request.get_json()
   result = current_game.clear_value()
   return jsonify(result), check_error_key(result)

@app.route('/games/delete_value', methods=['POST'])
def delete_value():
   data = request.get_json()
   index = data.get('index')
   result = current_game.delete_value(index)
   print(f"response: {result}")
   return jsonify(result), check_error_key(result)

if __name__ == '__main__':
    app.run(host='192.168.0.115', debug=True)
