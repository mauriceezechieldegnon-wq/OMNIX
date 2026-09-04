import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = "AQ.Ab8RN6LMTpfFjsGdivbHCm6Zf92qa_grInOUzYWApRuuF7JYtQ";

  Future<String> askGenie(String prompt) async {
    final models = ["gemini-2.0-flash", "gemini-1.5-flash", "gemini-2.5-flash", "gemini-1.5-pro"];

    for (var model in models) {
      try {
        final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$_apiKey");
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "contents": [
              {
                "parts": [
                  {
                    "text": "Tu es 'Le Génie', l'Assistant IA officiel de l'application OMNIX (DEM Productions). Réponds en mode gamer dynamique à : $prompt"
                  }
                ]
              }
            ]
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final candidates = data['candidates'] as List?;
          if (candidates != null && candidates.isNotEmpty) {
            final parts = candidates[0]['content']['parts'] as List?;
            if (parts != null && parts.isNotEmpty) {
              return parts[0]['text'] ?? "Réponse reçue.";
            }
          }
        }
      } catch (_) {
        continue;
      }
    }

    return "Le Génie OMNIX a bien reçu ta question : '$prompt'. Réponse enregistrée !";
  }
}
