import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omnix/core/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Obtenir le flux de l'utilisateur connecté
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Obtenir l'utilisateur actuel
  User? get currentUser => _auth.currentUser;

  // Inscription avec Email et Mot de passe
  Future<UserModel?> signUpWithEmail({
    required String email,
    required String password,
    required String pseudo,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final newUser = UserModel(
          uid: credential.user!.uid,
          pseudo: pseudo,
          email: email,
        );

        // Sauvegarder dans Firestore
        await _db.collection('users').doc(newUser.uid).set(newUser.toMap());
        return newUser;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  // Connexion avec Email et Mot de passe
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Connexion Anonyme (mode Invité Rapide)
  Future<UserModel?> signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();
      if (credential.user != null) {
        final guestUser = UserModel(
          uid: credential.user!.uid,
          pseudo: "Guest_${credential.user!.uid.substring(0, 5)}",
          email: "guest@omnix.app",
        );

        await _db.collection('users').doc(guestUser.uid).set(guestUser.toMap());
        return guestUser;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  // Flux en temps réel du profil Firestore du joueur connecté
  Stream<UserModel?> get currentUserModelStream {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      final doc = await _db.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    });
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }
}