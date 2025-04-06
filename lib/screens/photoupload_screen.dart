import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PhotoUploadScreen extends StatefulWidget {
  @override
  _PhotoUploadScreenState createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  String _stressResult = "No analysis yet.";

  Future<void> _startStressDetection() async {
    try {
      final Uri url = Uri.parse(
          'http://192.168.213.195:5000/detect_stress'); // Flask server IP

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          _stressResult = result["message"] ?? "No message received.";
        });
      } else {
        setState(() {
          _stressResult = "Error: ${response.statusCode} - ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _stressResult = "Failed to connect to API: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photo Upload for Stress Detection"),
        backgroundColor: Color(0xFF436286),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 100, color: Color(0xFF436286)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startStressDetection,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF436286),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Start Stress Detection",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _stressResult,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
