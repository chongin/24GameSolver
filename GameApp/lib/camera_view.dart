// camera_view.dart

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraView extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraView({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
