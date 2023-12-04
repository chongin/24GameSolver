from flask import Flask, jsonify, request
from flask_cors import CORS
from game import Game

app = Flask(__name__)
CORS(app) 

current_game = None

@app.route('/games/new_game', methods=['GET'])
def new_game():
   current_game = Game()
   return jsonify({'digits': current_game.digits})

@app.route('/games/update/index/<int:index>/value/<string:value>', methods=['GET'])
def update_value(index, value):
   pass

@app.route('/games/calculate_result', methods=['POST'])
def calculate_result(formula):
   pass

if __name__ == '__main__':
    app.run(debug=True)
