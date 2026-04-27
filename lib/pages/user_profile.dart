import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: primary.withOpacity(0.2),
            backgroundImage: const NetworkImage(
              'https://uifaces.co/our-content/donated/NY9hnAbp.jpg',
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Bacem Ben Salah',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'bacem@email.com',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: Icon(Icons.phone, color: primary),
              title: const Text('+216 55 123 456'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.location_on, color: primary),
              title: const Text('Tunis, Tunisia'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.calendar_month, color: primary),
              title: const Text('Bookings completed: 12'),
            ),
          ),
        ],
      ),
    );
  }
}
