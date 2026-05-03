import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();

  // Liste des services disponibles dans l'app
  final List<String> availableServices = [
    'plomberie', 'électricité', 'nettoyage',
    'jardinage', 'peinture', 'déménagement',
  ];

  Future<bool> initialize() async {
    bool available = await _speech.initialize(
      onError: (error) => print('Erreur STT: $error'),
    );
    await _tts.setLanguage('fr-FR');
    await _tts.setSpeechRate(0.5);
    return available;
  }

  // Écoute et retourne le texte reconnu
  Future<String?> listen() async {
    String? result;
    await _speech.listen(
      onResult: (val) => result = val.recognizedWords.toLowerCase(),
      localeId: 'fr_FR',
    );
    await Future.delayed(const Duration(seconds: 4));
    await _speech.stop();
    return result;
  }

  // Associe la voix à un service
  String? matchService(String spokenText) {
    for (String service in availableServices) {
      if (spokenText.contains(service)) return service;
    }
    return null;
  }

  // Lit un message à voix haute
  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  void dispose() {
    _speech.stop();
    _tts.stop();
  }
}