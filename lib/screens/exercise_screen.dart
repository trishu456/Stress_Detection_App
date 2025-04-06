import 'package:flutter/material.dart';
import 'timer_screen.dart';

class ExerciseScreen extends StatefulWidget {
  final int stressScore;

  ExerciseScreen({required this.stressScore});

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen>
    with TickerProviderStateMixin {
  bool _isDescriptionVisible = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeInOut));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int recommendedDuration = widget.stressScore >= 12
        ? 20
        : widget.stressScore >= 7
            ? 15
            : 10;

    final String exerciseRecommendation = widget.stressScore >= 12
        ? 'Yoga and Deep Breathing'
        : widget.stressScore >= 7
            ? 'Relaxation Techniques'
            : 'Stretching and Light Exercises';

    final String exerciseBenefits = widget.stressScore >= 12
        ? '''Yoga and deep breathing are highly effective for managing high stress levels. These practices help in reducing cortisol, improving concentration, and promoting emotional balance. Regular yoga sessions enhance flexibility and mindfulness, making them an ideal choice for stress relief.'''
        : widget.stressScore >= 7
            ? '''Relaxation techniques such as progressive muscle relaxation and guided meditation can significantly calm the nervous system. These techniques work by lowering heart rate and blood pressure, helping to restore inner peace and reducing anxiety.'''
            : '''Stretching and light exercises enhance blood circulation, relieve muscle tension, and promote relaxation. Simple activities like neck rolls, shoulder shrugs, and light cardio movements can ease physical discomfort and refresh the mind.''';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF436286),
        title: const Text(
          'Exercise Suggestions',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFFAF9F6),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Your Stress Score: ${widget.stressScore}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              SlideTransition(
                position: _slideAnimation,
                child: Text(
                  'Recommended Exercise: $exerciseRecommendation',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF436286)),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Recommended Duration: $recommendedDuration minutes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isDescriptionVisible = !_isDescriptionVisible;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF436286),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  _isDescriptionVisible
                      ? 'Hide Exercise Description'
                      : 'I Want to Read About the Exercise',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              if (_isDescriptionVisible)
                Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.white.withOpacity(0.9),
                  child: Text(
                    exerciseBenefits,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TimerScreen(duration: recommendedDuration)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF436286),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Start Exercise',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
