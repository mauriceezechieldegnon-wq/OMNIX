import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1. Mettre à jour les informations du profil utilisateur + Avatar
  Future<void> updateProfile({
    String? email,
    String? newPassword,
    String? phone,
    String? avatarUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    if (email != null && email.isNotEmpty && email != user.email) {
      await user.verifyBeforeUpdateEmail(email);
    }
    if (newPassword != null && newPassword.isNotEmpty) {
      await user.updatePassword(newPassword);
    }

    await _db.collection('users').doc(user.uid).update({
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      if (email != null && email.isNotEmpty) 'email': email,
      if (avatarUrl != null && avatarUrl.isNotEmpty) 'avatarUrl': avatarUrl,
    });
  }

  // 2. Exporter UNIQUEMENT les utilisateurs inscrits durant le mois en cours
  Future<void> exportMonthlyUsersToCSV() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final startTimestamp = Timestamp.fromDate(startOfMonth);

    final snapshot = await _db
        .collection('users')
        .where('createdAt', isGreaterThanOrEqualTo: startTimestamp)
        .get();

    String csvData = "UID,Pseudo,Email,Téléphone,Points,Role\n";

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final pseudo = data['pseudo'] ?? '';
      final email = data['email'] ?? '';
      final phone = data['phone'] ?? 'Non renseigné';
      final points = data['points'] ?? 0;
      final role = data['role'] ?? 'player';

      csvData += "${doc.id},$pseudo,$email,$phone,$points,$role\n";
    }

    final encodedUri = Uri.encodeFull("data:text/csv;charset=utf-8,$csvData");
    final uri = Uri.parse(encodedUri);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // 3. Ajouter une question de Quiz par rubrique dans Firestore
  Future<void> addQuizQuestion({
    required String theme,
    required String question,
    required List<String> options,
    required int correctIndex,
  }) async {
    await _db.collection('quizzes').add({
      'theme': theme,
      'question': question,
      'options': options,
      'correctIndex': correctIndex,
      'timerSeconds': 10,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // 4. Ajouter un produit dans Le Bazar (Marketplace) dans Firestore
  Future<void> addMarketplaceProduct({
    required String name,
    required String price,
    required String vendorPhone,
  }) async {
    await _db.collection('marketplace').add({
      'name': name,
      'price': price,
      'vendor': vendorPhone,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}