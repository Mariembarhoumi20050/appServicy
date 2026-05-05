import 'dart:async';

import 'package:day35/localization/app_language.dart';
import 'package:day35/models/booking.dart';
import 'package:day35/models/chat_contact.dart';
import 'package:day35/pages/chat_detail.dart';
import 'package:day35/pages/chat_list.dart';
import 'package:day35/pages/after_sales.dart';
import 'package:day35/pages/account_settings_page.dart';
import 'package:day35/pages/notifications_page.dart';
import 'package:day35/pages/edit_profile_page.dart';
import 'package:day35/pages/onboarding_page.dart';
import 'package:day35/pages/job_history_page.dart';
import 'package:day35/pages/payouts_page.dart';
import 'package:day35/pages/earnings_page.dart';
import 'package:day35/pages/reliability_page.dart';
import 'package:day35/pages/pending_jobs_page.dart';
import 'package:day35/services/storage_service.dart';
import 'package:day35/theme/app_theme.dart';
import 'package:day35/widgets/app_actions.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class OffererDashboard extends StatefulWidget {
  const OffererDashboard({super.key});

  @override
  State<OffererDashboard> createState() => _OffererDashboardState();
}

class _OffererDashboardState extends State<OffererDashboard> {
  bool _isOnline = true;
  double _searchRadius = 10.0; // km
  Position? _currentPosition;
  bool _isLocating = false;
  StreamSubscription<Position>? _positionSubscription;
  Timer? _opsTimelineTimer;
  int _opsTimelineStep = 1;
  static const List<String> _opsSteps = <String>[
    'Searching',
    'Accepted',
    'On the way',
    'Arrived',
    'Done',
  ];

  final String _providerName = 'Alex Johnson';
  final String _providerService = 'Professional Plumber';
  final String _providerImage = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=1974&auto=format&fit=crop';
  static const List<Map<String, dynamic>> _knownCities = <Map<String, dynamic>>[
    <String, dynamic>{'name': 'Tunis', 'lat': 36.8065, 'lon': 10.1815},
    <String, dynamic>{'name': 'Ariana', 'lat': 36.8665, 'lon': 10.1647},
    <String, dynamic>{'name': 'Sfax', 'lat': 34.7406, 'lon': 10.7603},
    <String, dynamic>{'name': 'Sousse', 'lat': 35.8256, 'lon': 10.6084},
    <String, dynamic>{'name': 'Monastir', 'lat': 35.7779, 'lon': 10.8262},
    <String, dynamic>{'name': 'Nabeul', 'lat': 36.4510, 'lon': 10.7357},
    <String, dynamic>{'name': 'Gabes', 'lat': 33.8815, 'lon': 10.0982},
    <String, dynamic>{'name': 'Bizerte', 'lat': 37.2744, 'lon': 9.8739},
  ];
  static const List<String> _bookingProgressLabels = <String>[
    'Searching',
    'Accepted',
    'On the way',
    'Arrived',
    'Done',
  ];

