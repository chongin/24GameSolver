from game_deck_generator import GameDeckGenerator
from serial_comunication import SerialCommunication


class Game:
    def __init__(self, serial_communication: SerialCommunication) -> None:
        deck_generator = GameDeckGenerator()
        self.digits = deck_generator.random_one_set()
        self.serial_comunication = serial_communication
        self.send_new_game_data()
        
        
    def send_new_game_data(self):
        data = {
            "digits": self.digits
        }
        self.serial_comunication.send_data("new_game", data)