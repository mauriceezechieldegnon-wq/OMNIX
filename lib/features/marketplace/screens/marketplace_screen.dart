import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:omnix/core/constants/app_colors.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  final List<Map<String, String>> _products = const [
    {"name": "Maillot DEM VIP", "price": "5,000 F CFA", "vendor": "+22900000000"},
    {"name": "Pass OMNIX VIP 1 Mois", "price": "2,000 F CFA", "vendor": "+22900000000"},
    {"name": "Pack 1,000 PTS", "price": "1,000 F CFA", "vendor": "+22900000000"},
    {"name": "Casque Gaming OMNIX", "price": "15,000 F CFA", "vendor": "+22900000000"},
  ];

  Future<void> _buyOnWhatsApp(String phone, String productName) async {
    final uri = Uri.parse("https://wa.me/$phone?text=Bonjour,%20je%20souhaite%20acheter%20:$productName%20depuis%20l'application%20OMNIX");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("LE BAZAR", style: TextStyle(color: AppColors.neonYellow, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.darkCard,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isDesktop ? 4 : 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final p = _products[index];
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.electricPurple.withValues(alpha: 0.4), width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.shopping_bag_outlined, size: 48, color: AppColors.neonYellow),
                Text(
                  p["name"]!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textLight),
                ),
                Text(
                  p["price"]!,
                  style: const TextStyle(color: AppColors.neonYellow, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.electricPurple,
                    minimumSize: const Size(double.infinity, 36),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => _buyOnWhatsApp(p["vendor"]!, p["name"]!),
                  child: const Text("ACHETER", style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}