import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> digits = [];
  List<String> symbols = ['(', ')', '+', '-', '*', '/'];

  @override
  void initState() {
    super.initState();
    // Mock API call for demo purposes
    mockApiCall().then((List<int> result) {
      setState(() {
        digits = result;
      });
    });
  }

  Future<List<int>> mockApiCall() async {
    // Simulating an API call delay
    await Future.delayed(Duration(seconds: 2));

    // Mock response from the server
    return [2, 4, 6, 8]; // Replace with your actual API response
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
        ],
      ),
    );
  }
}
