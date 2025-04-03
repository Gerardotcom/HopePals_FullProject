import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatController {
  final TextEditingController messageController = TextEditingController();
  final String apiKey = 'AIzaSyApkMnMqV1w2H9TwuxLZ_YhJ7BIxr9HPHA';
  final List<Map<String, String>> messages = [];

  // Método simplificado para manejar la respuesta de la API
  Future<String> getGeminiResponse(String message) async {
    final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$apiKey';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': message}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Asegurarse de que la respuesta de la API tiene los campos esperados
        if (responseData != null && responseData['candidates'] != null && responseData['candidates'].isNotEmpty) {
          return responseData['candidates'][0]['content'] ?? 'No response content available';
        } else {
          return 'Error: La respuesta de la API no contiene el formato esperado.';
        }
      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (error) {
      return 'Error de conexión: $error';
    }
  }

  // Método para enviar un mensaje y actualizar la lista de mensajes
  Future<void> sendMessage(Function updateMessages) async {
    if (messageController.text.isNotEmpty) {
      final userMessage = messageController.text;
      messages.add({'type': 'user', 'message': userMessage});
      updateMessages();

      final botResponse = await getGeminiResponse(userMessage);
      messages.add({'type': 'bot', 'message': botResponse});
      messageController.clear();
      updateMessages();
    }
  }
}
