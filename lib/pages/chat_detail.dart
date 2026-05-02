import 'package:day35/models/chat_contact.dart';
import 'package:day35/models/agreed_booking.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/widgets/theme_toggle_action.dart';
import 'package:flutter/material.dart';

class ChatDetailPage extends StatefulWidget {
  final ChatContact contact;

  const ChatDetailPage({super.key, required this.contact});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  late final List<_ChatMessage> _messages;
  late int _currentQuote;
  late int _minQuote;
  int? _agreedPrice;
  bool _isAgreementSaved = false;

  @override
  void initState() {
    super.initState();
    _currentQuote = widget.contact.quotedPriceTnd ?? 70;
    _minQuote = widget.contact.minNegotiablePriceTnd ?? (_currentQuote - 15);
    _messages = <_ChatMessage>[
      _ChatMessage(
        text:
            'Salem! I am ${widget.contact.name}, your ${widget.contact.service} in ${widget.contact.city}.',
        isMine: false,
      ),
      if (widget.contact.issueDescription != null)
        _ChatMessage(
          text: 'Issue noted: ${widget.contact.issueDescription}',
          isMine: false,
        ),
      _ChatMessage(
        text:
            'My first quote is $_currentQuote TND. We can discuss based on details and your budget.',
        isMine: false,
      ),
      ...widget.contact.starterMessages.map(
        (message) => _ChatMessage(text: message, isMine: true),
      ),
      const _ChatMessage(
        text: 'Perfect, I can come today after 17:00 if it works for you.',
        isMine: false,
      ),
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final String text = _messageController.text.trim();
    if (text.isEmpty) {
      return;
    }

    setState(() {
      _messages.add(_ChatMessage(text: text, isMine: true));
      _messages.add(_ChatMessage(text: _autoReply(text), isMine: false));
    });
    _messageController.clear();
  }

  String _autoReply(String userText) {
    final String lower = userText.toLowerCase();
    final RegExp amountRegex = RegExp(r'(\d{2,4})');
    final Match? match = amountRegex.firstMatch(lower);

    if (match != null) {
      final int offered = int.tryParse(match.group(1) ?? '') ?? _currentQuote;
      if (offered >= _currentQuote) {
        _agreedPrice = offered;
        return 'Perfect, deal confirmed at $offered TND. I will prioritize your request.';
      }
      if (offered >= _minQuote) {
        _currentQuote = offered;
        _agreedPrice = offered;
        return 'Fair offer. I accept $offered TND. Please confirm date and exact address.';
      }
      final int counter = ((_currentQuote + offered) / 2).round();
      if (counter <= _minQuote) {
        _currentQuote = _minQuote;
        return 'I cannot go below $_minQuote TND for quality work. If you agree, we can confirm now.';
      }
      _currentQuote = counter;
      return 'I understand your budget. My best counter offer is $_currentQuote TND including transport.';
    }

    if (lower.contains('budget') ||
        lower.contains('negotiat') ||
        lower.contains('price')) {
      return 'My current quote is $_currentQuote TND. You can send your offer and we find a middle point.';
    }
    if (lower.contains('when') || lower.contains('today') || lower.contains('tomorrow')) {
      return 'I am available today after 17:00 and tomorrow morning. Which time suits you?';
    }
    return 'Thanks for details. Send me your budget in TND and I will confirm final quote quickly.';
  }

  @override
  Widget build(BuildContext context) {
    final AppLanguageController lang = AppLanguageController.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
        actions: [
          const ThemeToggleAction(),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(
              child: Text(
                lang.trService(widget.contact.service),
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_agreedPrice != null)
              Container(
                margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.35)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Final agreed price: $_agreedPrice TND',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    TextButton(
                      onPressed: _isAgreementSaved ? null : _saveAgreement,
                      child: Text(_isAgreementSaved ? 'Saved' : 'Save'),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final int reverseIndex = _messages.length - 1 - index;
                  final _ChatMessage message = _messages[reverseIndex];
                  return Align(
                    alignment: message.isMine
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color:
                            message.isMine
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: message.isMine ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FloatingActionButton(
                    heroTag: 'chatSend',
                    mini: true,
                    onPressed: _sendMessage,
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveAgreement() {
    if (_agreedPrice == null || _isAgreementSaved) {
      return;
    }
    BookingRepository.add(
      AgreedBooking(
        providerName: widget.contact.name,
        service: widget.contact.service,
        city: widget.contact.city,
        finalPriceTnd: _agreedPrice!,
        issueDescription:
            widget.contact.issueDescription ?? 'General service request.',
        agreedAt: DateTime.now(),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Agreement saved in your bookings.')),
    );
    setState(() {
      _isAgreementSaved = true;
    });
  }
}

class _ChatMessage {
  final String text;
  final bool isMine;

  const _ChatMessage({required this.text, required this.isMine});
}
