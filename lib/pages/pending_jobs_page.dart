import 'package:flutter/material.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/models/booking.dart';

class PendingJobsPage extends StatelessWidget {
  const PendingJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = AppLanguageController.instance;
    final primary = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pendingBookings = BookingStore.instance.all
        .where((b) => b.status == BookingStatus.pending)
        .toList();

    // Fallback sample data if no bookings
    final samplePending = [
      {'client': 'Sarah M.', 'service': 'Leaking Tap', 'price': '45 TND', 'time': '20 mins ago', 'urgent': false},
      {'client': 'Ahmed L.', 'service': 'Emergency Repair', 'price': '150 TND', 'time': '5 mins ago', 'urgent': true},
      {'client': 'Fatima Z.', 'service': 'Pipe Install', 'price': '120 TND', 'time': '1 hour ago', 'urgent': false},
    ];

    final hasBookings = pendingBookings.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.tr('pending')),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.orange.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pending Jobs', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(
                        '${hasBookings ? pendingBookings.length : samplePending.length} Active',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 28),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.hourglass_empty_rounded, color: Colors.white, size: 30),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: hasBookings
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: pendingBookings.length,
                    itemBuilder: (context, index) {
                      final booking = pendingBookings[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Theme.of(context).dividerColor),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.orange.withValues(alpha: 0.1),
                              child: const Icon(Icons.schedule_rounded, color: Colors.orange),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(booking.clientName ?? 'Client', style: const TextStyle(fontWeight: FontWeight.w700)),
                                  Text('${booking.serviceName} • ${booking.price} TND', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('Pending', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w700, fontSize: 12)),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: samplePending.length,
                    itemBuilder: (context, index) {
                      final job = samplePending[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Theme.of(context).dividerColor),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: (job['urgent'] as bool ? Colors.red : Colors.orange).withValues(alpha: 0.1),
                              child: Icon(
                                job['urgent'] as bool ? Icons.priority_high_rounded : Icons.schedule_rounded,
                                color: job['urgent'] as bool ? Colors.red : Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(job['client']! as String, style: const TextStyle(fontWeight: FontWeight.w700)),
                                      if (job['urgent'] as bool) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                                          child: const Text('URGENT', style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ],
                                  ),
                                  Text('${job['service']} • ${job['price']}', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                                  Text(job['time']! as String, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('Pending', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w700, fontSize: 12)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
