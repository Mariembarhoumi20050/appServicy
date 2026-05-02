import 'package:day35/services/storage_service.dart';
import 'package:day35/widgets/theme_toggle_action.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = StorageService.instance.getUser();
    final bool isProvider = currentUser?.role == 'Provider';

    final List<Map<String, String>> providerNotifications = [
      {
        'title': 'New Job Request',
        'body': 'Sarah M. requested a Leaking Tap service near you.',
        'time': '10 mins ago',
        'type': 'request'
      },
      {
        'title': 'Payment Received',
        'body': 'You received 120 TND from James K. for the Pipe Install job.',
        'time': '1 hour ago',
        'type': 'payment'
      },
      {
        'title': 'New Review',
        'body': 'Asma B. gave you a 5-star rating! "Great work!"',
        'time': '3 hours ago',
        'type': 'rating'
      },
    ];

    final List<Map<String, String>> clientNotifications = [
      {
        'title': 'Booking Confirmed',
        'body': 'Alex Johnson accepted your request for Plumber service.',
        'time': '5 mins ago',
        'type': 'request'
      },
      {
        'title': 'Service Started',
        'body': 'Mohamed is on his way to your location in Tunis.',
        'time': '20 mins ago',
        'type': 'system'
      },
      {
        'title': 'Special Offer',
        'body': 'Get 10% off on your next House Cleaning booking!',
        'time': '2 hours ago',
        'type': 'payment'
      },
    ];

    final notifications = isProvider ? providerNotifications : clientNotifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: const [
          ThemeToggleAction(),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(notif['type']!),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notif['title']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif['body']!,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notif['time']!,
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon(String type) {
    IconData icon;
    Color color;
    switch (type) {
      case 'request':
        icon = Icons.assignment_outlined;
        color = Colors.blue;
        break;
      case 'payment':
        icon = Icons.account_balance_wallet_outlined;
        color = Colors.green;
        break;
      case 'rating':
        icon = Icons.star_outline;
        color = Colors.amber;
        break;
      default:
        icon = Icons.info_outline;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}
