import 'package:flutter/material.dart';
import 'package:day35/localization/app_language.dart';

class PayoutsPage extends StatelessWidget {
  const PayoutsPage({super.key});

  static const List<Map<String, dynamic>> _payouts = [
    {'id': 'PAY-001', 'date': '2024-05-01', 'amount': '320 TND', 'status': 'Paid', 'method': 'Bank Transfer'},
    {'id': 'PAY-002', 'date': '2024-04-25', 'amount': '450 TND', 'status': 'Paid', 'method': 'Bank Transfer'},
    {'id': 'PAY-003', 'date': '2024-04-18', 'amount': '180 TND', 'status': 'Paid', 'method': 'E-Wallet'},
    {'id': 'PAY-004', 'date': '2024-04-10', 'amount': '275 TND', 'status': 'Paid', 'method': 'Bank Transfer'},
    {'id': 'PAY-005', 'date': '2024-05-05', 'amount': '150 TND', 'status': 'Pending', 'method': 'Bank Transfer'},
  ];

  @override
  Widget build(BuildContext context) {
    final lang = AppLanguageController.instance;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    final totalPaid = _payouts
        .where((p) => p['status'] == 'Paid')
        .fold(0.0, (sum, p) => sum + double.parse((p['amount'] as String).replaceAll(' TND', '')));
    final pendingAmount = _payouts
        .where((p) => p['status'] == 'Pending')
        .fold(0.0, (sum, p) => sum + double.parse((p['amount'] as String).replaceAll(' TND', '')));

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.tr('payouts')),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Summary cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green, Colors.green.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Paid', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                        const SizedBox(height: 4),
                        Text('${totalPaid.toStringAsFixed(0)} TND', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange, Colors.orange.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pending', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                        const SizedBox(height: 4),
                        Text('${pendingAmount.toStringAsFixed(0)} TND', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Payout list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _payouts.length,
              itemBuilder: (context, index) {
                final payout = _payouts[index];
                final isPaid = payout['status'] == 'Paid';
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
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (isPaid ? Colors.green : Colors.orange).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isPaid ? Icons.check_circle_rounded : Icons.schedule_rounded,
                          color: isPaid ? Colors.green : Colors.orange,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(payout['id'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                            const SizedBox(height: 2),
                            Text('${payout['date']} • ${payout['method']}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(payout['amount'], style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: primary)),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: (isPaid ? Colors.green : Colors.orange).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              payout['status'],
                              style: TextStyle(
                                color: isPaid ? Colors.green : Colors.orange,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
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
