import 'package:flutter/material.dart';
import 'package:omnix/core/constants/app_colors.dart';
import 'package:omnix/core/services/gemini_service.dart';

class GenieScreen extends StatefulWidget {
  const GenieScreen({super.key});

  @override
  State<GenieScreen> createState() => _GenieScreenState();
}

class _GenieScreenState extends State<GenieScreen> {
  final GeminiService _geminiService = GeminiService();
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": text});
      _isLoading = true;
    });
    _controller.clear();

    final response = await _geminiService.askGenie(text);

    setState(() {
      _messages.add({"role": "genie", "text": response});
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LE GÉNIE IA", style: TextStyle(color: AppColors.neonYellow, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.darkCard,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                final isGenie = m["role"] == "genie";

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isGenie ? AppColors.darkCard : AppColors.electricPurple,
                    borderRadius: BorderRadius.circular(14),
                    border: isGenie ? Border.all(color: AppColors.neonYellow, width: 1.5) : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isGenie ? "🧞‍♂️ LE GÉNIE OMNIX" : "👤 VOUS",
                        style: TextStyle(
                          color: isGenie ? AppColors.neonYellow : AppColors.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(m["text"]!, style: const TextStyle(color: AppColors.textLight)),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(color: AppColors.neonYellow),
            ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: AppColors.darkCard,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: AppColors.textLight),
                    decoration: const InputDecoration(
                      hintText: "Pose une question au Génie...",
                      hintStyle: TextStyle(color: AppColors.textMuted),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.neonYellow),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}