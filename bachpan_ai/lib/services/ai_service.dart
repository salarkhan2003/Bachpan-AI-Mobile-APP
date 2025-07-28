import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String defaultApiKey = 'AIzaSyCZ3XGzKPYWP8cjWWwVv2AzmuE7a2Arw50';
  final String apiKey;
  AIService([String? apiKey]) : apiKey = apiKey ?? defaultApiKey;

  Future<String> analyzeCry(String audioPath) async {
    // Placeholder: send audio to Gemini API
    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:analyzeCry?key=$apiKey'),
      body: {'audio': audioPath},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['result'] ?? 'No result';
    } else {
      return 'Error analyzing cry';
    }
  }

  Future<String> analyzeRash(String imagePath) async {
    // Placeholder: send image to Gemini API
    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:analyzeRash?key=$apiKey'),
      body: {'image': imagePath},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['result'] ?? 'No result';
    } else {
      return 'Error analyzing rash';
    }
  }

  Future<String> chatWithAI(String message) async {
    // Placeholder: send message to Gemini API
    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:chat?key=$apiKey'),
      body: {'message': message},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['reply'] ?? 'No reply';
    } else {
      return 'Error chatting with AI';
    }
  }
} 