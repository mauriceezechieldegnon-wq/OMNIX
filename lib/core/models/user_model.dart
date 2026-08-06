import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String pseudo;
  final String email;
  final String avatarUrl;
  final int rating;
  final int points;
  final bool isVIP;
  final String role;

  UserModel({
    required this.uid,
    required this.pseudo,
    required this.email,
    this.avatarUrl = 'https://api.dicebear.com/7.x/bottts/png?seed=omnix1',
    this.rating = 85,
    this.points = 100,
    this.isVIP = false,
    this.role = "player",
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserModel(
      uid: doc.id,
      pseudo: data['pseudo'] ?? 'Joueur OMNIX',
      email: data['email'] ?? '',
      avatarUrl: data['avatarUrl'] ?? 'https://api.dicebear.com/7.x/bottts/png?seed=${doc.id}',
      rating: data['rating'] ?? 85,
      points: data['points'] ?? 100,
      isVIP: data['isVIP'] ?? false,
      role: data['role'] ?? 'player',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'pseudo': pseudo,
      'email': email,
      'avatarUrl': avatarUrl,
      'rating': rating,
      'points': points,
      'isVIP': isVIP,
      'role': role,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}