from game_deck_generator import GameDeckGenerator

class Game:
    def __init__(self):
        deck_generator = GameDeckGenerator()
        self.digits = deck_generator.random_one_set()
    