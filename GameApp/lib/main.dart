import 'dart:async';
import 'api_client.dart';
import 'error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'calculator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '24 Game Solver',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(cameras: cameras),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  MyHomePage({Key? key, required this.cameras}) : super(key: key);

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
  bool isGameStarted = false;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late CameraDescription _selectedCamera;

  @override
  void initState() {
    super.initState();
    _selectedCamera = widget.cameras.first;
    _controller = CameraController(
      _selectedCamera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

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
    _timer = Timer(Duration.zero, () {});
    ;
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
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
        body: Row(
          children: [
            Expanded(
              child: CalculatorUI(),
            ),
            Container(
              width: 700, // Adjust the width as needed
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Transform.scale(
                      scale: _controller.value.aspectRatio / MediaQuery.of(context).size.aspectRatio,
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: CameraPreview(_controller),
                        ),
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        )
    );
  }

  List<DropdownMenuItem<String?>> getDropdownItems() {
    List<String> items = [
      ...symbols,
      ...digits.map((digit) => digit.toString())
    ];

    return items
        .map(
          (item) =>
          DropdownMenuItem<String?>(
            value: item,
            child: Text(item),
          ),
    )
        .toList();
  }

  Future<bool> startNewGame() async {
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
      return true;
    } catch (error) {
      DialogUtils.showErrorDialog(context,
          'An error occurred while processing the startNewGame: $error');
      return false;
    }
  }

  Future<void> updateValue(int index, String? value) async {
    try {
      await ApiClient.updateValue(index, value);
    } catch (error) {
      DialogUtils.showErrorDialog(context,
          'An error occurred while processing the updateValue: $error');
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
    } catch (error) {
      DialogUtils.showErrorDialog(context,
          'An error occurred while processing the calculateAndUpdateResult: $error');
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
  _CustomDropdownButtonState<T> createState() =>
      _CustomDropdownButtonState<T>();
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
