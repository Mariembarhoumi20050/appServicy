import 'package:animate_do/animate_do.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/models/booking.dart';
import 'package:day35/models/chat_contact.dart';
import 'package:day35/models/service.dart';
import 'package:day35/models/service_provider.dart';
import 'package:day35/pages/after_sales.dart';
import 'package:day35/pages/chat_detail.dart';
import 'package:day35/pages/chat_list.dart';
import 'package:day35/pages/date_time.dart';
import 'package:day35/pages/my_bookings_page.dart';
import 'package:day35/pages/offerer_profile.dart';
import 'package:day35/pages/user_profile.dart';
import 'package:day35/theme/app_theme.dart';
import 'package:day35/widgets/theme_toggle_action.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? _userPosition;
  bool _isLocating = false;

  List<Service> services = [
    Service('Cleaning', 'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-cleaning-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png'),
    Service('Plumber', 'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-plumber-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png'),
    Service('Electrician', 'https://img.icons8.com/external-wanicon-flat-wanicon/2x/external-multimeter-car-service-wanicon-flat-wanicon.png'),
    Service('Painter', 'https://img.icons8.com/external-itim2101-flat-itim2101/2x/external-painter-male-occupation-avatar-itim2101-flat-itim2101.png'),
    Service('Carpenter', 'https://img.icons8.com/fluency/2x/drill.png'),
    Service('Gardener', 'https://img.icons8.com/external-itim2101-flat-itim2101/2x/external-gardener-male-occupation-avatar-itim2101-flat-itim2101.png'),
    Service('AC Repair', 'https://img.icons8.com/color/2x/air-conditioner.png'),
    Service('Pest Control', 'https://img.icons8.com/color/2x/bug.png'),
    Service('Appliance Repair', 'https://img.icons8.com/color/2x/maintenance.png'),
    Service('Babysitting', 'https://img.icons8.com/color/2x/nanny.png'),
  ];

  List<Map<String, dynamic>> workers = [
    {
      'name': 'Alfredo Schafer',
      'service': 'Plumber',
      'city': 'Tunis',
      'image':
          'https://images.unsplash.com/photo-1506803682981-6e718a9dd3ee?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=c3a31eeb7efb4d533647e3cad1de9257',
      'rating': 4.8,
      'basePrice': 70,
      'lat': 36.8065,
      'lng': 10.1815,
    },
    {
      'name': 'Michelle Baldwin',
      'service': 'Cleaning',
      'city': 'Sfax',
      'image': 'https://uifaces.co/our-content/donated/oLkb60i_.jpg',
      'rating': 4.6,
      'basePrice': 55,
      'lat': 34.7406,
      'lng': 10.7603,
    },
    {
      'name': 'Brenon Kalu',
      'service': 'Driver',
      'city': 'Sousse',
      'image': 'https://uifaces.co/our-content/donated/VUMBKh1U.jpg',
      'rating': 4.4,
      'basePrice': 65,
      'lat': 35.8256,
      'lng': 10.6084,
    },
    {
      'name': 'Ahmed Karray',
      'service': 'Electrician',
      'city': 'Tunis',
      'image': 'https://i.pravatar.cc/150?img=55',
      'rating': 4.9,
      'basePrice': 72,
      'lat': 36.8189,
      'lng': 10.1658,
    },
    {
      'name': 'Meriem Gharbi',
      'service': 'Cleaning',
      'city': 'Ariana',
      'image': 'https://i.pravatar.cc/150?img=41',
      'rating': 4.8,
      'basePrice': 58,
      'lat': 36.8665,
      'lng': 10.1647,
    },
    {
      'name': 'Hichem Mzoughi',
      'service': 'AC Repair',
      'city': 'Tunis',
      'image': 'https://i.pravatar.cc/150?img=61',
      'rating': 4.7,
      'basePrice': 75,
      'lat': 36.8065,
      'lng': 10.1815,
    },
    {
      'name': 'Olfa Khlifi',
      'service': 'Painter',
      'city': 'Tunis',
      'image': 'https://i.pravatar.cc/150?img=28',
      'rating': 4.6,
      'basePrice': 78,
      'lat': 36.8065,
      'lng': 10.1815,
    },
    {
      'name': 'Sami Ayari',
      'service': 'Electrician',
      'city': 'Monastir',
      'image': 'https://i.pravatar.cc/150?img=22',
      'rating': 4.6,
      'basePrice': 64,
      'lat': 35.7779,
      'lng': 10.8262,
    },
    {
      'name': 'Wael Jebali',
      'service': 'Plumber',
      'city': 'Nabeul',
      'image': 'https://i.pravatar.cc/150?img=64',
      'rating': 4.5,
      'basePrice': 62,
      'lat': 36.4510,
      'lng': 10.7357,
    },
    {
      'name': 'Yosra Dridi',
      'service': 'AC Repair',
      'city': 'Gabes',
      'image': 'https://i.pravatar.cc/150?img=26',
      'rating': 4.5,
      'basePrice': 73,
      'lat': 33.8815,
      'lng': 10.0982,
    },
    {
      'name': 'Riadh Bouazizi',
      'service': 'Painter',
      'city': 'Bizerte',
      'image': 'https://i.pravatar.cc/150?img=57',
      'rating': 4.7,
      'basePrice': 85,
      'lat': 37.2744,
      'lng': 9.8739,
    },
    {
      'name': 'Ines Chatti',
      'service': 'Cleaning',
      'city': 'Sousse',
      'image': 'https://i.pravatar.cc/150?img=20',
      'rating': 4.6,
      'basePrice': 52,
      'lat': 35.8256,
      'lng': 10.6084,
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
      if (!serviceEnabled) return;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
      final Position position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() => _userPosition = position);
    } catch (_) {
      // Keep default order if location can't be resolved.
    } finally {
      if (mounted) {
        setState(() => _isLocating = false);
      }
    }
  }

  double _workerDistanceKm(Map<String, dynamic> worker) {
    if (_userPosition == null) return 0;
    final double meters = Geolocator.distanceBetween(
      _userPosition!.latitude,
      _userPosition!.longitude,
      worker['lat'] as double,
      worker['lng'] as double,
    );
    return meters / 1000;
  }

  List<Map<String, dynamic>> get _sortedWorkers {
    final List<Map<String, dynamic>> sorted =
        List<Map<String, dynamic>>.from(workers);
    if (_userPosition == null) {
      return sorted;
    }
    sorted.sort((Map<String, dynamic> a, Map<String, dynamic> b) {
      return _workerDistanceKm(a).compareTo(_workerDistanceKm(b));
    });
    return sorted;
  }
  
  @override
  Widget build(BuildContext context) {
    final AppLanguageController lang = AppLanguageController.instance;
    final Color primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.tr('app_name')),
        actions: [
          const ThemeToggleAction(),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChatListPage()),
              );
            },
            icon: Icon(Icons.chat_bubble_outline, color: Theme.of(context).iconTheme.color, size: 28,),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AfterSalesPage()),
              );
            },
            icon: Icon(Icons.verified_user_outlined, color: Theme.of(context).iconTheme.color, size: 28),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyBookingsPage()),
              );
            },
            icon: Icon(Icons.timeline_rounded, color: Theme.of(context).iconTheme.color, size: 28),
          ),
        ],
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserProfilePage()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://uifaces.co/our-content/donated/NY9hnAbp.jpg'),
            ),
          )
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                CompetitionTokens.pagePadding,
                10,
                CompetitionTokens.pagePadding,
                8,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: CompetitionTokens.heroGradient(primary),
                  borderRadius: BorderRadius.circular(CompetitionTokens.radiusLg),
                  boxShadow: CompetitionTokens.softShadow(primary),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Book trusted help in under 60 seconds',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Speed + Safety + Smart UX',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: CompetitionTokens.pagePadding),
              child: _buildTrustCards(),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: CompetitionTokens.pagePadding),
              child: _buildOneTapRebook(),
            ),
            const SizedBox(height: 12),
            FadeInUp(child: Padding(
              padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  TextButton(
                    onPressed: () {}, 
                    child: Text('View all',)
                  )
                ],
              ),
            )),
            FadeInUp(child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: EdgeInsets.all(20.0),
                height: 180,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                      offset: Offset(0, 4),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.network('https://images.pexels.com/photos/355164/pexels-photo-355164.jpeg?crop=faces&fit=crop&h=200&w=200&auto=compress&cs=tinysrgb', width: 70,)
                        ),
                        SizedBox(width: 15,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Isabel Kirkland", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            SizedBox(height: 5,),
                            Text("Cleaner", style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7), fontSize: 18),),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(15.0)
                      ),
                      child: Center(child: Text('View Profile', style: TextStyle(color: Colors.white, fontSize: 18),)),
                    )
                  ],
                ),
              ),
            )),
            SizedBox(height: 20,),
            FadeInUp(child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  TextButton(
                    onPressed: () {}, 
                    child: Text('View all',)
                  )
                ],
              ),
            )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: 300,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                physics: BouncingScrollPhysics(),
                itemCount: services.length,
                itemBuilder: (BuildContext context, int index) {
                  return FadeInUp(
                    delay: Duration(milliseconds: 500 * index),
                    child: serviceContainer(services[index].imageURL, services[index].name, index));
                }
              ),
            ),
            SizedBox(height: 20,),
            FadeInUp(child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Services near you', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  TextButton(
                    onPressed: () {}, 
                    child: Text('View all',)
                  )
                ],
              ),
            )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _sortedWorkers.length,
                itemBuilder: (BuildContext context, int index) {
                  return FadeInUp(
                    delay: Duration(milliseconds: 500 * index),
                    child: workerContainer(_sortedWorkers[index], index),
                  );
                }
              ),
            ),
            if (_isLocating || _userPosition != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 16, color: primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _isLocating
                            ? 'Detecting your location...'
                            : 'Workers are sorted by distance from your location.',
                        style: TextStyle(
                          fontSize: 12,
                          color: primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 150,),
          ]
        )
      )
    );
  }

  serviceContainer(String image, String name, int index) {
    final AppLanguageController lang = AppLanguageController.instance;
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(right: 20),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withValues(alpha: 0.8),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(image, height: 45),
            SizedBox(height: 20,),
            Text(lang.trService(name), style: TextStyle(fontSize: 15),)
          ]
        ),
      ),
    );
  }

  Widget workerContainer(Map<String, dynamic> worker, int index) {
    final AppLanguageController lang = AppLanguageController.instance;
    final String name = worker['name'] as String;
    final String service = worker['service'] as String;
    final String city = worker['city'] as String;
    final String image = worker['image'] as String;
    final double rating = worker['rating'] as double;
    final int basePrice = worker['basePrice'] as int;
    final String cityOrDistance = _userPosition == null
        ? city
        : '${_workerDistanceKm(worker).toStringAsFixed(1)} km away';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 26, backgroundImage: NetworkImage(image)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('${lang.trService(service)} - $cityOrDistance'),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (int starIndex) {
                        return Icon(
                          starIndex < rating.round() ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Text('$basePrice TND'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatDetailPage(
                          contact: ChatContact(
                            name: name,
                            service: service,
                            city: city,
                            imageUrl: image,
                            quotedPriceTnd: basePrice + 10,
                            minNegotiablePriceTnd: (basePrice * 0.85).round(),
                            issueDescription: 'Need ${service.toLowerCase()} in $city.',
                            starterMessages: <String>[
                              'Salem $name, can we discuss details before booking?'
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.call_outlined),
                  label: const Text('Contact'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DateAndTime(
                          serviceName: service,
                          providerName: name,
                          providerCity: city,
                          providerImageUrl: image,
                          basePriceTnd: basePrice,
                          distanceKm: _userPosition == null
                              ? null
                              : _workerDistanceKm(worker),
                          availabilitySlots: const <String>[
                            'Today 17:30',
                            'Tomorrow 09:00',
                            'Tomorrow 14:30',
                          ],
                          extras: const <ServiceExtra>[
                            ServiceExtra(
                              name: 'Fast response',
                              imageUrl: 'https://img.icons8.com/color/2x/clock.png',
                              priceTnd: 10,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.calendar_month),
                  label: const Text('Book'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OffererProfilePage(
                      name: name,
                      service: service,
                      city: city,
                      imageUrl: image,
                      rating: rating,
                      onRatingUpdated: (double updatedRating) {
                        setState(() {
                          final int sourceIndex = workers.indexWhere(
                            (Map<String, dynamic> item) =>
                                item['name'] == name,
                          );
                          if (sourceIndex >= 0) {
                            workers[sourceIndex]['rating'] = updatedRating;
                          }
                        });
                      },
                    ),
                  ),
                );
              },
              child: const Text('Profile / Rate'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustCards() {
    final List<Map<String, String>> cards = <Map<String, String>>[
      <String, String>{'title': 'Verified ID', 'value': '100%'},
      <String, String>{'title': 'Avg. rating', 'value': '4.8/5'},
      <String, String>{'title': 'Jobs done', 'value': '2.4k+'},
      <String, String>{'title': 'Response', 'value': '< 3 min'},
    ];
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (BuildContext context, int index) {
          final item = cards[index];
          return Container(
            width: 118,
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
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
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

  Widget _buildOneTapRebook() {
    final List<Booking> bookings = BookingStore.instance.all;
    if (bookings.isEmpty) {
      return const SizedBox.shrink();
    }
    final Booking latest = bookings.last;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(CompetitionTokens.radiusMd),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: CompetitionTokens.softShadow(Theme.of(context).colorScheme.primary),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(latest.providerImageUrl)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1-tap rebook: ${latest.providerName}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  latest.serviceName,
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DateAndTime(
                    serviceName: latest.serviceName,
                    providerName: latest.providerName,
                    providerCity: 'Nearby',
                    providerImageUrl: latest.providerImageUrl,
                    basePriceTnd: latest.price,
                    availabilitySlots: const <String>[
                      'Today 18:00',
                      'Tomorrow 09:30',
                    ],
                    extras: const <ServiceExtra>[],
                  ),
                ),
              );
            },
            child: const Text('Rebook'),
          ),
        ],
      ),
    );
  }
}
