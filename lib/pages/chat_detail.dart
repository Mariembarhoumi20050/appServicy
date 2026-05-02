import 'dart:async';

import 'package:day35/models/chat_contact.dart';
import 'package:day35/models/booking.dart';
import 'package:day35/services/storage_service.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/pages/rating_page.dart';
import 'package:day35/pages/my_bookings_page.dart';
import 'package:day35/pages/offerer_dashboard.dart';
import 'package:day35/theme/app_theme.dart';
import 'package:day35/widgets/app_actions.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ChatDetailPage extends StatefulWidget {
  final ChatContact contact;

  const ChatDetailPage({super.key, required this.contact});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<ChatMessage> _messages;
  late int _currentQuote;
  late int _minQuote;
  int? _agreedPrice;
  int _negotiationRounds = 0;
  bool _isTyping = false;
  Position? _userPosition;
  bool _safetyChecklistAccepted = false;
  bool _autoShareEmergencyContact = true;
  final TextEditingController _emergencyContactController = TextEditingController();
  Timer? _safetyCheckInTimer;
  final AppUser? _currentUser = StorageService.instance.getUser();
  bool get _isProviderView =>
      (_currentUser?.role.toLowerCase() == 'provider') || widget.contact.isClient;
  int? get _clientBudgetTnd => widget.contact.clientBudgetTnd;
  static const Set<String> _blockedTerms = <String>{
    'stupid',
    'idiot',
    'hate',
    'kill',
    'moron',
    'attack',
  };

  @override
  void initState() {
    super.initState();
    _currentQuote = widget.contact.quotedPriceTnd ?? 70;
    _minQuote = widget.contact.minNegotiablePriceTnd ?? (_currentQuote - 15);
    _loadHistory();
    _detectUserLocation();
    _emergencyContactController.text = StorageService.instance.getEmergencyContact();
    _scrollToBottom();
  }

  void _loadHistory() {
    if (_currentUser == null) return;
    final lang = AppLanguageController.instance;
    
    final history = StorageService.instance.getChatHistory(
      _currentUser.id, 
      widget.contact.name,
    );

    if (history.isEmpty) {
      _messages = [
        ChatMessage(
          senderId: widget.contact.name,
          receiverId: _currentUser.id,
          text: lang.tr('chat_welcome')
              .replaceAll('{name}', widget.contact.name)
              .replaceAll('{service}', lang.trService(widget.contact.service))
              .replaceAll('{city}', widget.contact.city),
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          isMine: false,
        ),
        for (int i = 0; i < widget.contact.starterMessages.length; i++)
          ChatMessage(
            senderId: _currentUser.id,
            receiverId: widget.contact.name,
            text: widget.contact.starterMessages[i],
            timestamp: DateTime.now().subtract(Duration(minutes: 4 - i)),
            isMine: true,
          ),
        if (widget.contact.issueDescription != null)
          ChatMessage(
            senderId: widget.contact.name,
            receiverId: _currentUser.id,
            text: '${lang.tr('issue_noted')}: ${widget.contact.issueDescription}',
            timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
            isMine: false,
          ),
        ChatMessage(
          senderId: widget.contact.name,
          receiverId: _currentUser.id,
          text: '${lang.tr('first_quote')}: $_currentQuote TND. ${lang.tr('negotiation_invite')}',
          timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
          isMine: false,
        ),
      ];
      // Save initial messages
      for (var m in _messages) {
        StorageService.instance.saveMessage(m);
      }
    } else {
      _messages = history;
    }
  }

  @override
  void dispose() {
    _safetyCheckInTimer?.cancel();
    _emergencyContactController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() async {
    final String text = _messageController.text.trim();
    if (text.isEmpty || _currentUser == null) return;
    if (_containsBlockedText(text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLanguageController.instance.tr('blocked_message_warning'))),
      );
      return;
    }

    ChatMessage msg = ChatMessage(
      senderId: _currentUser.id,
      receiverId: widget.contact.name,
      text: text,
      timestamp: DateTime.now(),
      isMine: true,
    );

    setState(() {
      _messages.add(msg);
      _messageController.clear();
    });
    StorageService.instance.saveMessage(msg);
    _scrollToBottom();
    final int justSentIndex = _messages.length - 1;

    await Future.delayed(const Duration(milliseconds: 450));
    if (mounted && justSentIndex < _messages.length && _messages[justSentIndex].isMine) {
      setState(() {
        _messages[justSentIndex] = _messages[justSentIndex].copyWith(status: 1);
      });
    }

    // Auto-reply logic
    setState(() => _isTyping = true);
    await Future.delayed(Duration(milliseconds: 900 + (_negotiationRounds * 200)));
    if (!mounted) return;

    String replyText = _autoReply(text);

    ChatMessage reply = ChatMessage(
      senderId: widget.contact.name,
      receiverId: _currentUser.id,
      text: replyText,
      timestamp: DateTime.now(),
      isMine: false,
    );

    setState(() {
      _isTyping = false;
      if (justSentIndex < _messages.length && _messages[justSentIndex].isMine) {
        _messages[justSentIndex] = _messages[justSentIndex].copyWith(status: 2);
      }
      _messages.add(reply);
    });
    StorageService.instance.saveMessage(reply);
    _scrollToBottom();
  }

  String _autoReply(String userText) {
    if (_isProviderView) {
      return _autoReplyAsClient(userText);
    }
    final lang = AppLanguageController.instance;
    final String lower = userText.toLowerCase();
    final RegExp amountRegex = RegExp(r'(\d{2,4})');
    final Match? match = amountRegex.firstMatch(lower);
    final String userCity = _userPosition == null
        ? lang.tr('your_city')
        : '${_userPosition!.latitude.toStringAsFixed(3)}, ${_userPosition!.longitude.toStringAsFixed(3)}';
    final bool confirmsDeal = lower.contains('ok') ||
        lower.contains('agree') ||
        lower.contains('daccord') ||
        lower.contains('faisons') ||
        lower.contains('confirm');

    // Urgency handling
    if (lower.contains('urgent') || lower.contains('vite') || lower.contains('asap') || lower.contains('now')) {
      return lang.tr('chat_urgent_reply').replaceAll('{city}', userCity);
    }

    if (match != null) {
      _negotiationRounds++;
      final int offered = int.tryParse(match.group(1) ?? '') ?? _currentQuote;
      if (offered >= _currentQuote) {
        setState(() => _agreedPrice = offered);
        return lang.tr('chat_deal_confirmed').replaceAll('{price}', offered.toString()).replaceAll('{city}', userCity);
      }
      if (offered >= _minQuote) {
        _currentQuote = offered;
        setState(() => _agreedPrice = offered);
        return lang.tr('chat_price_accepted').replaceAll('{price}', offered.toString()).replaceAll('{city}', userCity);
      }
      final int counter = ((_currentQuote + offered) / 2).round();
      if (counter <= _minQuote) {
        _currentQuote = _minQuote;
        return lang.tr('chat_min_price_reached').replaceAll('{price}', _minQuote.toString()).replaceAll('{city}', userCity);
      }
      _currentQuote = counter;
      return lang.tr('chat_counter_offer').replaceAll('{price}', _currentQuote.toString());
    }

    if (lower.contains('budget') || lower.contains('negoci') || lower.contains('price') || lower.contains('cost') || lower.contains('prix')) {
      return lang.tr('chat_price_query').replaceAll('{price}', _currentQuote.toString()).replaceAll('{city}', userCity);
    }
    if (lower.contains('when') || lower.contains('today') || lower.contains('tomorrow') || lower.contains('dispo') || lower.contains('quand')) {
      return lang.tr('chat_availability_reply').replaceAll('{city}', userCity);
    }
    if (lower.contains('where') || lower.contains('address') || lower.contains('city') || lower.contains('ou')) {
      return lang.tr('chat_location_query').replaceAll('{provider_city}', widget.contact.city).replaceAll('{city}', userCity);
    }
    
    if (confirmsDeal) {
      _agreedPrice = _currentQuote;
      return lang.tr('chat_final_confirmation').replaceAll('{price}', _agreedPrice.toString());
    }

    if (_negotiationRounds >= 3 && _agreedPrice == null) {
      _currentQuote = _currentQuote <= _minQuote + 2 ? _minQuote : _currentQuote - 2;
      return lang.tr('chat_counter_offer').replaceAll('{price}', _currentQuote.toString());
    }

    return lang.tr('chat_default_reply').replaceAll('{provider_city}', widget.contact.city).replaceAll('{price}', _currentQuote.toString());
  }

  String _autoReplyAsClient(String providerText) {
    final lang = AppLanguageController.instance;
    final String lower = providerText.toLowerCase();
    final RegExp amountRegex = RegExp(r'(\d{2,4})');
    final Match? match = amountRegex.firstMatch(lower);
    final int budget = _clientBudgetTnd ?? _currentQuote;

    if (match != null) {
      final int offered = int.tryParse(match.group(1) ?? '') ?? _currentQuote;
      if (offered <= budget) {
        _agreedPrice = offered;
        return '${lang.tr('chat_final_confirmation').replaceAll('{price}', offered.toString())} ${lang.tr('client_thanks')}';
      }
      if (offered <= (budget + 8)) {
        _agreedPrice = offered;
        return lang.tr('client_accepts_small_over_budget').replaceAll('{price}', offered.toString());
      }
      return lang.tr('client_counter_budget').replaceAll('{price}', budget.toString());
    }

    if (lower.contains('address') || lower.contains('where') || lower.contains('location')) {
      return lang.tr('client_address_reply');
    }
    if (lower.contains('time') || lower.contains('today') || lower.contains('tomorrow')) {
      return lang.tr('client_time_reply');
    }
    return lang.tr('client_default_reply').replaceAll('{price}', budget.toString());
  }

  bool _containsBlockedText(String text) {
    final lower = text.toLowerCase();
    return _blockedTerms.any(lower.contains);
  }

  Future<void> _detectUserLocation() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return;
      }
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );
      if (!mounted) return;
      setState(() => _userPosition = position);
    } catch (_) {
      // Keep chat functional even if location is unavailable.
    }
  }

  void _sendQuickMessage(String text) {
    if (_currentUser == null) return;
    _messageController.text = text;
    _sendMessage();
  }

  void _confirmBookingAtAgreedPrice() {
    if (_agreedPrice == null) return;
    final lang = AppLanguageController.instance;
    if (!_safetyChecklistAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.tr('safety_ack_needed'))),
      );
      return;
    }
    
    final booking = Booking(
      id: 'BOOK${DateTime.now().millisecondsSinceEpoch}',
      providerName: _isProviderView ? (_currentUser?.name ?? 'Provider') : widget.contact.name,
      clientName: _isProviderView ? widget.contact.name : null,
      serviceName: widget.contact.service,
      providerImageUrl: _isProviderView
          ? (_currentUser?.imageUrl ?? widget.contact.imageUrl)
          : widget.contact.imageUrl,
      date: 'Today',
      time: 'Negotiated',
      price: _agreedPrice!,
      status: BookingStatus.pending,
      arrivalCode: _generateArrivalCode(),
      progressStep: 1,
    );
    
    BookingStore.instance.add(booking);
    _autoShareSafetyContact();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${lang.tr('booking_confirmed_at')} $_agreedPrice TND!')),
    );
    
    if (_isProviderView) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const OffererDashboard()),
        (Route<dynamic> route) => false,
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MyBookingsPage()),
    );
  }

  void _confirmJobDone() {
    if (_agreedPrice == null) return;
    
    // Simulate updating the last booking with this provider to 'completed'
    final bookings = BookingStore.instance.all;
    if (bookings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLanguageController.instance.tr('no_booking_found'))),
      );
      return;
    }
    final String providerMatchName =
        _isProviderView ? (_currentUser?.name ?? '') : widget.contact.name;
    final lastBooking = bookings.lastWhere(
      (b) => b.providerName == providerMatchName,
      orElse: () => bookings.first,
    );
    
    BookingStore.instance.updateStatus(lastBooking.id, BookingStatus.completed);
    _schedulePostJobSafetyCheckIn();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLanguageController.instance.tr('job_marked_done'))),
    );
    
    if (_isProviderView) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const OffererDashboard()),
        (Route<dynamic> route) => false,
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RatingPage(booking: lastBooking)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppLanguageController.instance,
      builder: (context, _) {
        final colorScheme = Theme.of(context).colorScheme;
        final lang = AppLanguageController.instance;
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.contact.name, style: const TextStyle(fontSize: 16)),
                if (widget.contact.isIdentityVerified)
                  Row(
                    children: [
                      const Icon(Icons.verified_user_rounded, size: 12, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        lang.tr('id_verified'),
                        style: const TextStyle(fontSize: 11, color: Colors.blue),
                      ),
                    ],
                  ),
                Text(
                  _isTyping ? lang.tr('typing') : lang.tr('online'),
                  style: TextStyle(fontSize: 12, color: _isTyping ? colorScheme.primary : Colors.green),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: _showSafetyPanel,
                icon: const Icon(Icons.shield_outlined),
                tooltip: lang.tr('safety_center'),
              ),
              const AppActions(),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) => _ChatMessageWidget(message: _messages[index]),
                ),
              ),
              if (_agreedPrice == null) _buildQuickNegotiationBar(colorScheme),
              if (_agreedPrice != null) _buildDealConfirmationPanel(colorScheme, lang),
              _buildSafetyAcknowledgeRow(lang),
              _buildMessageInput(colorScheme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickNegotiationBar(ColorScheme colorScheme) {
    final lang = AppLanguageController.instance;
    final List<Widget> chips;
    if (_isProviderView) {
      final int suggested = _clientBudgetTnd ?? _currentQuote;
      chips = [
        ActionChip(
          avatar: const Icon(Icons.local_offer_outlined, size: 18),
          label: Text('${lang.tr('offer')} $suggested TND'),
          onPressed: () => _sendQuickMessage('$suggested'),
        ),
        ActionChip(
          avatar: const Icon(Icons.place_outlined, size: 18),
          label: Text(lang.tr('ask_for_address')),
          onPressed: () => _sendQuickMessage('Can you share your exact address please?'),
        ),
        ActionChip(
          avatar: const Icon(Icons.schedule, size: 18),
          backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
          label: Text(lang.tr('confirm_availability')),
          onPressed: () => _sendQuickMessage('I am available today after 18:00.'),
        ),
      ];
    } else {
      chips = [
        ActionChip(
          avatar: const Icon(Icons.price_change_outlined, size: 18),
          label: Text(lang.tr('can_do_less')),
          onPressed: () => _sendQuickMessage('Can you do it for a better price?'),
        ),
        ActionChip(
          avatar: const Icon(Icons.local_offer, size: 18),
          label: Text('${lang.tr('offer')} ${(_currentQuote - 5).clamp(_minQuote, _currentQuote)} TND'),
          onPressed: () => _sendQuickMessage('${(_currentQuote - 5).clamp(_minQuote, _currentQuote)}'),
        ),
        ActionChip(
          avatar: const Icon(Icons.check_circle_outline, size: 18),
          backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
          label: Text(lang.tr('accept_current_quote')),
          onPressed: () => _sendQuickMessage('Ok, I agree at $_currentQuote'),
        ),
      ];
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(CompetitionTokens.radiusMd),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: CompetitionTokens.softShadow(colorScheme.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick actions',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < chips.length; i++) ...[
                  chips[i],
                  if (i != chips.length - 1) const SizedBox(width: 8),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDealConfirmationPanel(
    ColorScheme colorScheme,
    AppLanguageController lang,
  ) {
    final bool canConfirm = _safetyChecklistAccepted && _agreedPrice != null;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(CompetitionTokens.radiusMd),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.28)),
        boxShadow: CompetitionTokens.softShadow(colorScheme.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deal ready: $_agreedPrice TND',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _isProviderView
                ? 'Confirm to add this as an accepted offer in your provider dashboard.'
                : 'Confirm to create your booking now.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: canConfirm ? _confirmBookingAtAgreedPrice : null,
                  icon: const Icon(Icons.bookmark_added_outlined),
                  label: Text(lang.tr('confirm_booking')),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _confirmJobDone,
                  icon: const Icon(Icons.done_all),
                  label: Text(lang.tr('mark_done')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyAcknowledgeRow(AppLanguageController lang) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              lang.tr('safety_confirm_label'),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ),
          Switch.adaptive(
            value: _safetyChecklistAccepted,
            onChanged: (v) => setState(() => _safetyChecklistAccepted = v),
          ),
        ],
      ),
    );
  }

  void _showSafetyPanel() {
    final lang = AppLanguageController.instance;
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lang.tr('safety_center'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(lang.tr('safety_tip_1')),
                Text(lang.tr('safety_tip_2')),
                Text(lang.tr('safety_tip_3')),
                const SizedBox(height: 10),
                TextField(
                  controller: _emergencyContactController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: lang.tr('emergency_contact'),
                    hintText: '+216...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(CompetitionTokens.radiusSm),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(lang.tr('auto_share_emergency_contact')),
                  value: _autoShareEmergencyContact,
                  onChanged: (v) => setState(() => _autoShareEmergencyContact = v),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          StorageService.instance.saveEmergencyContact(_emergencyContactController.text.trim());
                          Navigator.pop(context);
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(content: Text(lang.tr('report_submitted'))),
                          );
                        },
                        icon: const Icon(Icons.flag_outlined),
                        label: Text(lang.tr('report_abuse')),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(content: Text(lang.tr('emergency_help'))),
                          );
                        },
                        icon: const Icon(Icons.call),
                        label: Text(lang.tr('emergency_call')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageInput(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: CompetitionTokens.softShadow(colorScheme.primary),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(CompetitionTokens.radiusLg),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: AppLanguageController.instance.tr('type_message'),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton.small(
              onPressed: _sendMessage,
              elevation: 0,
              child: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }

  void _autoShareSafetyContact() {
    final lang = AppLanguageController.instance;
    final contact = _emergencyContactController.text.trim();
    if (contact.isEmpty) return;
    StorageService.instance.saveEmergencyContact(contact);
    if (!_autoShareEmergencyContact || _currentUser == null) return;

    final ChatMessage safetyMsg = ChatMessage(
      senderId: _currentUser.id,
      receiverId: widget.contact.name,
      text: '${lang.tr('safety_auto_shared_with')} $contact',
      timestamp: DateTime.now(),
      isMine: true,
    );
    _messages.add(safetyMsg);
    StorageService.instance.saveMessage(safetyMsg);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(lang.tr('emergency_contact_shared'))),
    );
  }

  void _schedulePostJobSafetyCheckIn() {
    _safetyCheckInTimer?.cancel();
    _safetyCheckInTimer = Timer(const Duration(seconds: 30), () {
      if (!mounted) return;
      final lang = AppLanguageController.instance;
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(lang.tr('safety_check_in')),
          content: Text(lang.tr('safety_check_in_prompt')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(lang.tr('im_safe')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(lang.tr('emergency_help'))),
                );
              },
              child: Text(lang.tr('need_help')),
            ),
          ],
        ),
      );
    });
  }

  String _generateArrivalCode() {
    final int code = 1000 + (DateTime.now().millisecondsSinceEpoch % 9000);
    return code.toString();
  }
}

class _ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const _ChatMessageWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final timeStr = "${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}";

    return Align(
      alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: message.isMine ? colorScheme.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isMine ? 16 : 0),
            bottomRight: Radius.circular(message.isMine ? 0 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isMine ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timeStr,
              style: TextStyle(
                color: message.isMine ? Colors.white70 : Colors.grey.shade500,
                fontSize: 10,
              ),
            ),
            if (message.isMine)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    message.status == 2
                        ? Icons.done_all
                        : message.status == 1
                            ? Icons.done_all
                            : Icons.check,
                    size: 12,
                    color: message.status == 2
                        ? Colors.lightBlueAccent
                        : (message.isMine ? Colors.white70 : Colors.grey.shade500),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
