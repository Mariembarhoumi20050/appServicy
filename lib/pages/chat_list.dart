import 'package:day35/models/chat_contact.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/pages/chat_detail.dart';
import 'package:flutter/material.dart';

class ChatListPage extends StatelessWidget {
  ChatListPage({super.key});

  final List<ChatContact> contacts = <ChatContact>[
    ChatContact(
      name: 'Mohamed Trabelsi',
      service: 'Plumber',
      city: 'Tunis',
      imageUrl: 'https://i.pravatar.cc/150?img=12',
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
      starterMessages: <String>[
        'Salem Asma, I need full apartment cleaning.',
      ],
    ),
    ChatContact(
      name: 'Walid Gharbi',
      service: 'AC Repair',
      city: 'Sousse',
      imageUrl: 'https://i.pravatar.cc/150?img=31',
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
