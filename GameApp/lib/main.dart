import 'package:flutter/material.dart';
import 'api_client.dart'; // Import the ApiClient

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
  List<int> digits = [2, 4, 6, 8];
  List<String> symbols = ['+', '-', '*', '/', '(', ')'];
  List<List<String?>> selectedValues = List.generate(11, (_) => [null]);

  void startNewGame() {
    ApiClient.newGame((List<int> newDigits) {
      setState(() {
        // Update the digits value with the new data
        digits = newDigits;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('24 Game Solver'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: startNewGame,
                child: Text('New Game'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // Call the method to calculate the game
                  ApiClient.calculate();
                },
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
                        ApiClient.updateValue(i, value);
                        print('Dropdown Item Index: $i, Value: $value');

                      });
                    },
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
