import 'package:day35/models/chat_contact.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/models/service_provider.dart';
import 'package:day35/pages/chat_detail.dart';
import 'package:day35/pages/date_time.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ProviderSelectionPage extends StatefulWidget {
  final String serviceName;
  final String serviceImage;

  const ProviderSelectionPage({
    super.key,
    required this.serviceName,
    required this.serviceImage,
  });

  @override
  State<ProviderSelectionPage> createState() => _ProviderSelectionPageState();
}

class _ProviderSelectionPageState extends State<ProviderSelectionPage> {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _isListening = false;
  String _voiceStatus = '';
  ServiceProvider? _selectedProvider;

  // ─── Providers ────────────────────────────────────────────────────────────
  static final Map<String, List<ServiceProvider>> _providersByService = {
    'Cleaning': const [
      ServiceProvider(
        name: 'Yassine Ben Salem',
        city: 'Tunis',
        imageUrl: 'https://i.pravatar.cc/150?img=48',
        rating: 4.9,
        basePriceTnd: 55,
        starterMessages: ['Salem Yassine, I need apartment cleaning.'],
      ),
      ServiceProvider(
        name: 'Rym Triki',
        city: 'La Marsa',
        imageUrl: 'https://i.pravatar.cc/150?img=45',
        rating: 4.7,
        basePriceTnd: 60,
        starterMessages: ['Hello, do you bring your own products?'],
      ),
    ],
    'Plumber': const [
      ServiceProvider(
        name: 'Ala Trabelsi',
        city: 'Sfax',
        imageUrl: 'https://i.pravatar.cc/150?img=12',
        rating: 4.8,
        basePriceTnd: 70,
        starterMessages: ['Salem, I have a leaking pipe in kitchen.'],
      ),
      ServiceProvider(
        name: 'Seif Chatti',
        city: 'Sousse',
        imageUrl: 'https://i.pravatar.cc/150?img=14',
        rating: 4.6,
        basePriceTnd: 65,
        starterMessages: ['Can you come this evening please?'],
      ),
    ],
  };

  static final List<ServiceProvider> _defaultProviders = const [
    ServiceProvider(
      name: 'Mohamed Gharbi',
      city: 'Tunis',
      imageUrl: 'https://i.pravatar.cc/150?img=52',
      rating: 4.8,
      basePriceTnd: 50,
      starterMessages: ['Salem, can we discuss the price?'],
    ),
    ServiceProvider(
      name: 'Amira Jlassi',
      city: 'Nabeul',
      imageUrl: 'https://i.pravatar.cc/150?img=32',
      rating: 4.7,
      basePriceTnd: 55,
      starterMessages: ['Are you available tomorrow afternoon?'],
    ),
  ];

  static final Map<String, List<ServiceExtra>> _extrasByService = {
    'Cleaning': const [
      ServiceExtra(name: 'Windows', imageUrl: 'https://img.icons8.com/external-kiranshastry-lineal-color-kiranshastry/2x/external-window-interiors-kiranshastry-lineal-color-kiranshastry-1.png', priceTnd: 20),
      ServiceExtra(name: 'Fridge',  imageUrl: 'https://img.icons8.com/cotton/2x/fridge.png', priceTnd: 15),
      ServiceExtra(name: 'Oven',    imageUrl: 'https://img.icons8.com/external-becris-lineal-color-becris/2x/external-oven-kitchen-cooking-becris-lineal-color-becris.png', priceTnd: 18),
    ],
    'Plumber': const [
      ServiceExtra(name: 'Emergency visit', imageUrl: 'https://img.icons8.com/color/2x/error--v1.png', priceTnd: 25),
      ServiceExtra(name: 'Spare parts',     imageUrl: 'https://img.icons8.com/color/2x/toolbox.png', priceTnd: 30),
    ],
    'Electrician': const [
      ServiceExtra(name: 'Circuit check', imageUrl: 'https://img.icons8.com/color/2x/electrical.png', priceTnd: 20),
      ServiceExtra(name: 'New socket',    imageUrl: 'https://img.icons8.com/color/2x/electrical-sensor.png', priceTnd: 15),
    ],
  };

  List<ServiceProvider> get providers =>
      _providersByService[widget.serviceName] ?? _defaultProviders;

  List<ServiceExtra> get extras =>
      _extrasByService[widget.serviceName] ??
      const [
        ServiceExtra(name: 'Fast response', imageUrl: 'https://img.icons8.com/color/2x/clock.png', priceTnd: 10),
        ServiceExtra(name: 'Premium tools', imageUrl: 'https://img.icons8.com/color/2x/maintenance.png', priceTnd: 12),
      ];

  // ─── Langue active via ENUM ───────────────────────────────────────────────
  // ✅ On utilise directement AppLanguage enum (pas de string 'fr'/'en'/'ar')
  AppLanguage get _lang => AppLanguageController.instance.current;

