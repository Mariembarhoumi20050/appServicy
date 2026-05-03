import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/pages/provider_selection.dart';

class VoiceScreen extends StatefulWidget {
  final List<String> services;
  const VoiceScreen({super.key, required this.services});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen>
    with SingleTickerProviderStateMixin {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _isListening = false;
  String _statusText = '';
  String? _detectedService;
  late AnimationController _pulse;

  // ─── Langue via ENUM ──────────────────────────────────────────────────────
  AppLanguage get _lang => AppLanguageController.instance.current;
  bool get _isFr => _lang == AppLanguage.french;
  bool get _isAr => _lang == AppLanguage.arabic;

  // ─── Config TTS ───────────────────────────────────────────────────────────
  Future<void> _setupTts() async {
    if (_isAr) {
      await _tts.setLanguage('ar-SA');
    } else if (_isFr) {
      await _tts.setLanguage('fr-FR');
    } else {
      await _tts.setLanguage('en-US');
    }
    await _tts.setSpeechRate(0.9);
  }

  String get _sttLocale {
    if (_isAr) return 'ar_SA';
    if (_isFr) return 'fr_FR';
    return 'en_US';
  }

  // ─── Textes TTS multilingues ──────────────────────────────────────────────
  String get _ttsQuestion {
    if (_isFr) return 'De quel service avez-vous besoin ?';
    if (_isAr) return 'ما هي الخدمة التي تحتاجها؟';
    return 'Which service do you need?';
  }

  String _ttsSelected(String service) {
    final localized = AppLanguageController.instance.trService(service);
    if (_isFr) return 'Vous avez sélectionné $localized';
    if (_isAr) return 'لقد اخترت $localized';
    return 'You selected $localized';
  }

  String get _ttsNotUnderstood {
    if (_isFr) return 'Désolé, je n\'ai pas compris. Réessayez.';
    if (_isAr) return 'عذراً، لم أفهم. حاول مرة أخرى.';
    return 'Sorry, I did not understand. Please try again.';
  }

  String get _statusInitial {
    if (_isFr) return 'Appuyez sur le micro et dites un service';
    if (_isAr) return 'اضغط على الميكروفون وقل الخدمة';
    return 'Press the mic and say a service name';
  }

  String get _statusListening {
    if (_isFr) return 'Écoute...';
    if (_isAr) return 'جارٍ الاستماع...';
    return 'Listening...';
  }

  String _statusDetected(String service) {
    final localized = AppLanguageController.instance.trService(service);
    if (_isFr) return 'Détecté : $localized';
    if (_isAr) return 'تم اكتشاف : $localized';
    return 'Detected: $localized';
  }

  String get _statusNotRecognized {
    if (_isFr) return 'Non reconnu. Réessayez.';
    if (_isAr) return 'لم يُتعرف عليه. حاول مرة أخرى.';
    return 'Not recognized. Try again.';
  }

  String _confirmLabel(String service) {
    final localized = AppLanguageController.instance.trService(service);
    if (_isFr) return 'Confirmer : $localized';
    if (_isAr) return 'تأكيد : $localized';
    return 'Confirm: $localized';
  }

  // ─── Map image par service ────────────────────────────────────────────────
  static const Map<String, String> _serviceImages = {
    'Cleaning':         'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-cleaning-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png',
    'Plumber':          'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-plumber-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png',
    'Electrician':      'https://img.icons8.com/external-wanicon-flat-wanicon/2x/external-multimeter-car-service-wanicon-flat-wanicon.png',
    'Painter':          'https://img.icons8.com/external-itim2101-flat-itim2101/2x/external-painter-male-occupation-avatar-itim2101-flat-itim2101.png',
    'Carpenter':        'https://img.icons8.com/fluency/2x/drill.png',
    'Gardener':         'https://img.icons8.com/external-itim2101-flat-itim2101/2x/external-gardener-male-occupation-avatar-itim2101-flat-itim2101.png',
    'Tailor':           'https://img.icons8.com/fluency/2x/sewing-machine.png',
    'Maid':             'https://img.icons8.com/color/2x/housekeeper-female.png',
    'Driver':           'https://img.icons8.com/external-sbts2018-lineal-color-sbts2018/2x/external-driver-women-profession-sbts2018-lineal-color-sbts2018.png',
    'Cook':             'https://img.icons8.com/external-wanicon-flat-wanicon/2x/external-cooking-daily-routine-wanicon-flat-wanicon.png',
    'AC Repair':        'https://img.icons8.com/color/2x/air-conditioner.png',
    'Pest Control':     'https://img.icons8.com/color/2x/bug.png',
    'Appliance Repair': 'https://img.icons8.com/color/2x/maintenance.png',
    'Babysitting':      'https://img.icons8.com/color/2x/nanny.png',
  };

  // ─── Init ─────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _speech.initialize();
    _setupTts();
    _statusText = _statusInitial;
  }

  // ─── Écoute + détection du service ───────────────────────────────────────
  Future<void> _listen() async {
    await _tts.stop();
    await _setupTts();
    setState(() {
      _isListening = true;
      _statusText = _statusListening;
      _detectedService = null;
    });

    await _tts.speak(_ttsQuestion);
    await Future.delayed(const Duration(seconds: 2));

    String spoken = '';
    await _speech.listen(
      onResult: (val) => spoken = val.recognizedWords.toLowerCase(),
      localeId: _sttLocale,
    );
    await Future.delayed(const Duration(seconds: 4));
    await _speech.stop();

    // Cherche le service dans la liste EN (clé interne) et aussi dans la traduction locale
    final match = widget.services.firstWhere(
      (s) {
        final localized = AppLanguageController.instance.trService(s).toLowerCase();
        return spoken.contains(s.toLowerCase()) || spoken.contains(localized);
      },
      orElse: () => '',
    );

    if (match.isNotEmpty) {
      await _tts.speak(_ttsSelected(match));
      setState(() {
        _detectedService = match;
        _statusText = _statusDetected(match);
      });
    } else {
      await _tts.speak(_ttsNotUnderstood);
      setState(() => _statusText = _statusNotRecognized);
    }

    setState(() => _isListening = false);
  }

  // ─── Confirmation → ProviderSelectionPage ────────────────────────────────
  Future<void> _confirm() async {
    await _tts.stop();
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted || _detectedService == null) return;
    final service = _detectedService!;
    final image = _serviceImages[service] ?? 'https://img.icons8.com/color/2x/maintenance.png';
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ProviderSelectionPage(
          serviceName: service,
          serviceImage: image,
        ),
      ),
    );
  }

  // ─── BUILD ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Mode')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _statusInitial,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Affiche les services traduits dans la langue courante
            Wrap(
              spacing: 8, runSpacing: 8,
              children: widget.services
                  .map((s) => Chip(
                        label: Text(AppLanguageController.instance.trService(s)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 48),
            GestureDetector(
              onTap: _isListening ? null : _listen,
              child: AnimatedBuilder(
                animation: _pulse,
                builder: (_, __) {
                  final size = _isListening ? 100 + _pulse.value * 18 : 100.0;
                  return Container(
                    width: size, height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isListening ? Colors.red : color,
                    ),
                    child: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      size: 44, color: Colors.white,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _statusText,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            if (_detectedService != null) ...[
              const SizedBox(height: 24),
              // ✅ BUG 2 FIXED : navigue vers ProviderSelectionPage
              ElevatedButton.icon(
                onPressed: _confirm,
                icon: const Icon(Icons.check),
                label: Text(_confirmLabel(_detectedService!)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    _speech.stop();
    _tts.stop();
    super.dispose();
  }
}