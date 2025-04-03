import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';
import 'package:hopepals_game/Controllers/answerController.dart';

class VoiceAssistant extends StatefulWidget {
  @override
  _VoiceAssistantState createState() => _VoiceAssistantState();
}

class _VoiceAssistantState extends State<VoiceAssistant> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  String _response = '';
  bool _isProcessing = false;

  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();

  // API Keys
  final String GEMINI_API_KEY = 'AIzaSyApkMnMqV1w2H9TwuxLZ_YhJ7BIxr9HPHA';
  final String ELEVENLABS_API_KEY = 'sk_d0febbd0f65149842dbc304e56188b3e107c059a3197a3c8';
  final String VOICE_ID = '9BWtsMINqrJLrRacOk9x';


  // Rive Animation
  StateMachineController? _stateMachineController;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initializePermissionsAndSetup();
  }

  Future<void> _initializePermissionsAndSetup() async {
    if (await Permission.microphone.request().isGranted) {
      _initializeSpeechToText();
      _loadRiveAnimation();
    } else {
      print('Permiso de micrófono denegado.');
    }
  }

  Future<void> _initializeSpeechToText() async {
    bool isInitialized = await _speech.initialize(onError: (error) {
      print("Error en SpeechToText: $error");
    });

    if (!isInitialized) {
      print('Error al inicializar SpeechToText.');
    }
  }

  Future<void> _loadRiveAnimation() async {
    final bytes = await rootBundle.load('assets/RiveAssets/petstatesv3.riv');
    final file = RiveFile.import(bytes);

    final artboard = file.mainArtboard;
    _stateMachineController = StateMachineController.fromArtboard(
      artboard,
      'PetState',
    );

    if (_stateMachineController != null) {
      artboard.addController(_stateMachineController!);
      setState(() {});
    } else {
      print('Error al cargar la animación de Rive.');
    }
  }

  void _startListening() async {
    if (await Permission.microphone.isGranted) {
      _speech.listen(onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
        });
      });
      setState(() {
        _isListening = true;
      });
    } else {
      print('Permiso de micrófono no concedido.');
    }
  }

  void _stopListening() async {
    if (_isListening) {
      _speech.stop();
      setState(() {
        _isListening = false;
        _isProcessing = true;
      });
      await _processMessage(_text);
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _processMessage(String message) async {
    String botResponse = await _getGeminiResponse(message);
    if (botResponse.isNotEmpty) {
      String formattedResponse = AnswerController.formatResponse(botResponse);
      setState(() {
        _response = formattedResponse;
      });
      await _speakResponse(formattedResponse);
    } else {
      setState(() {
        _response = 'No se recibió una respuesta válida.';
      });
    }
  }

  Future<String> _getGeminiResponse(String message) async {
    final url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$GEMINI_API_KEY';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'contents': [{'parts': [{'text': message}]}]
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        print('Error en la API de Gemini: ${response.body}');
        return '';
      }
    } catch (e) {
      print('Excepción en la API de Gemini: $e');
      return '';
    }
  }

  Future<void> _speakResponse(String text) async {
    final url = 'https://api.elevenlabs.io/v1/text-to-speech/$VOICE_ID';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'xi-api-key': ELEVENLABS_API_KEY,
        },
        body: json.encode({
          'text': text,
          'voice_settings': {'stability': 0.75, 'similarity_boost': 0.8},
        }),
      );

      if (response.statusCode == 200) {
        await _audioPlayer.play(BytesSource(response.bodyBytes));
      } else {
        print('Error al generar audio: ${response.body}');
      }
    } catch (e) {
      print('Excepción al generar audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x24000000),
      appBar: AppBar(
        title: Text('Asistente YGU'),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  child: RiveAnimation.asset('assets/RiveAssets/petstatesv3.riv'),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onLongPress: _startListening,
                  onLongPressUp: _stopListening,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _isListening ? 'Grabando...' : 'Presiona y mantén para hablar',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _buildResponseSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseSection() {
    if (_isProcessing) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 10),
          Text('Generando respuesta...'),
        ],
      );
    } else if (_response.isNotEmpty) {
      return Text('Asistente: $_response');
    } else {
      return SizedBox.shrink();
    }
  }
}
