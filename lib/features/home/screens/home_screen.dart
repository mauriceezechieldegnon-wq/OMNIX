import 'dart:async';
import 'package:flutter/material.dart';
import 'package:omnix/core/constants/app_colors.dart';
import 'package:omnix/core/models/user_model.dart';
import 'package:omnix/core/services/auth_service.dart';
import 'package:omnix/core/widgets/dls_card.dart';
import 'package:omnix/features/quiz/screens/arena_screen.dart';
import 'package:omnix/features/quiz/screens/solo_quiz_screen.dart';
import 'package:omnix/features/marketplace/screens/marketplace_screen.dart';
import 'package:omnix/features/messenger/screens/messenger_screen.dart';
import 'package:omnix/features/genie/screens/genie_screen.dart';
import 'package:omnix/features/profile/screens/profile_settings_screen.dart';
import 'package:omnix/features/admin/screens/admin_panel_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _navigateToTab(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _HomeContent(onNavigateToArena: () => _navigateToTab(1)),
      const ArenaScreen(),
      const MarketplaceScreen(),
      const MessengerScreen(),
      const GenieScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.darkCard,
        selectedItemColor: AppColors.neonYellow,
        unselectedItemColor: AppColors.textMuted,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.style), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_esports), label: 'Arène'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Bazar'),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text("2"),
              child: Icon(Icons.chat_bubble),
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'Génie'),
        ],
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  final VoidCallback onNavigateToArena;
  const _HomeContent({required this.onNavigateToArena});

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  Timer? _adminPressTimer;

  void _onProfileTapDown(UserModel? user) {
    if (user?.role == 'admin') {
      _adminPressTimer = Timer(const Duration(seconds: 5), () {
        if (mounted) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPanelScreen()));
        }
      });
    }
  }

  void _onProfileTapUp(UserModel? user) {
    if (_adminPressTimer?.isActive ?? false) {
      _adminPressTimer?.cancel();
    }
    if (user != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileSettingsScreen(user: user)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
      stream: AuthService().currentUserModelStream,
      builder: (context, snapshot) {
        final user = snapshot.data;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "OMNIX",
                        style: TextStyle(
                          color: AppColors.neonYellow,
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        "BY DEM PRODUCTIONS",
                        style: TextStyle(
                          color: AppColors.electricPurple,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.electricPurple.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.electricPurple),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.monetization_on, color: AppColors.neonYellow, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              "${user?.points ?? 0} PTS",
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textLight),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings, color: AppColors.neonYellow, size: 22),
                        onPressed: () {
                          if (user != null) {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileSettingsScreen(user: user)));
                          }
                        },
                        tooltip: "Paramètres",
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.redAccent, size: 20),
                        onPressed: () => AuthService().signOut(),
                        tooltip: "Déconnexion",
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              GestureDetector(
                onTapDown: (_) => _onProfileTapDown(user),
                onTapUp: (_) => _onProfileTapUp(user),
                onTapCancel: () => _adminPressTimer?.cancel(),
                child: DLSCard(
                  title: user?.pseudo ?? "Chargement...",
                  rating: "${user?.rating ?? 85}",
                  avatarUrl: user?.avatarUrl,
                  isGoldVIP: user?.isVIP ?? false,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: (user?.isVIP ?? false) ? AppColors.goldVIP : AppColors.electricPurple,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          (user?.isVIP ?? false) ? "GOLD ELITE" : "PRO PLAYER",
                          style: TextStyle(
                            color: (user?.isVIP ?? false) ? Colors.black : Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          "Clique pour Paramètres (Maintiens 5s si Admin)",
                          style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              const Text(
                "ACCÈS RAPIDE",
                style: TextStyle(color: AppColors.textMuted, fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DLSCard(
                title: "Mode Solo",
                rating: "85",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SoloQuizScreen()));
                },
                child: const Text(
                  "Lancer une session 10s chrono. Support Mode Offline.",
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ),
              DLSCard(
                title: "Tournois Arène",
                rating: "94",
                onTap: widget.onNavigateToArena,
                child: const Text(
                  "Duels, Battle Royale, Grand Tournoi & OMNIX Gala.",
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
