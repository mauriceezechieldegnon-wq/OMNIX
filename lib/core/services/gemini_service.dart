import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = "AQ.Ab8RN6LMTpfFjsGdivbHCm6Zf92qa_grInOUzYWApRuuF7JYtQ";
  static const String _baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";

  Future<String> askGenie(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl?key=$_apiKey"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": "Tu es 'Le Génie', l'Assistant IA officiel et dynamique de l'application OMNIX (créée par DEM Productions). Réponds avec enthousiasme et un ton gamer à : $prompt"
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'] ?? "Désolé, Le Génie a eu une micro-coupure.";
      } else {
        return "Erreur du Génie (Code ${response.statusCode}). Réessaie plus tard !";
      }
    } catch (e) {
      return "Connexion au Génie impossible. Vérifie ton réseau.";
    }
  }
}