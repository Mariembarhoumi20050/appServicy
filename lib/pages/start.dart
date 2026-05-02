import 'dart:async';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/models/booking.dart';
import 'package:day35/models/service.dart';
import 'package:day35/models/service_provider.dart';
import 'package:day35/pages/chat_list.dart';
import 'package:day35/pages/date_time.dart';
import 'package:day35/pages/select_service.dart';
import 'package:day35/pages/service_subcategory_page.dart';
import 'package:day35/pages/notifications_page.dart';
import 'package:day35/pages/my_bookings_page.dart';
import 'package:day35/pages/user_profile.dart';
import 'package:day35/pages/onboarding_page.dart';
import 'package:day35/services/storage_service.dart';
import 'package:day35/widgets/app_actions.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({ Key? key }) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  List<Service> services = [
    Service('Cleaning', 'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-cleaning-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png'),
    Service('Plumber', 'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-plumber-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png'),
    Service('Electrician', 'https://img.icons8.com/external-wanicon-flat-wanicon/2x/external-multimeter-car-service-wanicon-flat-wanicon.png'),
    Service('Painter', 'https://img.icons8.com/external-itim2101-flat-itim2101/2x/external-painter-male-occupation-avatar-itim2101-flat-itim2101.png'),
    Service('Carpenter', 'https://img.icons8.com/fluency/2x/drill.png'),
    Service('Gardener', 'https://img.icons8.com/external-itim2101-flat-itim2101/2x/external-gardener-male-occupation-avatar-itim2101-flat-itim2101.png'),
    Service('Tailor', 'https://img.icons8.com/fluency/2x/sewing-machine.png'),
    Service('Maid', 'https://img.icons8.com/color/2x/housekeeper-female.png'),
    Service('Driver', 'https://img.icons8.com/external-sbts2018-lineal-color-sbts2018/2x/external-driver-women-profession-sbts2018-lineal-color-sbts2018.png'),
    Service('AC Repair', 'https://img.icons8.com/color/2x/air-conditioner.png'),
    Service('Pest Control', 'https://img.icons8.com/color/2x/bug.png'),
    Service('Appliance Repair', 'https://img.icons8.com/color/2x/maintenance.png'),
    Service('Babysitting', 'https://img.icons8.com/color/2x/nanny.png'),
  ];

  int selectedService = 4;

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 2), (timer) { 
      if (!mounted) return;
      setState(() {
        selectedService = Random().nextInt(services.length);
      });
    });

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final AppLanguageController lang = AppLanguageController.instance;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Serviny'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsPage()),
              );
            },
            icon: const Icon(Icons.notifications_none),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatListPage(),
                ),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline),
          ),
          const AppActions(),
        ],
      ),
      drawer: _buildDrawer(context, colorScheme),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.18),
                    Theme.of(context).colorScheme.secondary.withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  FadeInUp(
                    child: Image.asset(
                      'logo.png',
                      height: 80,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    lang.tr('home_hero'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lang.tr('home_desc'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.78),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _buildLiveBookingCard(lang),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              height: 260,
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: services.length,
                itemBuilder: (BuildContext context, int index) {
                  return FadeInUp(
                    delay: Duration(milliseconds: index * 100),
                    child: serviceContainer(
                        services[index].imageURL, services[index].name, index),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectService(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(56)),
          child: Text(lang.tr('get_started'), style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  serviceContainer(String image, String name, int index) {
    final Color primary = Theme.of(context).colorScheme.primary;
    final AppLanguageController lang = AppLanguageController.instance;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceSubCategoryPage(
              serviceName: name,
              serviceImage: image,
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: selectedService == index
              ? primary.withValues(alpha: 0.12)
              : Theme.of(context).cardColor.withValues(alpha: 0.75),
          border: Border.all(
            color: selectedService == index ? primary : Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(image, height: 30),
            SizedBox(height: 10,),
            Text(lang.trService(name), style: TextStyle(fontSize: 14),)
          ]
        ),
      ),
    );
  }

  Booking? get _latestBooking {
    final bookings = BookingStore.instance.all;
    if (bookings.isEmpty) return null;
    return bookings.last;
  }

  Booking? get _latestPendingBooking {
    final bookings = BookingStore.instance.all;
    for (int i = bookings.length - 1; i >= 0; i--) {
      if (bookings[i].status == BookingStatus.pending) return bookings[i];
    }
    return null;
  }

  Widget _buildLiveBookingCard(AppLanguageController lang) {
    final Booking? pending = _latestPendingBooking;
    final Booking? last = _latestBooking;
    final Color primary = Theme.of(context).colorScheme.primary;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: primary.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping_outlined, color: primary),
              const SizedBox(width: 8),
              Text(lang.tr('live_booking_status'), style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          if (pending != null) ...[
            Text(
              '${pending.serviceName} • ${pending.providerName}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              '${lang.tr('status_pending')} • ${pending.date} ${pending.time}',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            if ((pending.arrivalCode ?? '').isNotEmpty)
              Text(
                '${lang.tr('arrival_code')}: ${pending.arrivalCode}',
                style: TextStyle(color: primary, fontWeight: FontWeight.w700),
              ),
          ] else
            Text(lang.tr('no_active_booking'), style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyBookingsPage()),
                    );
                  },
                  child: Text(lang.tr('view_my_bookings')),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: last == null ? null : () => _quickRebook(last),
                  child: Text(lang.tr('quick_rebook')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _quickRebook(Booking last) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DateAndTime(
          serviceName: last.serviceName,
          providerName: last.providerName,
          providerCity: 'Nearby',
          providerImageUrl: last.providerImageUrl,
          basePriceTnd: last.price,
          availabilitySlots: const <String>['Today 17:30', 'Tomorrow 09:00'],
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
  }

  Widget _buildDrawer(BuildContext context, ColorScheme colorScheme) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: colorScheme.primary),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage('https://uifaces.co/our-content/donated/NY9hnAbp.jpg'),
            ),
            accountName: const Text('Bacem Ben Salah', style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: const Text('bacem@email.com'),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('My Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const UserProfilePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('My Bookings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const MyBookingsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.grid_view_rounded),
            title: const Text('Available Services'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SelectService()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Placeholder for settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Support'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await StorageService.instance.logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const OnboardingPage()),
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
