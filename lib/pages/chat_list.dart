import 'package:day35/models/chat_contact.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/pages/chat_detail.dart';
import 'package:day35/widgets/theme_toggle_action.dart';
import 'package:flutter/material.dart';

class ChatListPage extends StatelessWidget {
  ChatListPage({super.key});

  final List<ChatContact> contacts = <ChatContact>[
    ChatContact(
      name: 'Mohamed Trabelsi',
      service: 'Plumber',
      city: 'Tunis',
      imageUrl: 'https://i.pravatar.cc/150?img=12',
      quotedPriceTnd: 78,
      minNegotiablePriceTnd: 65,
      issueDescription: 'Kitchen water leak with low pressure.',
      starterMessages: <String>[
        'Hi Mohamed, I have a water leak in the kitchen.',
        'Can you come today please?',
      ],
    ),
    ChatContact(
      name: 'Asma Ben Ali',
      service: 'Cleaning',
      city: 'Sfax',
      imageUrl: 'https://i.pravatar.cc/150?img=5',
      quotedPriceTnd: 62,
      minNegotiablePriceTnd: 50,
      issueDescription: 'Deep cleaning for 2-bedroom apartment.',
      starterMessages: <String>[
        'Salem Asma, I need full apartment cleaning.',
      ],
    ),
    ChatContact(
      name: 'Walid Gharbi',
      service: 'AC Repair',
      city: 'Sousse',
      imageUrl: 'https://i.pravatar.cc/150?img=31',
      quotedPriceTnd: 88,
      minNegotiablePriceTnd: 74,
      issueDescription: 'AC not cooling and making noise.',
      starterMessages: <String>[
        'My AC is not cooling well.',
        'Do you work in Khzema area?',
      ],
    ),
    ChatContact(
      name: 'Nour Kallel',
      service: 'Babysitting',
      city: 'Nabeul',
      imageUrl: 'https://i.pravatar.cc/150?img=25',
      quotedPriceTnd: 45,
      minNegotiablePriceTnd: 38,
      issueDescription: 'Babysitting for Friday evening (4 hours).',
      starterMessages: <String>[
        'Hello, I need babysitting on Friday evening.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final AppLanguageController lang = AppLanguageController.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text('${lang.tr('app_name')} chat'),
        actions: const <Widget>[
          ThemeToggleAction(),
        ],
      ),
      body: ListView.separated(
        itemCount: contacts.length,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (BuildContext context, int index) {
          final ChatContact contact = contacts[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(contact.imageUrl),
            ),
            title: Text(contact.name),
            subtitle: Text('${lang.trService(contact.service)} - ${contact.city}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatDetailPage(contact: contact),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
