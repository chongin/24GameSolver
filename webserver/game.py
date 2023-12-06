from game_deck_generator import GameDeckGenerator
from serial_comunication import SerialCommunication


class Game:
    MAX_ITEMS = 11
    
    def __init__(self, serial_communication: SerialCommunication, win_led, lost_led) -> None:
        deck_generator = GameDeckGenerator()
        self.digits = deck_generator.random_one_set()
        self.items = [None] * self.MAX_ITEMS
        self.serial_comunication = serial_communication
        self.win_led = win_led
        self.lost_led = lost_led

        self.send_new_game_data()
        
    def compose_formula(self):
        formula_items = [str(item) for item in self.items if item is not None]
        formula = ''.join(formula_items)
        return formula

    def send_new_game_data(self):
        data = {
            "digits": self.digits
        }
        self.lost_led.off()
        self.win_led.off()
        self.serial_comunication.send_data("new_game", data)

    def update_value(self, index: int, value: str) -> dict:
        print(f"Receive update_value index: {index}, value: {value}")
        if (0 <= index < len(self.items)):
            self.items[index] = value
            self.serial_comunication.send_data("update_value", {
                'index': index,
                'value': value
            })
            return {
                'index': index,
                'value': value
            }
        else:
            return {
                'error': 'OverRangeError',
                'index': index,
                'value': value
            }

    def delete_value(self, index: int) -> dict:
        print(f"Receive delete_value index: {index}, value")
        if (0 <= index < len(self.items)):
            self.items[index] = None
            self.serial_comunication.send_data("delete_value", {
                'index': index
            })
            
            return {
                'index': index
            }
        else:
            return {
                'error': 'OverRangeError',
                'index': index
            }
    def calculate_result(self, formula: str):
        current_formula = self.compose_formula()
        if current_formula != formula:
            return {
                'error': f"Formula is not match with server one: #{current_formula}",
                'formula': formula
            }
        
        result = self.calc_formula(formula)
        self.serial_comunication.send_data("show_result", {
            'result': f"{current_formula}={(int)(result)}"
        })

        if result == 24:
            self.win_led.on()
            self.lost_led.off()
        else:
            self.win_led.off()
            self.lost_led.on()

        return {
            'result': int(result),
            'win': result == 24
        }
    
    def clear_value(self):
        for item in self.items:
            item = None

        self.serial_comunication.send_data("clear_value", "")
        return {
            'result': 'OK'
        }
        

    def evaluate_formula(self, formula):
        formula = formula.replace(" ", "")
        num = 0
        op = '+'
        result = 0
        term = 0
        i = 0
        while i < len(formula):
            ch = formula[i]

            if ch.isdigit() or ch == '.':
                num_string = ""
                while i < len(formula) and (formula[i].isdigit() or formula[i] == '.'):
                    num_string += formula[i]
                    i += 1
                i -= 1

                num = float(num_string)
                if op == '+':
                    result += term
                    term = num
                elif op == '-':
                    result += term
                    term = -num
                elif op == '*':
                    term *= num
                elif op == '/':
                    term /= num

            elif ch in ['+', '-', '*', '/']:
                op = ch

            i += 1

        result += term

        return result


    def has_parentheses(self, formula):
        return '(' in formula


    def calc_formula(self, formula):
        formula = formula.replace(" ", "")
        while self.has_parentheses(formula):
            start_index = formula.rfind('(')
            end_index = formula.find(')', start_index)
            if end_index < 0:
                return -9999.0

            sub_formula = formula[start_index + 1:end_index]
            value = self.calc_formula(sub_formula)
            formula = formula.replace("(" + sub_formula + ")", str(value))
            print(formula)
        return self.evaluate_formula(formula)
