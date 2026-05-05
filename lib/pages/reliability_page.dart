import 'package:flutter/material.dart';
import 'package:day35/localization/app_language.dart';

class ReliabilityPage extends StatelessWidget {
  const ReliabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = AppLanguageController.instance;
    final primary = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final metrics = [
      {'title': 'On-time Arrival', 'value': '96%', 'icon': Icons.schedule_rounded, 'color': Colors.green},
      {'title': 'Job Completion Rate', 'value': '98%', 'icon': Icons.task_alt_rounded, 'color': Colors.blue},
      {'title': 'Client Satisfaction', 'value': '4.9/5', 'icon': Icons.star_rounded, 'color': Colors.amber},
      {'title': 'Response Time', 'value': '< 2 min', 'icon': Icons.speed_rounded, 'color': Colors.purple},
      {'title': 'Cancellation Rate', 'value': '2%', 'icon': Icons.cancel_outlined, 'color': Colors.red},
      {'title': 'Profile Verification', 'value': '100%', 'icon': Icons.verified_user_rounded, 'color': Colors.teal},
    ];

    final badges = [
      {'title': 'Top Rated', 'icon': Icons.emoji_events_rounded, 'color': Colors.amber, 'earned': true},
      {'title': 'Fast Responder', 'icon': Icons.bolt_rounded, 'color': Colors.blue, 'earned': true},
      {'title': '100 Jobs Club', 'icon': Icons.military_tech_rounded, 'color': Colors.purple, 'earned': false},
      {'title': 'Zero Cancellations', 'icon': Icons.shield_rounded, 'color': Colors.green, 'earned': false},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.tr('reliability')),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall score
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.green.shade700],
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
                        Text('Reliability Score', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
                        const SizedBox(height: 4),
                        const Text('98%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 36)),
                        const SizedBox(height: 4),
                        Text('Excellent — Top 5% of providers', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified_rounded, color: Colors.white, size: 40),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Metrics grid
            Text('Performance Metrics', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: isDark ? Colors.white : Colors.black87)),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: metrics.map((m) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(m['icon'] as IconData, color: m['color'] as Color, size: 22),
                          const Spacer(),
                          Text(m['value']! as String, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: primary)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(m['title']! as String, style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Badges
            Text('Achievement Badges', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: isDark ? Colors.white : Colors.black87)),
            const SizedBox(height: 12),
            ...badges.map((b) {
              final earned = b['earned'] == true;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: earned ? (b['color'] as Color).withValues(alpha: 0.3) : Theme.of(context).dividerColor,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: earned ? (b['color'] as Color).withValues(alpha: 0.12) : Colors.grey.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        b['icon'] as IconData,
                        color: earned ? (b['color'] as Color) : Colors.grey,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        b['title']! as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: earned ? null : Colors.grey,
                        ),
                      ),
                    ),
                    if (earned)
                      const Icon(Icons.check_circle_rounded, color: Colors.green, size: 22)
                    else
                      Text('Locked', style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w600)),
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
