import 'package:day35/localization/app_language.dart';
import 'package:day35/widgets/app_actions.dart';
import 'package:flutter/material.dart';

class OffererProfilePage extends StatefulWidget {
  final String name;
  final String service;
  final String city;
  final String imageUrl;
  final double rating;
  final ValueChanged<double> onRatingUpdated;

  const OffererProfilePage({
    super.key,
    required this.name,
    required this.service,
    required this.city,
    required this.imageUrl,
    required this.rating,
    required this.onRatingUpdated,
  });

  @override
  State<OffererProfilePage> createState() => _OffererProfilePageState();
}

class _OffererProfilePageState extends State<OffererProfilePage> {
  int _selectedStars = 5;
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
  }

  void _submitRating() {
    final double updated = ((_currentRating + _selectedStars) / 2);
    setState(() => _currentRating = updated);
    widget.onRatingUpdated(updated);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rating submitted: ${updated.toStringAsFixed(1)}'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLanguageController lang = AppLanguageController.instance;
    final Color primary = Theme.of(context).colorScheme.primary;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.tr('provider_profile')),
        actions: const [
          AppActions(),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          // Profile Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, primary.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [BoxShadow(color: primary.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))],
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(widget.imageUrl),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.verified_rounded, color: Colors.blue, size: 24),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  '${lang.trService(widget.service)} • ${widget.city}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _statBadge(Icons.star_rounded, '${_currentRating.toStringAsFixed(1)} Rating'),
                    const SizedBox(width: 12),
                    _statBadge(Icons.work_history_rounded, '120+ Jobs'),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Bio Section
          _sectionTitle('About Specialist'),
          const SizedBox(height: 10),
          Text(
            'Professional ${widget.service.toLowerCase()} with over 5 years of experience in ${widget.city}. Specializing in high-quality repairs and customer satisfaction.',
            style: TextStyle(color: Colors.grey.shade600, height: 1.5),
          ),
          
          const SizedBox(height: 30),
          
          // Skills / Badges
          _sectionTitle('Certifications'),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _badge(icon: Icons.verified_outlined, text: 'Verified Identity', color: Colors.green),
              _badge(icon: Icons.security_rounded, text: 'Insured Service', color: Colors.blue),
              _badge(icon: Icons.timer_rounded, text: 'Quick Response', color: Colors.orange),
            ],
          ),
          
          const SizedBox(height: 40),
          
          // Rating Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                const Text(
                  'Rate your experience',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final star = i + 1;
                    return IconButton(
                      onPressed: () => setState(() => _selectedStars = star),
                      icon: Icon(
                        star <= _selectedStars ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: Colors.amber,
                        size: 36,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                Text(
                  'Tap a star to rate ${widget.name.split(' ').first}',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitRating,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 0,
                    ),
                    child: const Text('Submit Feedback', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _statBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.5),
    );
  }

  Widget _badge({required IconData icon, required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}