  bool get _isFr => _lang == AppLanguage.french;
  bool get _isAr => _lang == AppLanguage.arabic;

  // ─── Config TTS selon la langue ───────────────────────────────────────────
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

  // ─── Locale STT selon la langue ───────────────────────────────────────────
  String get _sttLocale {
    if (_isAr) return 'ar_SA';
    if (_isFr) return 'fr_FR';
    return 'en_US';
  }

  // ─── Textes TTS multilingues ──────────────────────────────────────────────
  String get _serviceNameLocalized =>
      AppLanguageController.instance.trService(widget.serviceName);

  String _ttsProvidersList(String names) {
    if (_isFr) return 'Vous avez choisi $_serviceNameLocalized. Les prestataires disponibles sont : $names. Appuyez sur le micro et dites un nom.';
    if (_isAr) return 'اخترت $_serviceNameLocalized. مزودو الخدمة المتاحون هم: $names. اضغط على الميكروفون وقل اسماً.';
    return 'You selected $_serviceNameLocalized. Available providers are: $names. Tap the microphone and say a name.';
  }

  String _ttsProviderChosen(ServiceProvider p) {
    if (_isFr) return 'Vous avez choisi ${p.name}, noté ${p.rating}, prix ${p.basePriceTnd} dinars. Dites réserver pour réserver, ou discuter pour envoyer un message.';
    if (_isAr) return 'اخترت ${p.name}، تقييمه ${p.rating}، السعر ${p.basePriceTnd} دينار. قل احجز للحجز، أو تحدث للمراسلة.';
    return 'You chose ${p.name}, rated ${p.rating}, price ${p.basePriceTnd} dinars. Say book to reserve, or chat to message.';
  }

  String _ttsBooking(ServiceProvider p) {
    if (_isFr) return 'Réservation de ${p.name}. Ouverture du calendrier.';
    if (_isAr) return 'جارٍ حجز ${p.name}. فتح التقويم.';
    return 'Booking ${p.name}. Opening calendar.';
  }

  String _ttsOpenChat(ServiceProvider p) {
    if (_isFr) return 'Ouverture du chat avec ${p.name}.';
    if (_isAr) return 'فتح المحادثة مع ${p.name}.';
    return 'Opening chat with ${p.name}.';
  }

  String _ttsNotUnderstood() {
    if (_isFr) return 'Désolé, veuillez dire réserver ou discuter.';
    if (_isAr) return 'عذراً، يرجى قول احجز أو تحدث.';
    return 'Sorry, please say book or chat.';
  }

  String _ttsTapMic() {
    if (_isFr) return 'Appuyez sur le micro pour utiliser la voix';
    if (_isAr) return 'اضغط على الميكروفون للاستخدام الصوتي';
    return 'Tap the mic to use voice';
  }

  String _ttsListening() {
    if (_isFr) return 'Écoute... dites un nom de prestataire';
    if (_isAr) return 'جارٍ الاستماع... قل اسم مقدم الخدمة';
    return 'Listening... say a provider name';
  }

  String _ttsSayBookOrChat() {
    if (_isFr) return 'Dites réserver ou discuter...';
    if (_isAr) return 'قل احجز أو تحدث...';
    return 'Say book or chat...';
  }

  String _ttsNotRecognized() {
    if (_isFr) return 'Non compris. Appuyez à nouveau sur le micro.';
    if (_isAr) return 'لم أفهم. اضغط على الميكروفون مجدداً.';
    return 'Not understood. Tap mic again.';
  }

  // ─── Détection BOOK / CHAT multilingue ────────────────────────────────────
  bool _spokenIsBook(String spoken) {
    if (_isFr) return spoken.contains('réserv') || spoken.contains('reserv') || spoken.contains('book');
    if (_isAr) return spoken.contains('احجز') || spoken.contains('حجز');
    return spoken.contains('book') || spoken.contains('reserv');
  }

  bool _spokenIsChat(String spoken) {
    if (_isFr) return spoken.contains('discut') || spoken.contains('message') || spoken.contains('chat');
    if (_isAr) return spoken.contains('تحدث') || spoken.contains('رسالة') || spoken.contains('دردشة');
    return spoken.contains('chat') || spoken.contains('message');
  }

