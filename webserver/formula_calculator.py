class FormulaEvaluator:
    @staticmethod
    def evaluate_formula(formula):
        # Remove all whitespaces from the formula
        formula = formula.replace(" ", "")

        # Temporary variables for number and operator
        num = 0
        op = '+'

        # Variables to keep track of the accumulated result and the term value
        result = 0
        term = 0

        # Process each character in the formula
        i = 0
        while i < len(formula):
            ch = formula[i]

            # If the character is a digit or decimal point, extract the whole number
            if ch.isdigit() or ch == '.':
                num_string = ""
                while i < len(formula) and (formula[i].isdigit() or formula[i] == '.'):
                    num_string += formula[i]
                    i += 1
                i -= 1

                # Convert the number string to a float
                num = float(num_string)

                # Apply the operator to the accumulated result
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
            # If the character is an operator (+, -, *, /), update the current operator
            elif ch in ['+', '-', '*', '/']:
                op = ch

            i += 1

        # Add the last term to the accumulated result
        result += term

        return result

    @staticmethod
    def has_parentheses(formula):
        return '(' in formula

    @staticmethod
    def calc_formula(formula):
        formula = formula.replace(" ", "")
        while FormulaEvaluator.has_parentheses(formula):
            start_index = formula.rfind('(')
            end_index = formula.find(')', start_index)
            if end_index < 0:
                return -9999.0

            sub_formula = formula[start_index + 1:end_index]
            value = FormulaEvaluator.calc_formula(sub_formula)
            formula = formula.replace("(" + sub_formula + ")", str(value))

        return FormulaEvaluator.evaluate_formula(formula)


# Example usage:
formula = "(2+3*4) * (3 + 4) - 3"
result = FormulaEvaluator.calc_formula(formula)
print(result)
