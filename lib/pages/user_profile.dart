import 'package:flutter/material.dart';
import 'package:day35/widgets/theme_toggle_action.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: const <Widget>[
          ThemeToggleAction(),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: isDark
                    ? <Color>[Colors.blueGrey.shade900, Colors.black87]
                    : <Color>[primary, primary.withOpacity(0.75)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 44,
                  backgroundImage: NetworkImage(
                    'https://uifaces.co/our-content/donated/NY9hnAbp.jpg',
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Bacem Ben Salah',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'bacem@email.com',
                  style: TextStyle(color: Colors.white.withOpacity(0.9)),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    _ProfileMetric(title: 'Jobs', value: '12'),
                    _ProfileMetric(title: 'Spent', value: '1.2k TND'),
                    _ProfileMetric(title: 'Rate', value: '4.9'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _infoTile(
            context,
            icon: Icons.phone_outlined,
            title: 'Phone',
            value: '+216 55 123 456',
          ),
          _infoTile(
            context,
            icon: Icons.location_on_outlined,
            title: 'Location',
            value: 'Tunis, Tunisia',
          ),
          _infoTile(
            context,
            icon: Icons.verified_user_outlined,
            title: 'Membership',
            value: 'Premium since 2024',
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit Profile'),
            style:
                ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.history),
            label: const Text('Booking History'),
            style:
                OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    final Color primary = Theme.of(context).colorScheme.primary;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(value),
      ),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  final String title;
  final String value;

  const _ProfileMetric({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
