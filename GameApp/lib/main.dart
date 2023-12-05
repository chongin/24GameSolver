import 'package:flutter/material.dart';
import 'api_client.dart'; // Import the ApiClient
import 'dart:async';
import 'error_dialog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '24 Game Solver',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> digits = [-1, -1, -1, -1];
  List<String> symbols = ['+', '-', '*', '/', '(', ')'];
  List<List<String?>> selectedValues = List.generate(11, (_) => [null]);
  String resultLabel = "Waiting Result";
  late Timer _timer = Timer(Duration.zero, () {});
  int _timerSeconds = 120; // Initial value for the timer

  void startTimer() {
    stopTimer();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          // Timer has reached 0, show popup and update result
          _timer.cancel();
          _showTimeoutDialog();
          resultLabel = "You are Lost!";
        }
      });
    });
  }

  void stopTimer() {
    _timer.cancel();
    _timer = Timer(Duration.zero, () {});;
  }

  Future<void> _showTimeoutDialog() async {
    await showDialog(
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '24 Game Solver',
          style: TextStyle(
            fontSize: 30, // Adjust the font size as needed
            fontWeight: FontWeight.bold, // Add bold font weight
            color: Colors.deepPurple, // Set your desired color
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                padding: EdgeInsets.all(60),
                decoration: BoxDecoration(
                  color: Colors.blue, // Set your desired background color
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Time Remain: $_timerSeconds seconds',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set your desired text color
                  ),
                ),
              ),
            ]
          ),

          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: startNewGame,
                child: Text('New Game'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: calculateAndUpdateResult,
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
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        digit.toString(),
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
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
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        symbol,
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
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
              for (int i = 0; i < 11; i++)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomDropdownButton(
                    items: getDropdownItems(),
                    value: selectedValues[i][0],
                    onChanged: (String? value) {
                      setState(() {
                        selectedValues[i][0] = value;
                        updateValue(i, value);
                        print('Dropdown Item Index: $i, Value: $value');

                      });
                    },
                  ),
                ),
            ],
          ),
          // New row for the label
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: resultLabel.contains('win') ? Colors.green : Colors.red, // Green for win, red for lose
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

  List<DropdownMenuItem<String?>> getDropdownItems() {
    List<String> items = [...symbols, ...digits.map((digit) => digit.toString())];

    return items
        .map(
          (item) => DropdownMenuItem<String?>(
        value: item,
        child: Text(item),
      ),
    )
        .toList();
  }

  Future<void> startNewGame() async {
    try {
      await ApiClient.newGame((List<int> newDigits) {
        setState(() {
          // Update the digits value with the new data
          digits = newDigits;
          selectedValues = List.generate(11, (_) => [null]);
          resultLabel = "Waiting Result";
          _timerSeconds = 120; // Reset timer to initial value
          startTimer(); // Start the timer on New Game
        });
      });
    }
    catch (error) {
      DialogUtils.showErrorDialog(context, 'An error occurred while processing the startNewGame: $error');
    }
  }

  Future<void> updateValue(int index, String? value) async {
    try {
      await ApiClient.updateValue(index, value);
    }
    catch (error) {
      DialogUtils.showErrorDialog(context, 'An error occurred while processing the updateValue: $error');
    }
  }

  Future<void> calculateAndUpdateResult() async {
    stopTimer();
    // Filter out null values from the selected dropdown values
    List<String> selectedValuesList = selectedValues
        .where((list) => list[0] != null)
        .map((list) => list[0]!)
        .toList();

    // Compose the selected values into a string
    String formula = selectedValuesList.join();

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
    }
    catch (error) {
      DialogUtils.showErrorDialog(context, 'An error occurred while processing the calculateAndUpdateResult: $error');
    }
  }
}

class CustomDropdownButton<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;

  CustomDropdownButton({
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  _CustomDropdownButtonState<T> createState() => _CustomDropdownButtonState<T>();
}

class _CustomDropdownButtonState<T> extends State<CustomDropdownButton<T>> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      items: widget.items,
      value: widget.value,
      onChanged: widget.onChanged,
    );
  }
}
