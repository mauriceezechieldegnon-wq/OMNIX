import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:omnix/core/models/quiz_model.dart';

class QuizService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Charger les questions depuis Firestore
  Future<List<QuizModel>> getSoloQuestions() async {
    try {
      final snapshot = await _db.collection('quizzes').limit(10).get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => QuizModel.fromFirestore(doc)).toList();
      }
    } catch (e) {
      // En cas d'erreur ou hors-ligne, retour des questions par défaut
    }

    // Questions Fallback (Offline)
    return [
      QuizModel(
        id: "offline_1",
        theme: "OMNIX",
        question: "Qui est le créateur de l'application OMNIX ?",
        options: ["DEM Productions", "EA Sports", "Ubisoft", "Ketchapp"],
        correctIndex: 0,
      ),
      QuizModel(
        id: "offline_2",
        theme: "Gaming",
        question: "Quel est la durée de chaque question en Mode Solo ?",
        options: ["5s", "10s", "15s", "20s"],
        correctIndex: 1,
      ),
    ];
  }

  // Ajouter les points gagnés au solde du joueur dans Firestore
  Future<void> addPointsToUser(int pointsEarned) async {
    final user = _auth.currentUser;
    if (user != null && pointsEarned > 0) {
      await _db.collection('users').doc(user.uid).update({
        'points': FieldValue.increment(pointsEarned),
      });
    }
  }
}