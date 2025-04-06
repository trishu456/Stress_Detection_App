import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class TimerScreen extends StatefulWidget {
  final int duration;

  TimerScreen({required this.duration});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _seconds = 0;
  Timer? _timer;

  void _startTimer() {
    if (_timer != null && _timer!.isActive) {
      return;
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
      if (_seconds == widget.duration * 60) {
        _timer?.cancel();
        _showCompletionDialog();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _seconds = 0;
    });
  }

  Future<void> _saveFeedback(String feedback) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_feedback', feedback);
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline,
                  size: 60, color: Colors.green.shade600),
              SizedBox(height: 20),
              Text(
                'Time\'s Up!',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade600),
              ),
              SizedBox(height: 10),
              Text(
                'You have completed the recommended ${widget.duration} minutes of exercise!',
                style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('OK',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton(
      IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 28, color: Colors.white),
      label: Text(label, style: TextStyle(fontSize: 14, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF436286),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you satisfied with our app?',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['😃', '😊', '😐', '😞', '😡']
                    .map((emoji) => _emojiButton(emoji))
                    .toList(),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emojiButton(String emoji) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _showThankYouDialog();
      },
      child: Text(emoji, style: TextStyle(fontSize: 40)),
    );
  }

  void _showThankYouDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Thank you for your feedback!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF436286), // Title color
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF436286), // Button background
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // Button text color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int minutes = _seconds ~/ 60;
    final int seconds = _seconds % 60;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF436286),
        title: Text('Exercise Timer',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFFF8F8F8),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Recommended Duration: ${widget.duration} minutes',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700),
                ),
                SizedBox(height: 20),
                Text(
                  'Elapsed Time: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                  style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                SizedBox(height: 40),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 15,
                  runSpacing: 10,
                  children: [
                    _buildControlButton(Icons.play_arrow, 'Start', _startTimer),
                    _buildControlButton(Icons.stop, 'Stop', _stopTimer),
                    _buildControlButton(Icons.refresh, 'Reset', _resetTimer),
                    _buildControlButton(
                        Icons.flag, 'Finish', _showFeedbackDialog),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
