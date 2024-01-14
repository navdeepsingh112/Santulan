import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _initializeControllerFuture = initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      print('No cameras available');
      return;
    }

    _controller = CameraController(
      cameras[1],
      ResolutionPreset.medium,
    );

    return _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Example'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _takePicture();
        },
        child: Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      XFile picture = await _controller.takePicture();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(imagePath: picture.path),
        ),
      );
    } catch (e) {
      print("Error: $e");
    }
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  DisplayPictureScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Picture'),
      ),
      body: _buildImageWidget(),
    );
  }

  Widget _buildImageWidget() {
    // Check if the app is running on web
    if (kIsWeb) {
      // If running on web, use Image.network for web images
      return Image.network(imagePath);
    } else {
      // If running on mobile, use Image.file for local file images
      return Image.file(File(imagePath));
    }
  }
}
