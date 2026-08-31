import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:omnix/core/constants/app_colors.dart';
import 'package:omnix/core/services/firebase_options.dart';
import 'package:omnix/core/services/auth_service.dart';
import 'package:omnix/features/auth/screens/auth_screen.dart';
import 'package:omnix/features/home/screens/home_screen.dart';
import 'package:omnix/features/splash/screens/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const OmnixApp());
}

class OmnixApp extends StatelessWidget {
  const OmnixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OMNIX - DEM Productions',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.electricPurple,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.electricPurple,
          secondary: AppColors.neonYellow,
          surface: AppColors.darkCard,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// Écoute de l'état d'authentification en temps réel
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.neonYellow),
            ),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen();
        }
        return const AuthScreen();
      },
    );
  }
}