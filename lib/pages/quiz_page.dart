import 'package:flutter/material.dart';
import 'package:math/pages/result_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  String userAnswer = '';
  List<Map<String, dynamic>> questions = [];
  late DateTime startTime;

  @override
  void initState() {
    super.initState();
    generateQuestions();
    startTime = DateTime.now();
  }

  void generateQuestions() {
    for (int i = 0; i < 30; i++) {
      int a = 10 + (i % 10);
      int b = 10 + ((i + 1) % 10);
      String operator = ['+', '×'][i % 2];
      questions.add({
        'question': '$a $operator $b',
        'answer': calculateAnswer(a, b, operator),
      });
    }
  }

  int calculateAnswer(int a, int b, String operator) {
    switch (operator) {
      case '+':
        return a + b;
      case '×':
        return a * b;
      default:
        return 0;
    }
  }

  void checkAnswer() {
    if (userAnswer == questions[currentQuestionIndex]['answer'].toString()) {
      correctAnswers++;
    } else {
      wrongAnswers++;
    }
    setState(() {
      userAnswer = '';
      if (currentQuestionIndex < 29) {
        currentQuestionIndex++;
      } else {
        endQuiz();
      }
    });
  }

  void endQuiz() {
    int totalPoints = correctAnswers * 4;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          totalPoints: totalPoints,
          onTryAgain: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const QuizPage()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('IQ Math Test'),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CountdownTimer(
              startTime: startTime,
              onTimerEnd: endQuiz,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Correct: $correctAnswers',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Wrong: $wrongAnswers',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  questions[currentQuestionIndex]['question'],
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  userAnswer,
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                  ),
                ),
                const Spacer(),
                NumberKeyboard(
                  onNumberPressed: (number) {
                    setState(() {
                      userAnswer += number;
                    });
                  },
                  onDeletePressed: () {
                    setState(() {
                      if (userAnswer.isNotEmpty) {
                        userAnswer = userAnswer.substring(0, userAnswer.length - 1);
                      }
                    });
                  },
                  onSubmitPressed: checkAnswer,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CountdownTimer extends StatefulWidget {
  final DateTime startTime;
  final VoidCallback onTimerEnd;

  const CountdownTimer({
    super.key,
    required this.startTime,
    required this.onTimerEnd,
  });

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration remainingTime;

  @override
  void initState() {
    super.initState();
    remainingTime = const Duration(minutes: 1);
    startTimer();
  }

  void startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          remainingTime = remainingTime - const Duration(seconds: 1);
          if (remainingTime.inSeconds > 0) {
            startTimer();
          } else {
            widget.onTimerEnd();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${remainingTime.inSeconds}s',
      style: const TextStyle(
        fontSize: 18,
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class NumberKeyboard extends StatelessWidget {
  final Function(String) onNumberPressed;
  final Function() onDeletePressed;
  final Function() onSubmitPressed;

  const NumberKeyboard({
    super.key,
    required this.onNumberPressed,
    required this.onDeletePressed,
    required this.onSubmitPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ['1', '2', '3'].map((number) {
            return NumberButton(
              number: number,
              onPressed: () => onNumberPressed(number),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ['4', '5', '6'].map((number) {
            return NumberButton(
              number: number,
              onPressed: () => onNumberPressed(number),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ['7', '8', '9'].map((number) {
            return NumberButton(
              number: number,
              onPressed: () => onNumberPressed(number),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NumberButton(
              number: '0',
              onPressed: () => onNumberPressed('0'),
            ),
            IconButton(
              onPressed: onDeletePressed,
              icon: const Icon(Icons.backspace, color: Colors.red),
            ),
            ElevatedButton(
              onPressed: onSubmitPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class NumberButton extends StatelessWidget {
  final String number;
  final Function() onPressed;

  const NumberButton({
    super.key,
    required this.number,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          number,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}