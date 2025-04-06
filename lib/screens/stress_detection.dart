import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class StressDetectionScreen extends StatefulWidget {
  @override
  _StressDetectionState createState() => _StressDetectionState();
}

class _StressDetectionState extends State<StressDetectionScreen> {
  late CameraController _cameraController;
  late FaceDetector _faceDetector;
  bool isDetecting = false;
  String _stressResult = "Analyzing stress...";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(enableLandmarks: true),
    );
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _cameraController = CameraController(cameras[1], ResolutionPreset.medium);
      await _cameraController.initialize();
      _startImageStream();
      setState(() {});
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  void _startImageStream() {
    _cameraController.startImageStream((CameraImage image) async {
      if (isDetecting) return;
      isDetecting = true;

      final inputImage = InputImage.fromBytes(
        bytes: image.planes[0].bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotation.rotation0deg,
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );

      await _processImage(inputImage);
      isDetecting = false;
    });
  }

  Future<void> _processImage(InputImage inputImage) async {
    final faces = await _faceDetector.processImage(inputImage);

    for (Face face in faces) {
      final leftEyebrow = face.landmarks[FaceLandmarkType.leftEye];
      final rightEyebrow = face.landmarks[FaceLandmarkType.rightEye];
      final upperLip = face.landmarks[FaceLandmarkType.bottomMouth];
      final lowerLip = face.landmarks[FaceLandmarkType.noseBase];

      if (leftEyebrow != null && rightEyebrow != null) {
        final eyebrowDistance =
            (rightEyebrow.position.y - leftEyebrow.position.y).abs();
        print('Eyebrow Distance: $eyebrowDistance');

        if (eyebrowDistance > 10) {
          setState(() => _stressResult = "High Stress Detected: 80%");
        } else if (eyebrowDistance > 5) {
          setState(() => _stressResult = "Moderate Stress: 50%");
        } else {
          setState(() => _stressResult = "Low Stress: 20%");
        }
      }

      if (upperLip != null && lowerLip != null) {
        final lipDistance = (upperLip.position.y - lowerLip.position.y).abs();
        print('Lip Distance: $lipDistance');

        if (lipDistance > 20) {
          setState(() => _stressResult = "High Stress Detected: 75%");
        }
      }
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stress Detection'),
        backgroundColor: const Color(0xFF436286),
      ),
      body: _cameraController.value.isInitialized
          ? Stack(
              children: [
                CameraPreview(_cameraController),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      _stressResult,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
