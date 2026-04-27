import 'package:day35/localization/app_language.dart';
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
      SnackBar(content: Text('Rating submitted: ${updated.toStringAsFixed(1)}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLanguageController lang = AppLanguageController.instance;
    final Color primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CircleAvatar(
            radius: 46,
            backgroundImage: NetworkImage(widget.imageUrl),
          ),
          const SizedBox(height: 12),
          Text(
            widget.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '${lang.trService(widget.service)} - ${widget.city}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Current Rating: ${_currentRating.toStringAsFixed(1)}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Rate this service offerer:',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (int i) {
              final int star = i + 1;
              return IconButton(
                onPressed: () => setState(() => _selectedStars = star),
                icon: Icon(
                  star <= _selectedStars ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 30,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitRating,
            child: const Text('Submit Rating'),
          ),
        ],
      ),
    );
  }
}
