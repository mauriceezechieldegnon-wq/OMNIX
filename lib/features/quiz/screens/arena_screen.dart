import 'package:flutter/material.dart';
import 'package:omnix/core/constants/app_colors.dart';
import 'package:omnix/core/widgets/dls_card.dart';

class ArenaScreen extends StatelessWidget {
  const ArenaScreen({super.key});

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
            _buildDuelsTab(),
            _buildBattleRoyaleTab(),
            _buildGrandTournoiTab(),
            _buildGalaTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDuelsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        DLSCard(
          title: "Mise 10 PTS",
          rating: "10",
          child: Text("Victoire = 20 PTS. Affronte un joueur en direct.", style: TextStyle(color: AppColors.textMuted)),
        ),
        DLSCard(
          title: "Mise 50 PTS",
          rating: "50",
          child: Text("Victoire = 100 PTS. Niveau Pro.", style: TextStyle(color: AppColors.textMuted)),
        ),
        DLSCard(
          title: "Mise 100 PTS",
          rating: "100",
          child: Text("Victoire = 200 PTS. Pour les Élites.", style: TextStyle(color: AppColors.textMuted)),
        ),
      ],
    );
  }

  Widget _buildBattleRoyaleTab() {
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
            onPressed: () {},
            child: const Text("REJOINDRE LA SALLE D'ATTENTE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildGrandTournoiTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        DLSCard(
          title: "Tournoi Élite (Tous les 14j)",
          rating: "1000F",
          isGoldVIP: true,
          child: Text("Prix d'entrée: 1000F CFA.\nPoules de 4 -> Éliminatoires (16e à Finale).\nCash prize pour le top 3 !", style: TextStyle(color: AppColors.textMuted)),
        ),
      ],
    );
  }

  Widget _buildGalaTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        DLSCard(
          title: "OMNIX GALA (Spécial Décembre)",
          rating: "500F",
          child: Text("Prix d'entrée: 500F CFA.\nÉlimination directe géante.\nLots physiques & Cash à gagner !", style: TextStyle(color: AppColors.textMuted)),
        ),
      ],
    );
  }
}