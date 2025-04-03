import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final String apiKey = 'AIzaSyApkMnMqV1w2H9TwuxLZ_YhJ7BIxr9HPHA';

  Future<String> _getGeminiResponse(String message) async {
    final url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$apiKey';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
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

        if (responseData != null &&
            responseData['candidates'] != null &&
            responseData['candidates'].isNotEmpty &&
            responseData['candidates'][0]['content'] != null &&
            responseData['candidates'][0]['content']['parts'] != null &&
            responseData['candidates'][0]['content']['parts'].isNotEmpty) {
          final botResponse =
          responseData['candidates'][0]['content']['parts'][0]['text'];
          return botResponse;
        } else {
          return 'Error: la respuesta de la API no contiene el formato esperado.';
        }
      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (error) {
      return 'Error: $error';
    }
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final userMessage = _messageController.text;

      // Limpia el campo de texto inmediatamente después de enviar
      _messageController.clear();

      setState(() {
        _messages.add({'type': 'user', 'message': userMessage});
      });

      // Obtiene la respuesta de la IA
      final botResponse = await _getGeminiResponse(userMessage);

      setState(() {
        _messages.add({'type': 'bot', 'message': botResponse});
      });
    }
  }


  BoxDecoration bubbleDecoration(bool isSent, BuildContext context) {
    return BoxDecoration(
      color: isSent ? Theme.of(context).primaryColor : Colors.blue[50],
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          blurRadius: 10,
          offset: Offset(10, 10),
          color: Colors.black12,
        ),
      ],
    );
  }

  TextStyle messageTextStyle(bool isSent, BuildContext context) {
    return TextStyle(
      fontSize: 14,
      color: isSent ? Colors.white : Theme.of(context).primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x24000000),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Chat"),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + 15), // Espacio para la navbar
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUserMessage = message['type'] == 'user';
                  return Align(
                    alignment:
                    isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      decoration: bubbleDecoration(isUserMessage, context),
                      constraints: BoxConstraints(
                          maxWidth:
                          MediaQuery.of(context).size.width * 2 / 3),
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.all(8),
                      child: Text(
                        message['message']!,
                        style: messageTextStyle(isUserMessage, context),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.text,
                      controller: _messageController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25), // Bordes redondeados
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25), // Mantiene los bordes redondeados
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        hintText: 'Escribe un mensaje...',
                        hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ClipOval(
                    child: Material(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.4),
                        ),
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color:
                            Theme.of(context).colorScheme.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            splashColor: Colors.greenAccent[400],
                            highlightColor: Colors.greenAccent[400],
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: _sendMessage,
                          ),
                        ),
                      ),
                    ),
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
