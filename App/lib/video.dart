import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart' as camera;
import 'package:green_quest/home1.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as thumbnail;

class CameraFloatingButton extends StatefulWidget {
  @override
  _CameraFloatingButtonState createState() => _CameraFloatingButtonState();
}

class _CameraFloatingButtonState extends State<CameraFloatingButton> {
  late camera.CameraController _controller;
  bool isRecording = false;
  List<Image> frameImages = [];
  bool isRecordingCompleted = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _initializeController() async {
    final cameras = await camera.availableCameras();
    _controller = camera.CameraController(
      cameras[1],
      camera.ResolutionPreset.high,
    );
    await _controller.initialize();
  }

  Future<void> _startRecording() async {
    await _initializeController();

    showDialog(
      context: context,
      barrierDismissible: true, // prevent dialog from closing on outside tap
      builder: (context) {
        return RecordingDialog(
          controller: _controller,
          onStartRecording: () {
            _startRecordingLogic();
          },
        );
      },
    );
  }

  Future<void> _startRecordingLogic() async {
    await _controller.startVideoRecording();

    // Record for 2.5 seconds
    await Future.delayed(Duration(seconds: 2, milliseconds: 500));

    // Stop recording
    await _stopRecording();

    // Dispose the camera controller
    await _controller.dispose();

    setState(() {
      isRecording = false;
      isRecordingCompleted = true;
    });
  }

  Future<void> _stopRecording() async {
    if (isRecording) {
      // If recording, stop recording
      camera.XFile videoFile = await _controller.stopVideoRecording();
      Navigator.of(context).pop();
      // Extract frames
      List<Uint8List?> frames = await _extractFrames(videoFile.path);

      // Display frames on the main page
      _displayFrames(frames);
    }
  }

  Future<List<Uint8List?>> _extractFrames(String videoPath) async {
    List<Uint8List?> frames = [];

    for (double timeInSeconds in [0.5, 1.0, 2.0]) {
      Uint8List? frame = await thumbnail.VideoThumbnail.thumbnailData(
        video: videoPath,
        maxWidth: 128,
        imageFormat: thumbnail.ImageFormat.JPEG, // Change the format to JPEG
        timeMs: (timeInSeconds * 1000).toInt(),
        quality: 5 - 0,
      );
      frames.add(frame);
    }

    return frames;
  }

  void _displayFrames(List<Uint8List?> frames) {
    setState(() {
      frameImages.clear();
      frames.forEach((frame) {
        if (frame != null) {
          frameImages.add(Image.memory(frame));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('100 Days plant challange'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: frameImages.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemBuilder: (context, index) {
                return frameImages[index];
              },
            ),
          ),
          if (isRecordingCompleted)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Add submit logic here
                      print('Submit button pressed!');
                      Navigator.pop(context);
                    },
                    child: Text('Submit'),
                  ),
                ),
                SizedBox(
                  height: 60,
                )
              ],
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              if (!isRecording) {
                // If not recording, start recording
                setState(() {
                  isRecording = true;
                  isRecordingCompleted = false;
                });
                _startRecording();
              }
            },
            child: isRecording ? Icon(Icons.stop) : Icon(Icons.camera),
          ),
        ],
      ),
    );
  }
}

class RecordingDialog extends StatefulWidget {
  final camera.CameraController controller;
  final VoidCallback onStartRecording;

  const RecordingDialog({
    Key? key,
    required this.controller,
    required this.onStartRecording,
  }) : super(key: key);

  @override
  _RecordingDialogState createState() => _RecordingDialogState();
}

class _RecordingDialogState extends State<RecordingDialog> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: IntrinsicHeight(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: widget.controller.value.aspectRatio,
              child: camera.CameraPreview(widget.controller),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onStartRecording();
              },
              child: Text('Start Recording'),
            ),
          ],
        ),
      ),
    );
  }
}
