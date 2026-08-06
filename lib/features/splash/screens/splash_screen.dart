import 'dart:async';
import 'package:flutter/material.dart';
import 'package:omnix/core/constants/app_colors.dart';
import 'package:omnix/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Redirection automatique après 3 secondes vers AuthWrapper
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AuthWrapper()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Halo de lumière Neon Violet en arrière-plan
          Center(
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x266200EE), // Electric Purple avec 15% d'opacité
                boxShadow: [
                  BoxShadow(
                    color: Color(0x596200EE), // Electric Purple avec 35% d'opacité
                    blurRadius: 90,
                    spreadRadius: 20,
                  )
                ],
              ),
            ),
          ),
          // Contenu principal au centre
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "OMNIX",
                  style: TextStyle(
                    color: AppColors.neonYellow,
                    fontSize: 54,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 3.0,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "BY DEM PRODUCTIONS",
                  style: TextStyle(
                    color: AppColors.electricPurple,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4.0,
                  ),
                ),
                SizedBox(height: 50),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    color: AppColors.neonYellow,
                    strokeWidth: 3,
                  ),
                ),
              ],
            ),
          ),
          // Pied de page
          const Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Text(
              "• 2026",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
                letterSpacing: 2,
              ),
            ),
          )
        ],
      ),
    );
  }
}