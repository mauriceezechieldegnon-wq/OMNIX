import 'package:flutter/material.dart';
import 'package:omnix/core/constants/app_colors.dart';

class DLSCard extends StatelessWidget {
  final String title;
  final String rating;
  final Widget child;
  final String? avatarUrl;
  final bool isGoldVIP;
  final VoidCallback? onTap;

  const DLSCard({
    super.key,
    required this.title,
    required this.rating,
    required this.child,
    this.avatarUrl,
    this.isGoldVIP = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryGlow = isGoldVIP ? AppColors.goldVIP : AppColors.neonYellow;
    final borderColor = isGoldVIP ? AppColors.goldVIP : AppColors.electricPurple;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: borderColor, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: primaryGlow.withValues(alpha: 0.25),
              blurRadius: 10.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14.0),
          child: Stack(
            children: [
              Positioned(
                right: -25,
                bottom: -25,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: borderColor.withValues(alpha: 0.12),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Badge Note + Avatar
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: primaryGlow, width: 1.5),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (avatarUrl != null && avatarUrl!.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                avatarUrl!,
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.person, color: AppColors.neonYellow),
                              ),
                            )
                          else
                            Text(
                              rating,
                              style: TextStyle(
                                color: primaryGlow,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          const SizedBox(height: 2),
                          Text(
                            isGoldVIP ? "VIP" : "PRO",
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.textLight,
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          child,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}