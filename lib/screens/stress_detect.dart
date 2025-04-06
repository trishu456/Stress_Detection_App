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

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _faceDetector =
        FaceDetector(options: FaceDetectorOptions(enableLandmarks: true));
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await _cameraController.initialize();
    _startImageStream();
    setState(() {});
  }

  void _startImageStream() {
    _cameraController.startImageStream((CameraImage image) async {
      if (isDetecting) return;
      isDetecting = true;

      final InputImage inputImage = InputImage.fromBytes(
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
    final List<Face> faces = await _faceDetector.processImage(inputImage);

    for (Face face in faces) {
      final leftEyebrow = face.landmarks[FaceLandmarkType.leftEye];
      final rightEyebrow = face.landmarks[FaceLandmarkType.rightEye];
      final upperLip = face.landmarks[FaceLandmarkType.bottomMouth];
      final lowerLip = face.landmarks[FaceLandmarkType.noseBase];

      if (rightEyebrow != null && leftEyebrow != null) {
        double eyebrowDistance =
            (rightEyebrow.position.y - leftEyebrow.position.y).abs().toDouble();
        print('Eyebrow Distance: $eyebrowDistance');
      }

      if (upperLip != null && lowerLip != null) {
        double lipDistance =
            (upperLip.position.y - lowerLip.position.y).abs().toDouble();
        print('Lip Distance: $lipDistance');
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
      appBar: AppBar(title: Text('Stress Detection')),
      body: _cameraController.value.isInitialized
          ? CameraPreview(_cameraController)
          : Center(child: CircularProgressIndicator()),
    );
  }
}
