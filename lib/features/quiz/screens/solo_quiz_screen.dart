import 'dart:async';
import 'package:flutter/material.dart';
import 'package:omnix/core/constants/app_colors.dart';
import 'package:omnix/core/models/quiz_model.dart';
import 'package:omnix/core/services/quiz_service.dart';

class SoloQuizScreen extends StatefulWidget {
  const SoloQuizScreen({super.key});

  @override
  State<SoloQuizScreen> createState() => _SoloQuizScreenState();
}

class _SoloQuizScreenState extends State<SoloQuizScreen> {
  final QuizService _quizService = QuizService();
  List<QuizModel> _questions = [];
  bool _isLoading = true;

  int _timeLeft = 10;
  Timer? _timer;
  int _currentQuestion = 0;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    final questions = await _quizService.getSoloQuestions();
    setState(() {
      _questions = questions;
      _isLoading = false;
    });
    if (_questions.isNotEmpty) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timeLeft = 10;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _nextQuestion();
      }
    });
  }

  void _answerQuestion(int index) {
    if (index == _questions[_currentQuestion].correctIndex) {
      _score += 10;
    }
    _nextQuestion();
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() => _currentQuestion++);
      _startTimer();
    } else {
      _timer?.cancel();
      _finishGame();
    }
  }

  void _finishGame() async {
    await _quizService.addPointsToUser(_score);

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.neonYellow, width: 2),
        ),
        title: const Text("PARTIE TERMINÉE", style: TextStyle(color: AppColors.neonYellow, fontWeight: FontWeight.bold)),
        content: Text("Ton score : $_score PTS\n🎉 +$_score Points ajoutés à ton solde Firestore !", style: const TextStyle(color: AppColors.textLight)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("RETOUR À L'ACCUEIL", style: TextStyle(color: AppColors.electricPurple, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.neonYellow)),
      );
    }

    final q = _questions[_currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: const Text("MODE SOLO (CHRONO)"),
        backgroundColor: AppColors.darkCard,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: _timeLeft / 10,
              backgroundColor: AppColors.darkCard,
              color: _timeLeft < 4 ? Colors.red : AppColors.neonYellow,
              minHeight: 8,
            ),
            const SizedBox(height: 12),
            Text(
              "00:0$_timeLeft",
              style: TextStyle(
                color: _timeLeft < 4 ? Colors.red : AppColors.neonYellow,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.electricPurple, width: 2),
              ),
              child: Text(
                q.question,
                style: const TextStyle(color: AppColors.textLight, fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(
              q.options.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkCard,
                    minimumSize: const Size(double.infinity, 54),
                    side: BorderSide(color: AppColors.electricPurple.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _answerQuestion(index),
                  child: Text(
                    q.options[index],
                    style: const TextStyle(color: AppColors.textLight, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}