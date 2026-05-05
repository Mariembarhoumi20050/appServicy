import 'package:flutter/material.dart';
import 'package:day35/localization/app_language.dart';

class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = AppLanguageController.instance;
    final primary = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const totalEarnings = 12500.0;
    const thisMonth = 3200.0;
    const lastMonth = 2800.0;

    final monthlyData = [
      {'month': 'Jan', 'value': 0.6},
      {'month': 'Feb', 'value': 0.75},
      {'month': 'Mar', 'value': 0.5},
      {'month': 'Apr', 'value': 0.9},
      {'month': 'May', 'value': 0.85},
    ];

    final recentEarnings = [
      {'service': 'Pipe Installation', 'client': 'James K.', 'amount': '120 TND', 'date': 'May 1', 'status': 'Completed'},
      {'service': 'Leaking Tap Repair', 'client': 'Sarah M.', 'amount': '45 TND', 'date': 'Apr 30', 'status': 'Completed'},
      {'service': 'Emergency Repair', 'client': 'Mariem B.', 'amount': '150 TND', 'date': 'Apr 28', 'status': 'Completed'},
      {'service': 'Sink Fix', 'client': 'Ahmed L.', 'amount': '60 TND', 'date': 'Apr 25', 'status': 'Completed'},
      {'service': 'Valve Replacement', 'client': 'John D.', 'amount': '80 TND', 'date': 'Apr 20', 'status': 'Pending'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.tr('earnings')),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary, primary.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Earnings', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
                  const SizedBox(height: 4),
                  const Text('12,500 TND', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 28)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('This Month', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
                            Text('3,200 TND', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Last Month', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
                            Text('2,800 TND', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Monthly chart
            Text('Monthly Overview', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: isDark ? Colors.white : Colors.black87)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: SizedBox(
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: monthlyData.map((d) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 32,
                          height: 100 * (d['value'] as double),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primary, primary.withValues(alpha: 0.5)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(d['month']! as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Recent earnings
            Text('Recent Earnings', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: isDark ? Colors.white : Colors.black87)),
            const SizedBox(height: 12),
            ...recentEarnings.map((e) {
              final isCompleted = e['status'] == 'Completed';
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Row(
                  children: [
                    Icon(Icons.account_balance_wallet_rounded, color: isCompleted ? Colors.green : Colors.orange, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e['service']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          Text('${e['client']} • ${e['date']}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                        ],
                      ),
                    ),
                    Text(e['amount']!, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: primary)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
