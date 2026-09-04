import 'package:flutter/material.dart';
import 'package:omnix/core/constants/app_colors.dart';
import 'package:omnix/core/widgets/dls_card.dart';
import 'package:omnix/features/quiz/screens/solo_quiz_screen.dart';

class ArenaScreen extends StatelessWidget {
  const ArenaScreen({super.key});

  void _showActionDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.neonYellow, width: 2),
        ),
        title: Text(title, style: const TextStyle(color: AppColors.neonYellow, fontWeight: FontWeight.bold)),
        content: Text(message, style: const TextStyle(color: AppColors.textLight)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.electricPurple),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SoloQuizScreen()));
            },
            child: const Text("LANCER LA PARTIE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ANNULER", style: TextStyle(color: AppColors.textMuted)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.darkCard,
          title: const Text("ARÈNE OMNIX", style: TextStyle(color: AppColors.neonYellow, fontWeight: FontWeight.w900)),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: AppColors.neonYellow,
            labelColor: AppColors.neonYellow,
            unselectedLabelColor: AppColors.textMuted,
            tabs: [
              Tab(text: "Duels 1v1"),
              Tab(text: "Battle Royale (5P)"),
              Tab(text: "Grand Tournoi"),
              Tab(text: "OMNIX Gala"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDuelsTab(context),
            _buildBattleRoyaleTab(context),
            _buildGrandTournoiTab(context),
            _buildGalaTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDuelsTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DLSCard(
          title: "Mise 10 PTS",
          rating: "10",
          onTap: () => _showActionDialog(context, "DUEL 10 PTS", "Mise : 10 PTS. Victoire = 20 PTS. Rejoindre le match ?"),
          child: const Text("Victoire = 20 PTS. Affronte un joueur en direct.", style: TextStyle(color: AppColors.textMuted)),
        ),
        DLSCard(
          title: "Mise 50 PTS",
          rating: "50",
          onTap: () => _showActionDialog(context, "DUEL 50 PTS", "Mise : 50 PTS. Victoire = 100 PTS. Rejoindre le match ?"),
          child: const Text("Victoire = 100 PTS. Niveau Pro.", style: TextStyle(color: AppColors.textMuted)),
        ),
        DLSCard(
          title: "Mise 100 PTS",
          rating: "100",
          onTap: () => _showActionDialog(context, "DUEL 100 PTS", "Mise : 100 PTS. Victoire = 200 PTS. Rejoindre le match ?"),
          child: const Text("Victoire = 200 PTS. Pour les Élites.", style: TextStyle(color: AppColors.textMuted)),
        ),
      ],
    );
  }

  Widget _buildBattleRoyaleTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const DLSCard(
            title: "Match Rapide 5 Joueurs",
            rating: "5/5",
            child: Text("Dès que 5 joueurs sont connectés, la partie démarre immédiatement.", style: TextStyle(color: AppColors.textMuted)),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricPurple,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => _showActionDialog(context, "BATTLE ROYALE (5P)", "Recherche de 4 joueurs en cours... Prêt pour le combat ?"),
            child: const Text("REJOINDRE LA SALLE D'ATTENTE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildGrandTournoiTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DLSCard(
          title: "Tournoi Élite (Tous les 14j)",
          rating: "1000F",
          isGoldVIP: true,
          onTap: () => _showActionDialog(context, "GRAND TOURNOI ÉLITE", "Frais d'inscription : 1000F CFA. Poules de 4 -> Éliminatoires. S'inscrire ?"),
          child: const Text("Prix d'entrée: 1000F CFA.\nPoules de 4 -> Éliminatoires (16e à Finale).\nCash prize pour le top 3 !", style: TextStyle(color: AppColors.textMuted)),
        ),
      ],
    );
  }

  Widget _buildGalaTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DLSCard(
          title: "OMNIX GALA",
          rating: "500F",
          onTap: () => _showActionDialog(context, "OMNIX GALA DÉCEMBRE", "Prix : 500F CFA. Élimination directe géante. Lots physiques & Cash ! S'inscrire ?"),
          child: const Text("Prix d'entrée: 500F CFA.\nÉlimination directe géante. Déblocable par l'Admin.\nLots physiques & Cash à gagner !", style: TextStyle(color: AppColors.textMuted)),
        ),
      ],
    );
  }
}
