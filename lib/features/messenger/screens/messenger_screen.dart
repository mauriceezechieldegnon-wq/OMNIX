import 'package:flutter/material.dart';
import 'package:omnix/core/constants/app_colors.dart';

class MessengerScreen extends StatelessWidget {
  const MessengerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OMNIX CHAT", style: TextStyle(color: AppColors.neonYellow)),
        backgroundColor: AppColors.darkCard,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                _ChatBubble(
                  message: "Salut ! Prêt pour le Grand Tournoi ce week-end ?",
                  isMe: false,
                  time: "14:30",
                ),
                _ChatBubble(
                  message: "Affirmatif ! J'ai rechargé mes points dans Le Bazar OMNIX.",
                  isMe: true,
                  time: "14:32",
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.darkCard,
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Écrire un message...",
                      hintStyle: TextStyle(color: AppColors.textMuted),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: AppColors.textLight),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.neonYellow),
                  onPressed: () {},
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;

  const _ChatBubble({required this.message, required this.isMe, required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? AppColors.electricPurple : AppColors.darkCard,
          borderRadius: BorderRadius.circular(14),
          border: isMe ? null : Border.all(color: AppColors.metallicBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(message, style: const TextStyle(color: AppColors.textLight)),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(time, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.done_all, size: 14, color: Colors.blue),
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}