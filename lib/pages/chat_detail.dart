import 'package:day35/models/chat_contact.dart';
import 'package:day35/localization/app_language.dart';
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

  @override
  void initState() {
    super.initState();
    _messages = <_ChatMessage>[
      _ChatMessage(
        text:
            'Salem! I am ${widget.contact.name}, your ${widget.contact.service} in ${widget.contact.city}.',
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
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final AppLanguageController lang = AppLanguageController.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
        actions: [
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
}

class _ChatMessage {
  final String text;
  final bool isMine;

  const _ChatMessage({required this.text, required this.isMine});
}
