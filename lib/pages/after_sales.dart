import 'package:flutter/material.dart';
import 'package:day35/models/agreed_booking.dart';
import 'package:day35/widgets/theme_toggle_action.dart';

class AfterSalesPage extends StatelessWidget {
  const AfterSalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<AgreedBooking> bookings = BookingRepository.all();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Apres Vente'),
        actions: const <Widget>[
          ThemeToggleAction(),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Our Guarantee',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'After your service is completed, you still have the right to contact us. '
                  'If anything does not work correctly, our team will help you and follow up '
                  'with the provider until the problem is solved.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Saved negotiated bookings',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 10),
          if (bookings.isEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'No agreed bookings yet. Negotiate in chat and tap Save on the final price badge.',
              ),
            ),
          ...bookings.map(
            (AgreedBooking booking) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.handshake_outlined),
                ),
                title: Text('${booking.providerName} - ${booking.service}'),
                subtitle: Text(
                  '${booking.city}\n${booking.issueDescription}',
                ),
                isThreeLine: true,
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${booking.finalPriceTnd} TND',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You can contact support for:',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 10),
          const _ReasonTile(
            icon: Icons.build_circle_outlined,
            text: 'Service quality issue after completion',
          ),
          const _ReasonTile(
            icon: Icons.warning_amber_rounded,
            text: 'Installed item stopped working',
          ),
          const _ReasonTile(
            icon: Icons.schedule,
            text: 'Need follow-up visit from provider',
          ),
          const _ReasonTile(
            icon: Icons.receipt_long_outlined,
            text: 'Billing/price issue after negotiation',
          ),
          const SizedBox(height: 26),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Support request sent. We will contact you soon.'),
                ),
              );
            },
            icon: const Icon(Icons.support_agent),
            label: const Text('Contact Support Now'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Hotline: +216 70 000 000'),
                ),
              );
            },
            icon: const Icon(Icons.call_outlined),
            label: const Text('Call SAV Hotline'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReasonTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ReasonTile({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.blue.shade600),
      title: Text(text),
    );
  }
}
