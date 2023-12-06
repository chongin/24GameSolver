import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'calculator.dart';
import 'camera_view.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '24 Game Solver',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CameraDescription selectedCamera;
  final firstLine = "How to Play";
  final secondLine = "Make the number 24 from the four numbers shown. You can add, subtract, multiply and divide. Use all four numbers on the card, but use each number only once. ";

  late List<CameraDescription>? cameras;
  bool isCameraInitialized = false;
  @override
  void initState() {
    super.initState();
    initializeCameras();
  }

  Future<void> initializeCameras() async {
    cameras = await availableCameras();
    selectedCamera = cameras!.first;
    if (mounted) {
      setState(() {
        isCameraInitialized = true;
      }); // Trigger a rebuild after obtaining cameras
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isCameraInitialized) {
      // Show loading or error indicator
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '24 Game Solver',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.lightBlue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    firstLine,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    secondLine,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: CalculatorUI(),
                  ),
                  Column(
                    children: [
                      DropdownButton<CameraDescription>(
                        value: selectedCamera,
                        onChanged: (CameraDescription? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedCamera = newValue;
                            });
                          }
                        },
                        items: cameras!
                            .map<DropdownMenuItem<CameraDescription>>(
                              (CameraDescription camera) {
                            return DropdownMenuItem<CameraDescription>(
                              value: camera,
                              child: Text(camera.name),
                            );
                          },
                        ).toList(),
                      ),
                      Expanded(
                        child: CameraView(camera: selectedCamera),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
