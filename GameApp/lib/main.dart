import 'dart:async';
import 'api_client.dart';
import 'error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'calculator.dart';
import 'camera_view.dart';

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
        body: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: CalculatorUI(),
                ),
                CameraView(cameras: widget.cameras),
              ],
            )

        )
    );
  }
}