  // ─── Init ─────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _speech.initialize();
    _setupTts();
    _voiceStatus = _ttsTapMic();
    Future.delayed(const Duration(milliseconds: 600), _announceProviders);
  }

  // ─── Étape 1 : annonce les prestataires ───────────────────────────────────
  Future<void> _announceProviders() async {
    await _setupTts();
    final names = providers.map((p) => p.name.split(' ').first).join(', ');
    await _tts.speak(_ttsProvidersList(names));
  }

  // ─── Étape 2 : écoute le nom du prestataire ───────────────────────────────
  Future<void> _listenForProvider() async {
    await _tts.stop();
    await _setupTts();
    setState(() {
      _isListening = true;
      _voiceStatus = _ttsListening();
      _selectedProvider = null;
    });

    String spoken = '';
    await _speech.listen(
      onResult: (val) => spoken = val.recognizedWords.toLowerCase(),
      localeId: _sttLocale,
    );
    await Future.delayed(const Duration(seconds: 4));
    await _speech.stop();

    final match = providers.firstWhere(
      (p) => spoken.contains(p.name.split(' ').first.toLowerCase()),
      orElse: () => providers.first,
    );

    setState(() {
      _selectedProvider = match;
      _isListening = false;
      _voiceStatus = _ttsSayBookOrChat();
    });

    await _tts.speak(_ttsProviderChosen(match));
    await _listenForAction(match);
  }

  // ─── Étape 3 : écoute BOOK ou CHAT ───────────────────────────────────────
  Future<void> _listenForAction(ServiceProvider provider) async {
    await _tts.stop();
    setState(() {
      _isListening = true;
      _voiceStatus = _ttsSayBookOrChat();
    });

    String spoken = '';
    await _speech.listen(
      onResult: (val) => spoken = val.recognizedWords.toLowerCase(),
      localeId: _sttLocale,
    );
    await Future.delayed(const Duration(seconds: 3));
    await _speech.stop();

    setState(() => _isListening = false);

    if (_spokenIsBook(spoken)) {
      // ✅ stop TTS + délai avant navigation
      await _tts.speak(_ttsBooking(provider));
      await _tts.stop();
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      setState(() => _voiceStatus = _ttsTapMic());
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => DateAndTime(
          serviceName: widget.serviceName,
          providerName: provider.name,
          basePriceTnd: provider.basePriceTnd,
          extras: extras,
        ),
      ));
    } else if (_spokenIsChat(spoken)) {
      // ✅ stop TTS + délai avant navigation
      await _tts.speak(_ttsOpenChat(provider));
      await _tts.stop();
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      setState(() => _voiceStatus = _ttsTapMic());
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => ChatDetailPage(
          contact: ChatContact(
            name: provider.name,
            service: widget.serviceName,
            city: provider.city,
            imageUrl: provider.imageUrl,
            starterMessages: provider.starterMessages,
          ),
        ),
      ));
    } else {
      setState(() => _voiceStatus = _ttsNotRecognized());
      await _tts.speak(_ttsNotUnderstood());
    }
  }

  // ─── BUILD ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final AppLanguageController lang = AppLanguageController.instance;
    final Color primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: Text(lang.tr('choose_offerer'))),
      body: Column(
        children: [
          // Header service
          ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(widget.serviceImage)),
            title: Text(lang.trService(widget.serviceName)),
            subtitle: Text(lang.tr('chat')),
          ),

          // Barre vocale
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _isListening ? null : _listenForProvider,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _isListening ? 54 : 46,
                    height: _isListening ? 54 : 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isListening ? Colors.red : primary,
                    ),
                    child: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      color: Colors.white, size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _voiceStatus,
                    style: TextStyle(
                      fontSize: 13,
                      color: _isListening ? Colors.red : primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Liste des prestataires
          Expanded(
            child: ListView.builder(
              itemCount: providers.length,
              itemBuilder: (context, index) {
                final provider = providers[index];
                final isSelected = _selectedProvider?.name == provider.name;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: isSelected
                        ? BorderSide(color: primary, width: 2)
                        : BorderSide.none,
                  ),
                  color: isSelected ? primary.withOpacity(0.07) : null,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage(provider.imageUrl),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(provider.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text('${provider.city} — ⭐ ${provider.rating}'),
                                ],
                              ),
                            ),
                            Text('${provider.basePriceTnd} TND',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, color: primary)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            // ✅ CHAT button — stop TTS + délai avant navigation
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  await _tts.stop();
                                  await Future.delayed(const Duration(milliseconds: 200));
                                  if (!mounted) return;
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (_) => ChatDetailPage(
                                      contact: ChatContact(
                                        name: provider.name,
                                        service: widget.serviceName,
                                        city: provider.city,
                                        imageUrl: provider.imageUrl,
                                        starterMessages: provider.starterMessages,
                                      ),
                                    ),
                                  ));
                                },
                                icon: const Icon(Icons.chat_bubble_outline),
                                label: Text(lang.tr('chat')),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // ✅ BOOK button — stop TTS + délai avant navigation
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  await _tts.stop();
                                  await Future.delayed(const Duration(milliseconds: 200));
                                  if (!mounted) return;
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (_) => DateAndTime(
                                      serviceName: widget.serviceName,
                                      providerName: provider.name,
                                      basePriceTnd: provider.basePriceTnd,
                                      extras: extras,
                                    ),
                                  ));
                                },
                                icon: const Icon(Icons.calendar_month),
                                label: Text(lang.tr('book')),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    _tts.stop();
    super.dispose();
  }
}