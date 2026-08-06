import 'package:flutter/material.dart';
import 'package:omnix/core/constants/app_colors.dart';
import 'package:omnix/core/models/user_model.dart';
import 'package:omnix/core/services/admin_service.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final UserModel user;
  const ProfileSettingsScreen({super.key, required this.user});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final AdminService _adminService = AdminService();
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _avatarUrlController;
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  final List<String> _presetAvatars = [
    'https://api.dicebear.com/7.x/bottts/png?seed=omnix1',
    'https://api.dicebear.com/7.x/bottts/png?seed=omnix2',
    'https://api.dicebear.com/7.x/bottts/png?seed=omnix3',
    'https://api.dicebear.com/7.x/bottts/png?seed=omnix4',
    'https://api.dicebear.com/7.x/bottts/png?seed=omnix5',
  ];

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController();
    _avatarUrlController = TextEditingController(text: widget.user.avatarUrl);
  }

  void _saveSettings() async {
    setState(() => _isLoading = true);
    try {
      await _adminService.updateProfile(
        email: _emailController.text.trim(),
        newPassword: _passwordController.text.trim(),
        phone: _phoneController.text.trim(),
        avatarUrl: _avatarUrlController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Paramètres & Avatar mis à jour !"), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : ${e.toString()}"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PARAMÈTRES PROFIL"),
        backgroundColor: AppColors.darkCard,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // SÉLECTION AVATAR GAMING
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.neonYellow),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("CHOISIR TON AVATAR GAMING", style: TextStyle(color: AppColors.neonYellow, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _presetAvatars.map((url) {
                      final isSelected = _avatarUrlController.text == url;
                      return GestureDetector(
                        onTap: () => setState(() => _avatarUrlController.text = url),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: isSelected ? AppColors.neonYellow : Colors.transparent, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage(url),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // FORMULAIRE MODIFICATION INFORMATIONS
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.electricPurple),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("MODIFIER TES INFORMATIONS", style: TextStyle(color: AppColors.neonYellow, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: AppColors.textLight),
                    decoration: const InputDecoration(labelText: "Adresse Email", labelStyle: TextStyle(color: AppColors.textMuted)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _phoneController,
                    style: const TextStyle(color: AppColors.textLight),
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: "Numéro de Téléphone", labelStyle: TextStyle(color: AppColors.textMuted)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: AppColors.textLight),
                    decoration: const InputDecoration(labelText: "Nouveau Mot de passe", labelStyle: TextStyle(color: AppColors.textMuted)),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.electricPurple,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: _isLoading ? null : _saveSettings,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("ENREGISTRER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}