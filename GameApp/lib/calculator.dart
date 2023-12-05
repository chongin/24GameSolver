import 'dart:async';
import 'package:flutter/material.dart';
import 'api_client.dart';
import 'error_dialog.dart';
import 'clock.dart';

class CalculatorUI extends StatefulWidget {
  @override
  _CalculatorUIState createState() => _CalculatorUIState();
}

class _CalculatorUIState extends State<CalculatorUI> {
  int _timerSeconds = 0;
  bool isGameStarted = false;
  String resultLabel = 'Welcome to play';
  TextEditingController formulaController = TextEditingController();
  List<int> digits = [1, 2, 3, 4];
  List<String> symbols = ['(', ')', '+', '-', '*', '/',];

  late ClockUI clockUI;

  @override
  void initState() {
    super.initState();
    clockUI = ClockUI(onTimeout: handleTimeout);
  }

  void handleTimeout() {
    // Handle timeout logic here
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Timeout'),
          content: Text('Sorry, you ran out of time!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    setState(() {
      resultLabel = "You are Lost!";
    });
  }

  void startTimer() {
    // clockUI.startTimer();
  }

  void stopTimer() {
    // clockUI.stopTimer();
  }

  Future<void> onDigitButtonPressed(String digit) async {
    bool success = await updateValue(formulaController.text.length, digit);
    if ( success == true) {
      formulaController.text = formulaController.text + digit;
    }
  }

  Future<void> onSymbolButtonPressed(String symbol) async {
    bool success = await updateValue(formulaController.text.length, symbol);
    if ( success == true) {
      formulaController.text = formulaController.text + symbol;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClockUI(onTimeout: handleTimeout),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  bool success = await startNewGame();
                  setState(() {
                    isGameStarted = success;
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('New Game'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: isGameStarted ? () async {
                  await calculateAndUpdateResult();
                  setState(() {
                    isGameStarted = false;
                  });
                } : null,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Calculate'),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Numbers:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),
              for (int digit in digits)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: isGameStarted ? () async {
                      await onDigitButtonPressed(digit.toString());
                    }: null,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text(
                      digit.toString(),
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Symbols:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),
              for (String symbol in symbols)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: isGameStarted ? () async {
                      await onSymbolButtonPressed(symbol);
                    }: null,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.yellow,
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text(
                      symbol,
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Formula:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: formulaController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your formula',
                  ),
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: resultLabel.contains('win') ? Colors.green : Colors.red,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    resultLabel,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> startNewGame() async {
    try {
      await ApiClient.newGame((List<int> newDigits) {
        setState(() {
          // Update the digits value with the new data
          resetData();
          digits = newDigits;

          startTimer(); // Start the timer on New Game
        });
      });
      return true;
    } catch (error) {
      DialogUtils.showErrorDialog(context,
          'An error occurred while processing the startNewGame: $error');
      return false;
    }
  }

  Future<void> calculateAndUpdateResult() async {
    stopTimer();
    // Set the formula directly from the text field
    String formula = formulaController.text;

    try {
      // Call the API to calculate the result
      int result = await ApiClient.calculateFormula(formula);

      // Update the result label
      setState(() {
        if (result == 24) {
          resultLabel = '$result: You win!';
        } else {
          resultLabel = '$result: You lost!';
        }
      });
    } catch (error) {
      DialogUtils.showErrorDialog(context,
          'An error occurred while processing the calculateAndUpdateResult: $error');
    }
  }

  Future<bool> updateValue(int index, String value) async {
    try {
      await ApiClient.updateValue(index, value);
      return true;
    } catch (error) {
      DialogUtils.showErrorDialog(context,
          'An error occurred while processing the updateValue: $error');
      return false;
    }
  }

  void resetData() {
    digits = [1,2,3,4];
    resultLabel = "Waiting Result";
    _timerSeconds = 120;
    formulaController.text = "";
  }
}
