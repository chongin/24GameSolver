// camera_view.dart

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraView extends StatefulWidget {
  final CameraDescription camera;

  CameraView({Key? key, required this.camera}) : super(key: key);

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
    _selectedCamera = widget.camera;
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
  void didUpdateWidget(CameraView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.camera != oldWidget.camera) {
      _selectedCamera = widget.camera;
      _controller = CameraController(
        _selectedCamera,
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800, // Adjust the width as needed
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
