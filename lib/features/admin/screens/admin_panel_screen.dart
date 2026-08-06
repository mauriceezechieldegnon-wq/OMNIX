import 'package:flutter/material.dart';
import 'package:omnix/core/constants/app_colors.dart';
import 'package:omnix/core/services/admin_service.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final AdminService _adminService = AdminService();

  // Quiz Form Controllers
  final _quizThemeController = TextEditingController();
  final _quizQuestionController = TextEditingController();
  final _opt1Controller = TextEditingController();
  final _opt2Controller = TextEditingController();
  final _opt3Controller = TextEditingController();
  final _opt4Controller = TextEditingController();
  int _correctIndex = 0;

  // Marketplace Form Controllers
  final _prodNameController = TextEditingController();
  final _prodPriceController = TextEditingController();
  final _prodVendorController = TextEditingController();

  void _addQuiz() async {
    if (_quizQuestionController.text.isEmpty) return;
    await _adminService.addQuizQuestion(
      theme: _quizThemeController.text.trim().isEmpty ? "Général" : _quizThemeController.text.trim(),
      question: _quizQuestionController.text.trim(),
      options: [
        _opt1Controller.text.trim(),
        _opt2Controller.text.trim(),
        _opt3Controller.text.trim(),
        _opt4Controller.text.trim(),
      ],
      correctIndex: _correctIndex,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Question ajoutée avec succès à Firestore !"), backgroundColor: Colors.green),
      );
      _quizQuestionController.clear();
    }
  }

  void _addProduct() async {
    if (_prodNameController.text.isEmpty) return;
    await _adminService.addMarketplaceProduct(
      name: _prodNameController.text.trim(),
      price: _prodPriceController.text.trim(),
      vendorPhone: _prodVendorController.text.trim(),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produit ajouté au Bazar !"), backgroundColor: Colors.green),
      );
      _prodNameController.clear();
      _prodPriceController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.darkCard,
          title: const Text("PANEL ADMIN SECRET 🛡️", style: TextStyle(color: AppColors.goldVIP, fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            indicatorColor: AppColors.goldVIP,
            labelColor: AppColors.goldVIP,
            unselectedLabelColor: AppColors.textMuted,
            tabs: [
              Tab(text: "Export CSV"),
              Tab(text: "+ Quiz"),
              Tab(text: "+ Bazar"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TAB 1: EXPORT CSV
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.file_download, size: 64, color: AppColors.goldVIP),
                  const SizedBox(height: 16),
                  const Text(
                    "Exporter la liste des utilisateurs inscrits du mois en CSV",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textLight, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldVIP,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () => _adminService.exportMonthlyUsersToCSV(),
                    icon: const Icon(Icons.download, color: Colors.black),
                    label: const Text("TÉLÉCHARGER LE FICHIER CSV", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            // TAB 2: ADD QUIZ BY RUBRIQUE
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(controller: _quizThemeController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Rubrique / Thème (ex: Football)")),
                  TextField(controller: _quizQuestionController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Question")),
                  TextField(controller: _opt1Controller, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Option 1 (Index 0)")),
                  TextField(controller: _opt2Controller, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Option 2 (Index 1)")),
                  TextField(controller: _opt3Controller, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Option 3 (Index 2)")),
                  TextField(controller: _opt4Controller, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Option 4 (Index 3)")),
                  const SizedBox(height: 12),
                  DropdownButton<int>(
                    value: _correctIndex,
                    dropdownColor: AppColors.darkCard,
                    items: const [
                      DropdownMenuItem(value: 0, child: Text("Bonne Réponse: Option 1", style: TextStyle(color: Colors.white))),
                      DropdownMenuItem(value: 1, child: Text("Bonne Réponse: Option 2", style: TextStyle(color: Colors.white))),
                      DropdownMenuItem(value: 2, child: Text("Bonne Réponse: Option 3", style: TextStyle(color: Colors.white))),
                      DropdownMenuItem(value: 3, child: Text("Bonne Réponse: Option 4", style: TextStyle(color: Colors.white))),
                    ],
                    onChanged: (val) => setState(() => _correctIndex = val ?? 0),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.electricPurple, minimumSize: const Size(double.infinity, 48)),
                    onPressed: _addQuiz,
                    child: const Text("PUBLIER LA QUESTION DANS FIRESTORE", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),

            // TAB 3: ADD MARKETPLACE PRODUCT
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(controller: _prodNameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Nom du Produit")),
                  TextField(controller: _prodPriceController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Prix (ex: 5,000 F CFA)")),
                  TextField(controller: _prodVendorController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Numéro WhatsApp Vendeur")),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.electricPurple, minimumSize: const Size(double.infinity, 48)),
                    onPressed: _addProduct,
                    child: const Text("AJOUTER LE PRODUIT AU BAZAR", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}