  // Simulated request locations
  final List<Map<String, dynamic>> _allNearbyRequests = [
    {
      'user': 'Sarah M.',
      'service': 'Leaking Tap',
      'time': '20 mins ago',
      'price': '45 TND',
      'lat': 36.8188,
      'lon': 10.1659,
      'category': 'Plumbing',
      'isUrgent': false,
    },
    {
      'user': 'James K.',
      'service': 'Pipe Install',
      'time': '1 hour ago',
      'price': '120 TND',
      'lat': 36.8500,
      'lon': 10.1800,
      'category': 'Plumbing',
      'isUrgent': false,
    },
    {
      'user': 'Mariem B.',
      'service': 'Emergency Repair',
      'time': '5 mins ago',
      'price': '150 TND',
      'lat': 36.8000,
      'lon': 10.2500,
      'category': 'Emergency',
      'isUrgent': true,
    },
    {
      'user': 'Ahmed L.',
      'service': 'Sink Fix',
      'time': '2 hours ago',
      'price': '60 TND',
      'lat': 36.7500,
      'lon': 10.1500,
      'category': 'Plumbing',
      'isUrgent': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _detectLocation();
  }

  Future<void> _detectLocation() async {
    setState(() => _isLocating = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enable location services on your phone.')),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are permanently denied. Please enable them in settings.')),
          );
        }
        return;
      }

      if (permission == LocationPermission.denied) return;

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      if (!mounted) return;
      setState(() => _currentPosition = position);
      
      _startRealtimeTrackingIfOnline();
    } catch (e) {
      debugPrint('Location error: $e');
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  void _startRealtimeTrackingIfOnline() {
    _positionSubscription?.cancel();
    _opsTimelineTimer?.cancel();
    if (!_isOnline) return;
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 8,
      ),
    ).listen((Position position) {
      if (mounted && _isOnline) {
        setState(() => _currentPosition = position);
      }
    });
    _opsTimelineTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted || !_isOnline) return;
      setState(() {
        _opsTimelineStep = (_opsTimelineStep + 1) % _opsSteps.length;
      });
    });
  }

  double _calculateDistance(double lat, double lon) {
    if (_currentPosition == null) return 0.0;
    final double meters = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      lat,
      lon,
    );
    return meters / 1000;
  }

  String _resolveCurrentCityName() {
    if (_currentPosition == null) {
      return AppLanguageController.instance.tr('center_detecting');
    }
    double minDistanceKm = double.infinity;
    String closestCity = 'Nearby';
    for (final Map<String, dynamic> city in _knownCities) {
      final double meters = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        city['lat'] as double,
        city['lon'] as double,
      );
      final double km = meters / 1000;
      if (km < minDistanceKm) {
        minDistanceKm = km;
        closestCity = city['name'] as String;
      }
    }
    return closestCity;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppLanguageController.instance,
      builder: (context, child) {
        final colorScheme = Theme.of(context).colorScheme;
        final lang = AppLanguageController.instance;

        List<Map<String, dynamic>> filteredRequests = _allNearbyRequests.map((req) {
          final dist = _calculateDistance(req['lat'], req['lon']);
          return {...req, 'distance': dist};
        }).where((req) {
          if (_currentPosition == null) return true;
          return (req['distance'] as double) <= _searchRadius;
        }).toList();

        if (_currentPosition != null) {
          filteredRequests.sort((a, b) => (a['distance'] as double).compareTo(b['distance'] as double));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(lang.tr('provider_dashboard')),
            actions: [
              IconButton(
                onPressed: _openClientChats,
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                tooltip: lang.tr('client_chats'),
              ),
              IconButton(
                onPressed: _detectLocation,
                icon: _isLocating
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.refresh_rounded),
                tooltip: lang.tr('refresh_location'),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage()));
                },
                icon: const Icon(Icons.notifications_none_rounded),
              ),
              const AppActions(),
            ],
          ),
          drawer: _buildDrawer(context, colorScheme),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: CompetitionTokens.pagePadding,
              vertical: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(colorScheme),
                const SizedBox(height: 16),
                _buildLiveOpsTimeline(colorScheme),
                const SizedBox(height: 18),
                _buildTrustKpiStrip(),
                const SizedBox(height: 22),
                _buildAvailabilityToggle(colorScheme),
                const SizedBox(height: 30),
                _buildStatsGrid(colorScheme),
                const SizedBox(height: 30),
                _buildSectionTitle('Accepted Offers'),
                const SizedBox(height: 10),
                _buildAcceptedOffersSection(),
                const SizedBox(height: 24),
                _buildSectionTitle(lang.tr('active_jobs_area')),
                const SizedBox(height: 10),
                _buildZoneFilter(colorScheme),
                const SizedBox(height: 15),
                _buildNearbyRequestsList(filteredRequests),
                const SizedBox(height: 30),
                _buildSectionTitle(lang.tr('performance_insights')),
                const SizedBox(height: 15),
                _buildEarningsChart(colorScheme),
                const SizedBox(height: 30),
                _buildQuickActions(colorScheme),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildZoneFilter(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLanguageController.instance.tr('visibility_radius'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Text('${_searchRadius.round()} km', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Slider(
            value: _searchRadius,
            min: 1,
            max: 50,
            activeColor: colorScheme.primary,
            inactiveColor: colorScheme.primary.withValues(alpha: 0.1),
            onChanged: (val) => setState(() => _searchRadius = val),
          ),
          Row(
            children: [
              Icon(Icons.gps_fixed_rounded, size: 14, color: _currentPosition != null ? Colors.blue : Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _currentPosition != null 
                    ? 'Center: ${_resolveCurrentCityName()}'
                    : AppLanguageController.instance.tr('center_detecting'),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyRequestsList(List<Map<String, dynamic>> requests) {
    if (requests.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(30),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 40, color: Colors.grey.shade400),
            const SizedBox(height: 10),
            Text(AppLanguageController.instance.tr('no_active_requests_nearby'), style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
            Text(AppLanguageController.instance.tr('try_increase_radius'), style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
          ],
        ),
      );
    }

    return Column(
      children: requests.map((req) => Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
          border: Border.all(color: Colors.grey.withValues(alpha: 0.05)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue.withValues(alpha: 0.1),
                  child: Text(req['user']![0], style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(req['user']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                            child: Text(req['category']!, style: const TextStyle(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.bold)),
                          ),
                          if (req['isUrgent'] == true) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                              child: const Text('URGENT', style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                      Text(req['service']!, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                    ],
                  ),
                ),
                Text(req['price']!, style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.green, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.navigation_rounded, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text('${(req['distance'] as double).toStringAsFixed(1)} ${AppLanguageController.instance.tr('km_away')}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    const SizedBox(width: 12),
                    Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(req['time']!, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _showOfferActions(req),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: Text(AppLanguageController.instance.tr('bid_accept'), style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildAcceptedOffersSection() {
    final List<Booking> accepted = BookingStore.instance.all
        .where((Booking booking) => booking.providerName == _providerName)
        .toList()
      ..sort((Booking a, Booking b) => b.id.compareTo(a.id));

    if (accepted.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: const Text(
          'No accepted offers yet. Accept one from nearby requests.',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      );
    }

    return Column(
      children: accepted.map((Booking booking) {
        final String progress =
            _bookingProgressLabels[booking.progressStep.clamp(0, 4)];
        final bool isDone = booking.status == BookingStatus.completed;
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
              CircleAvatar(
                backgroundColor: isDone ? Colors.green : Colors.blue,
                child: Icon(
                  isDone ? Icons.check : Icons.badge_outlined,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.clientName ?? 'Client',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text('${booking.serviceName} • ${booking.price} TND'),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: (isDone ? Colors.green : Colors.orange)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  progress,
                  style: TextStyle(
                    color: isDone ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProfileHeader(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: colorScheme.primary.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(_providerImage),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _providerName,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  _providerService,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 15),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text('4.9 (124 reviews)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _goToEditProfile,
            icon: const Icon(Icons.settings_suggest_rounded, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsChart(ColorScheme colorScheme) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final values = [0.4, 0.7, 0.5, 0.9, 0.6, 0.3, 0.2];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLanguageController.instance.tr('weekly_revenue'), style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                  const Text('1,250 TND', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.trending_up_rounded, color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      width: 20,
                      height: 100 * values[index],
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.5)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(days[index], style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _goToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(
          initialName: _providerName,
          initialService: _providerService,
          initialImageUrl: _providerImage,
        ),
      ),
    );
  }

  Widget _buildAvailabilityToggle(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: _isOnline ? Colors.green.withValues(alpha: 0.05) : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _isOnline ? Colors.green.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isOnline ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: (_isOnline ? Colors.green : Colors.grey).withValues(alpha: 0.4), blurRadius: 8)],
                ),
                child: const Icon(Icons.power_settings_new_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLanguageController.instance.tr(_isOnline ? 'active_receiving' : 'currently_inactive'),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    AppLanguageController.instance.tr(_isOnline ? 'ready_new_requests' : 'switch_on_jobs'),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
          Switch.adaptive(
            value: _isOnline,
            onChanged: (val) {
              setState(() => _isOnline = val);
              if (_isOnline) {
                _detectLocation();
              } else {
                _positionSubscription?.cancel();
              }
            },
            activeThumbColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(ColorScheme colorScheme) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.4,
      children: [
        _buildStatCard(AppLanguageController.instance.tr('jobs_done'), '48', Icons.task_alt_rounded, Colors.blue, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const JobHistoryPage()));
        }),
        _buildStatCard(AppLanguageController.instance.tr('pending'), '3', Icons.hourglass_empty_rounded, Colors.orange, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const PendingJobsPage()));
        }),
        _buildStatCard(AppLanguageController.instance.tr('reliability'), '98%', Icons.verified_user_rounded, Colors.green, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ReliabilityPage()));
        }),
        _buildStatCard(AppLanguageController.instance.tr('earnings'), '12k', Icons.account_balance_wallet_rounded, Colors.purple, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const EarningsPage()));
        }),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300, size: 18),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            Text(
              title,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5),
      ),
    );
  }

  Widget _buildQuickActions(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionItem(Icons.history_rounded, AppLanguageController.instance.tr('history'), () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const JobHistoryPage()));
          }),
          _buildActionItem(Icons.wallet_rounded, AppLanguageController.instance.tr('payouts'), () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const PayoutsPage()));
          }),
          _buildActionItem(Icons.chat_bubble_outline_rounded, AppLanguageController.instance.tr('chats'), _openClientChats),
          _buildActionItem(Icons.contact_support_rounded, AppLanguageController.instance.tr('support'), () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AfterSalesPage()));
          }),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label, [VoidCallback? onTap]) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
            ),
            child: Icon(icon, size: 22, color: Colors.blueGrey),
          ),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context, ColorScheme colorScheme) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(30))),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.primary,
              image: DecorationImage(
                image: const NetworkImage('https://images.unsplash.com/photo-1621905251918-48416bd8575a?q=80&w=2069&auto=format&fit=crop'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(colorScheme.primary.withValues(alpha: 0.8), BlendMode.srcOver),
              ),
            ),
            currentAccountPicture: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: CircleAvatar(backgroundImage: NetworkImage(_providerImage)),
            ),
            accountName: Text(_providerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail: const Text('alex.johnson@serviny.tn'),
          ),
          _buildDrawerItem(Icons.dashboard_rounded, AppLanguageController.instance.tr('dashboard'), () => Navigator.pop(context)),
          _buildDrawerItem(Icons.person_rounded, AppLanguageController.instance.tr('profile_cv'), () {
            Navigator.pop(context);
            _goToEditProfile();
          }),
          _buildDrawerItem(Icons.history_edu_rounded, AppLanguageController.instance.tr('job_history'), () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const JobHistoryPage()));
          }),
          _buildDrawerItem(Icons.chat_bubble_outline_rounded, AppLanguageController.instance.tr('client_chats'), () {
            Navigator.pop(context);
            _openClientChats();
          }),
          _buildDrawerItem(Icons.support_agent_rounded, AppLanguageController.instance.tr('technical_support'), () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AfterSalesPage()));
          }),
          const Divider(indent: 20, endIndent: 20),
          _buildDrawerItem(Icons.settings_rounded, AppLanguageController.instance.tr('account_settings'), () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountSettingsPage()));
          }),
          const Spacer(),
          _buildDrawerItem(Icons.logout_rounded, AppLanguageController.instance.tr('logout'), () async {
            await StorageService.instance.logout();
            if (!context.mounted) return;
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const OnboardingPage()), (route) => false);
          }, isDestructive: true),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : Colors.blueGrey),
      title: Text(title, style: TextStyle(color: isDestructive ? Colors.red : Colors.blueGrey, fontWeight: FontWeight.w600)),
      onTap: onTap,
    );
  }

  void _openClientChats() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChatListPage(showClientsOnly: true)),
    );
  }

  int _extractPriceTnd(String rawPrice) {
    final match = RegExp(r'(\d+)').firstMatch(rawPrice);
    return int.tryParse(match?.group(1) ?? '') ?? 50;
  }

  void _showOfferActions(Map<String, dynamic> req) {
    final lang = AppLanguageController.instance;
    final int offeredPrice = _extractPriceTnd(req['price'] as String);
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${req['user']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('${req['service']} • ${req['price']}'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.pop(context);
                          final booking = Booking(
                            id: 'PROV${DateTime.now().millisecondsSinceEpoch}',
                            providerName: _providerName,
                            clientName: req['user'] as String,
                            serviceName: req['service'] as String,
                            providerImageUrl: _providerImage,
                            date: 'Today',
                            time: 'ASAP',
                            price: offeredPrice,
                            status: BookingStatus.pending,
                            arrivalCode: (1000 + (DateTime.now().millisecondsSinceEpoch % 9000)).toString(),
                            progressStep: 1,
                          );
                          await BookingStore.instance.add(booking);
                          if (mounted) {
                            setState(() {});
                          }
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(content: Text(lang.tr('offer_accepted'))),
                          );
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: Text(lang.tr('accept_offer')),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            this.context,
                            MaterialPageRoute(
                              builder: (_) => ChatDetailPage(
                                contact: ChatContact(
                                  name: req['user'] as String,
                                  service: req['service'] as String,
                                  city: 'Nearby',
                                  imageUrl: 'https://i.pravatar.cc/150?img=9',
                                  quotedPriceTnd: offeredPrice,
                                  minNegotiablePriceTnd: (offeredPrice * 0.85).round(),
                                  issueDescription: req['service'] as String,
                                  isClient: true,
                                  isUrgent: req['isUrgent'] == true,
                                  starterMessages: <String>[
                                    'Hello, I requested ${req['service']}.',
                                    'My proposed budget is ${req['price']}.'
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.chat_bubble_outline_rounded),
                        label: Text(lang.tr('chat_with_client')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _opsTimelineTimer?.cancel();
    super.dispose();
  }

  Widget _buildLiveOpsTimeline(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(CompetitionTokens.radiusMd),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: CompetitionTokens.softShadow(colorScheme.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Live Booking Timeline',
            style: TextStyle(fontWeight: FontWeight.w800, color: colorScheme.primary),
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            child: Text(
              _opsSteps[_opsTimelineStep],
              key: ValueKey<String>(_opsSteps[_opsTimelineStep]),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(_opsSteps.length, (int index) {
              final bool reached = index <= _opsTimelineStep;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index == _opsSteps.length - 1 ? 0 : 6),
                  height: 5,
                  decoration: BoxDecoration(
                    color: reached ? colorScheme.primary : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustKpiStrip() {
    final List<Map<String, String>> kpis = <Map<String, String>>[
      <String, String>{'title': 'Verified profile', 'value': '100%'},
      <String, String>{'title': 'Avg response', 'value': '< 2 min'},
      <String, String>{'title': 'Safe completion', 'value': '95%'},
      <String, String>{'title': 'Rating', 'value': '4.9'},
    ];
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: kpis.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (BuildContext context, int index) {
          final item = kpis[index];
          return Container(
            width: 130,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(CompetitionTokens.radiusSm),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['value']!,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item['title']!,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
