import 'package:flutter/material.dart';
import 'exercise_screen.dart';

class MCQScreen extends StatefulWidget {
  @override
  _MCQScreenState createState() => _MCQScreenState();
}

class _MCQScreenState extends State<MCQScreen> {
  int _currentQuestionIndex = 0;
  int _stressScore = 0;

  final List<Map<String, Object>> _questions = [
    {
      'question': 'How often do you feel overwhelmed by your tasks?',
      'options': [
        {'text': 'Always', 'score': 3},
        {'text': 'Sometimes', 'score': 2},
        {'text': 'Rarely', 'score': 1},
        {'text': 'Never', 'score': 0},
      ],
    },
    {
      'question': 'How often do you experience trouble sleeping?',
      'options': [
        {'text': 'Always', 'score': 3},
        {'text': 'Sometimes', 'score': 2},
        {'text': 'Rarely', 'score': 1},
        {'text': 'Never', 'score': 0},
      ],
    },
    {
      'question': 'Do you find it difficult to focus on your work or studies?',
      'options': [
        {'text': 'Always', 'score': 3},
        {'text': 'Sometimes', 'score': 2},
        {'text': 'Rarely', 'score': 1},
        {'text': 'Never', 'score': 0},
      ],
    },
    {
      'question': 'How often do you feel irritated or short-tempered?',
      'options': [
        {'text': 'Always', 'score': 3},
        {'text': 'Sometimes', 'score': 2},
        {'text': 'Rarely', 'score': 1},
        {'text': 'Never', 'score': 0},
      ],
    },
    {
      'question': 'Do you feel like you don’t have time for yourself?',
      'options': [
        {'text': 'Always', 'score': 3},
        {'text': 'Sometimes', 'score': 2},
        {'text': 'Rarely', 'score': 1},
        {'text': 'Never', 'score': 0},
      ],
    },
    {
      'question':
          'Do you experience physical symptoms like headaches or fatigue?',
      'options': [
        {'text': 'Always', 'score': 3},
        {'text': 'Sometimes', 'score': 2},
        {'text': 'Rarely', 'score': 1},
        {'text': 'Never', 'score': 0},
      ],
    },
    {
      'question': 'How often do you feel anxious about the future?',
      'options': [
        {'text': 'Always', 'score': 3},
        {'text': 'Sometimes', 'score': 2},
        {'text': 'Rarely', 'score': 1},
        {'text': 'Never', 'score': 0},
      ],
    },
    {
      'question':
          'Do you find it difficult to enjoy activities you used to like?',
      'options': [
        {'text': 'Always', 'score': 3},
        {'text': 'Sometimes', 'score': 2},
        {'text': 'Rarely', 'score': 1},
        {'text': 'Never', 'score': 0},
      ],
    },
  ];

  void _answerQuestion(int score) {
    setState(() {
      _stressScore += score;
      _currentQuestionIndex++;
    });

    if (_currentQuestionIndex >= _questions.length) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExerciseScreen(stressScore: _stressScore),
        ),
      );
    }
  }

  double _getProgress() {
    return (_currentQuestionIndex + 1) / _questions.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2D5D7B),
        title: const Text('Stress Test',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 130,
                      height: 130,
                      child: CircularProgressIndicator(
                        value: _getProgress(),
                        backgroundColor: Colors.grey.shade400,
                        color: Color(0xFF2D5D7B),
                        strokeWidth: 10,
                      ),
                    ),
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage('assets/yoga.png'),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  _questions[_currentQuestionIndex]['question'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D5D7B)),
                ),
                SizedBox(height: 24),
                ...(_questions[_currentQuestionIndex]['options']
                        as List<Map<String, Object>>)
                    .map(
                      (option) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () =>
                              _answerQuestion(option['score'] as int),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2D5D7B),
                            minimumSize: Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(option['text'] as String,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
