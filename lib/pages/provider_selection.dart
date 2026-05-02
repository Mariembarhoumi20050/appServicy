import 'package:day35/models/chat_contact.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/models/service_provider.dart';
import 'package:day35/pages/chat_detail.dart';
import 'package:day35/pages/date_time.dart';
import 'package:day35/widgets/app_actions.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  Position? _userPosition;
  bool _isLocating = false;

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
        latitude: 36.8065,
        longitude: 10.1815,
        availabilitySlots: ['Today 17:30', 'Tomorrow 09:00', 'Tomorrow 14:30'],
      ),
      ServiceProvider(
        name: 'Rym Triki',
        city: 'La Marsa',
        imageUrl: 'https://i.pravatar.cc/150?img=45',
        rating: 4.7,
        basePriceTnd: 60,
        starterMessages: ['Hello, do you bring your own products?'],
        latitude: 36.8782,
        longitude: 10.3247,
        availabilitySlots: ['Today 18:00', 'Tomorrow 10:30', 'Fri 15:00'],
      ),
      ServiceProvider(
        name: 'Meriem Gharbi',
        city: 'Ariana',
        imageUrl: 'https://i.pravatar.cc/150?img=41',
        rating: 4.8,
        basePriceTnd: 58,
        starterMessages: ['Hi Meriem, can you clean my kitchen and salon?'],
        latitude: 36.8665,
        longitude: 10.1647,
        availabilitySlots: ['Today 16:45', 'Tomorrow 11:00', 'Sat 09:30'],
      ),
      ServiceProvider(
        name: 'Ines Chatti',
        city: 'Sousse',
        imageUrl: 'https://i.pravatar.cc/150?img=20',
        rating: 4.6,
        basePriceTnd: 52,
        starterMessages: ['Salem Ines, I need a deep cleaning this weekend.'],
        latitude: 35.8256,
        longitude: 10.6084,
        availabilitySlots: ['Tomorrow 08:30', 'Tomorrow 17:00', 'Sun 10:00'],
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
        latitude: 34.7406,
        longitude: 10.7603,
        availabilitySlots: ['Today 19:00', 'Tomorrow 08:00', 'Fri 13:30'],
      ),
      ServiceProvider(
        name: 'Seif Chatti',
        city: 'Sousse',
        imageUrl: 'https://i.pravatar.cc/150?img=14',
        rating: 4.6,
        basePriceTnd: 65,
        starterMessages: ['Can you come this evening please?'],
        latitude: 35.8256,
        longitude: 10.6084,
        availabilitySlots: ['Today 18:30', 'Tomorrow 10:00', 'Sat 16:00'],
      ),
      ServiceProvider(
        name: 'Mohamed Ben Hmida',
        city: 'Tunis',
        imageUrl: 'https://i.pravatar.cc/150?img=53',
        rating: 4.7,
        basePriceTnd: 68,
        starterMessages: ['My bathroom sink is blocked, can you help?'],
        latitude: 36.8065,
        longitude: 10.1815,
        availabilitySlots: ['Today 20:00', 'Tomorrow 09:15', 'Sun 11:00'],
      ),
      ServiceProvider(
        name: 'Wael Jebali',
        city: 'Nabeul',
        imageUrl: 'https://i.pravatar.cc/150?img=64',
        rating: 4.5,
        basePriceTnd: 62,
        starterMessages: ['Need leak repair urgently in my apartment.'],
        latitude: 36.4510,
        longitude: 10.7357,
        availabilitySlots: ['Tomorrow 07:45', 'Tomorrow 14:00', 'Mon 10:30'],
      ),
    ],
    'Electrician': const [
      ServiceProvider(
        name: 'Ahmed Karray',
        city: 'Tunis',
        imageUrl: 'https://i.pravatar.cc/150?img=55',
        rating: 4.9,
        basePriceTnd: 72,
        starterMessages: ['I need to fix frequent power cuts in one room.'],
        latitude: 36.8189,
        longitude: 10.1658,
        availabilitySlots: ['Today 17:00', 'Tomorrow 08:30', 'Fri 12:00'],
      ),
      ServiceProvider(
        name: 'Sami Ayari',
        city: 'Monastir',
        imageUrl: 'https://i.pravatar.cc/150?img=22',
        rating: 4.6,
        basePriceTnd: 64,
        starterMessages: ['Can you install new LED lights tomorrow?'],
        latitude: 35.7779,
        longitude: 10.8262,
        availabilitySlots: ['Tomorrow 10:00', 'Tomorrow 18:30', 'Sat 09:00'],
      ),
      ServiceProvider(
        name: 'Chahinez Ben Amor',
        city: 'Sfax',
        imageUrl: 'https://i.pravatar.cc/150?img=39',
        rating: 4.8,
        basePriceTnd: 70,
        starterMessages: ['Need help with electrical socket replacement.'],
        latitude: 34.7406,
        longitude: 10.7603,
        availabilitySlots: ['Today 16:30', 'Tomorrow 12:00', 'Sun 15:30'],
      ),
    ],
    'AC Repair': const [
      ServiceProvider(
        name: 'Walid Gharbi',
        city: 'Sousse',
        imageUrl: 'https://i.pravatar.cc/150?img=31',
        rating: 4.8,
        basePriceTnd: 80,
        starterMessages: ['My AC is not cooling well, can you check it?'],
        latitude: 35.8256,
        longitude: 10.6084,
        availabilitySlots: ['Today 18:45', 'Tomorrow 09:00', 'Sat 13:00'],
      ),
      ServiceProvider(
        name: 'Hichem Mzoughi',
        city: 'Tunis',
        imageUrl: 'https://i.pravatar.cc/150?img=61',
        rating: 4.7,
        basePriceTnd: 75,
        starterMessages: ['Need AC maintenance before summer season.'],
        latitude: 36.8065,
        longitude: 10.1815,
        availabilitySlots: ['Today 17:15', 'Tomorrow 11:30', 'Fri 14:45'],
      ),
      ServiceProvider(
        name: 'Yosra Dridi',
        city: 'Gabes',
        imageUrl: 'https://i.pravatar.cc/150?img=26',
        rating: 4.5,
        basePriceTnd: 73,
        starterMessages: ['AC has noisy fan and weak airflow.'],
        latitude: 33.8815,
        longitude: 10.0982,
        availabilitySlots: ['Tomorrow 09:45', 'Tomorrow 16:30', 'Mon 08:30'],
      ),
    ],
    'Painter': const [
      ServiceProvider(
        name: 'Riadh Bouazizi',
        city: 'Bizerte',
        imageUrl: 'https://i.pravatar.cc/150?img=57',
        rating: 4.7,
        basePriceTnd: 85,
        starterMessages: ['Need full repaint for 2-bedroom apartment.'],
        latitude: 37.2744,
        longitude: 9.8739,
        availabilitySlots: ['Tomorrow 08:00', 'Fri 10:30', 'Sun 09:30'],
      ),
      ServiceProvider(
        name: 'Olfa Khlifi',
        city: 'Tunis',
        imageUrl: 'https://i.pravatar.cc/150?img=28',
        rating: 4.6,
        basePriceTnd: 78,
        starterMessages: ['Can you refresh wall paint in my living room?'],
        latitude: 36.8065,
        longitude: 10.1815,
        availabilitySlots: ['Today 19:30', 'Tomorrow 13:00', 'Sat 10:15'],
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
      latitude: 36.8065,
      longitude: 10.1815,
      availabilitySlots: ['Today 17:30', 'Tomorrow 09:30', 'Fri 11:00'],
    ),
    ServiceProvider(
      name: 'Amira Jlassi',
      city: 'Nabeul',
      imageUrl: 'https://i.pravatar.cc/150?img=32',
      rating: 4.7,
      basePriceTnd: 55,
      starterMessages: ['Are you available tomorrow afternoon?'],
      latitude: 36.4510,
      longitude: 10.7357,
      availabilitySlots: ['Tomorrow 14:30', 'Sat 09:00', 'Mon 16:00'],
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

  List<ServiceProvider> get _sortedProviders {
    if (_userPosition == null) {
      return providers;
    }
    final List<ServiceProvider> sorted = List<ServiceProvider>.from(providers);
    sorted.sort((ServiceProvider a, ServiceProvider b) {
      final double da = _distanceKm(a);
      final double db = _distanceKm(b);
      return da.compareTo(db);
    });
    return sorted;
  }

  List<ServiceExtra> get extras =>
      _extrasByService[widget.serviceName] ??
      const [
        ServiceExtra(name: 'Fast response', imageUrl: 'https://img.icons8.com/color/2x/clock.png', priceTnd: 10),
        ServiceExtra(name: 'Premium tools', imageUrl: 'https://img.icons8.com/color/2x/maintenance.png', priceTnd: 12),
      ];

  // ─── Langue active via ENUM ───────────────────────────────────────────────
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
    _detectLocation();
    _voiceStatus = _ttsTapMic();
    Future.delayed(const Duration(milliseconds: 600), _announceProviders);
  }

  Future<void> _detectLocation() async {
    setState(() => _isLocating = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
      final Position position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() => _userPosition = position);
    } catch (_) {
      // Keep manual city listing if location cannot be resolved.
    } finally {
      if (mounted) {
        setState(() => _isLocating = false);
      }
    }
  }

  double _distanceKm(ServiceProvider provider) {
    if (_userPosition == null) {
      return 0;
    }
    final double meters = Geolocator.distanceBetween(
      _userPosition!.latitude,
      _userPosition!.longitude,
      provider.latitude,
      provider.longitude,
    );
    return meters / 1000;
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
      await _tts.speak(_ttsBooking(provider));
      await _tts.stop();
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      setState(() => _voiceStatus = _ttsTapMic());
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => DateAndTime(
          serviceName: widget.serviceName,
          providerName: provider.name,
          providerCity: provider.city,
          providerImageUrl: provider.imageUrl,
          basePriceTnd: provider.basePriceTnd,
          distanceKm: _userPosition == null ? null : _distanceKm(provider),
          availabilitySlots: provider.availabilitySlots,
          extras: extras,
        ),
      ));
    } else if (_spokenIsChat(spoken)) {
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
            quotedPriceTnd: provider.basePriceTnd + 10,
            minNegotiablePriceTnd: (provider.basePriceTnd * 0.85).round(),
            issueDescription: 'Need ${widget.serviceName.toLowerCase()} service near ${provider.city}.',
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
      appBar: AppBar(
        title: Text(lang.tr('choose_offerer')),
        actions: const [
          AppActions(),
        ],
      ),
      body: Column(
        children: [
          // Header service - Modernized
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.05),
              border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
            ),
            child: Row(
              children: [
                Hero(
                  tag: 'service_${widget.serviceName}',
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: primary.withValues(alpha: 0.1),
                    backgroundImage: NetworkImage(widget.serviceImage),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.trService(widget.serviceName),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${providers.length} ${lang.tr('available_specialists')}',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Barre vocale - Enhanced
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _isListening ? null : _listenForProvider,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (_isListening)
                        const SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: _isListening 
                              ? [Colors.red, Colors.redAccent] 
                              : [primary, primary.withValues(alpha: 0.8)],
                          ),
                        ),
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_none_rounded,
                          color: Colors.white, size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isListening ? 'Listening...' : 'Voice Assistant',
                        style: TextStyle(
                          fontSize: 12,
                          color: _isListening ? Colors.red : primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _voiceStatus,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Liste des prestataires - Redesigned for realism
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: _sortedProviders.length,
              itemBuilder: (context, index) {
                final provider = _sortedProviders[index];
                final isSelected = _selectedProvider?.name == provider.name;
                final double dist = _distanceKm(provider);
                
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected ? primary : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 32,
                                    backgroundImage: NetworkImage(provider.imageUrl),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.verified, color: Colors.blue, size: 20),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          provider.name,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                        ),
                                        Text(
                                          '${provider.basePriceTnd} TND',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900, 
                                            color: primary,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on_rounded, size: 14, color: Colors.grey.shade500),
                                        const SizedBox(width: 4),
                                        Text(
                                          _userPosition == null ? provider.city : '${provider.city} • ${dist.toStringAsFixed(1)} km',
                                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                        ),
                                        const SizedBox(width: 12),
                                        Icon(Icons.star_rounded, size: 16, color: Colors.amber.shade700),
                                        const SizedBox(width: 2),
                                        Text(
                                          provider.rating.toString(),
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Next: ${provider.availabilitySlots.first}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton.icon(
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
                                          quotedPriceTnd: provider.basePriceTnd + 10,
                                          minNegotiablePriceTnd: (provider.basePriceTnd * 0.85).round(),
                                          issueDescription: 'Need ${widget.serviceName.toLowerCase()} service near ${provider.city}.',
                                          starterMessages: provider.starterMessages,
                                        ),
                                      ),
                                    ));
                                  },
                                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                                  label: Text(lang.tr('chat')),
                                  style: TextButton.styleFrom(
                                    foregroundColor: primary,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
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
                                        providerCity: provider.city,
                                        providerImageUrl: provider.imageUrl,
                                        basePriceTnd: provider.basePriceTnd,
                                        distanceKm: _userPosition == null ? null : dist,
                                        availabilitySlots: provider.availabilitySlots,
                                        extras: extras,
                                      ),
                                    ));
                                  },
                                  icon: const Icon(Icons.calendar_month_rounded, size: 18),
                                  label: Text(lang.tr('book')),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primary,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              },
            ),
          ),
          
          // Location Info Footer
          if (_isLocating || _userPosition != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.05),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Icon(
                    _isLocating ? Icons.sync : Icons.location_on_rounded,
                    size: 18,
                    color: primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _isLocating
                          ? 'Locating you for better results...'
                          : 'Showing specialists near your location.',
                      style: TextStyle(
                        fontSize: 13,
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
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