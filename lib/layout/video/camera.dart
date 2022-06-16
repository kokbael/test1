import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:test1/layout/video/video.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;
  CameraLensDirection? _cameraLensDirection;

  @override
  void initState() {
    super.initState();
    _cameraLensDirection = CameraLensDirection.front;
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras
        .firstWhere((camera) => camera.lensDirection == _cameraLensDirection);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoPage(filePath: file.path),
      );
      Navigator.push(context, route);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CameraPreview(_cameraController),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 40,
                height: 40,
              ),
              FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(_isRecording ? Icons.stop : Icons.circle),
                onPressed: () => _recordVideo(),
              ),
              !_isRecording
                  ? InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        if (_cameraLensDirection == CameraLensDirection.back) {
                          _cameraLensDirection = CameraLensDirection.front;
                          _initCamera();
                        } else {
                          _cameraLensDirection = CameraLensDirection.back;
                          _initCamera();
                        }
                      },
                      child: Icon(
                        Icons.change_circle_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                    )
                  : SizedBox(
                      width: 40,
                      height: 40,
                    ),
            ],
          ),
        ),
      );
    }
  }
}
