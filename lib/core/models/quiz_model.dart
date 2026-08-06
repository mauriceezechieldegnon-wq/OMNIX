import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  final String id;
  final String theme;
  final String question;
  final List<String> options;
  final int correctIndex;
  final int timerSeconds;

  QuizModel({
    required this.id,
    required this.theme,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.timerSeconds = 10,
  });

  factory QuizModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return QuizModel(
      id: doc.id,
      theme: data['theme'] ?? 'Général',
      question: data['question'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctIndex: data['correctIndex'] ?? 0,
      timerSeconds: data['timerSeconds'] ?? 10,
    );
  }
}