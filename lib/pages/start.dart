import 'dart:async';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/models/service.dart';
import 'package:day35/pages/after_sales.dart';
import 'package:day35/pages/chat_list.dart';
import 'package:day35/pages/select_service.dart';
import 'package:day35/theme/app_theme.dart';
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
    // Randomly select from service list every 2 seconds
    Timer.periodic(Duration(seconds: 2), (timer) { 
      setState(() {
        selectedService = Random().nextInt(services.length);
      });
    });

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final AppLanguageController lang = AppLanguageController.instance;
    final AppThemeController theme = AppThemeController.instance;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: theme.toggle,
            icon: Icon(theme.isDarkMode ? Icons.dark_mode : Icons.light_mode),
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
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AfterSalesPage(),
                ),
              );
            },
            icon: const Icon(Icons.verified_user_outlined),
          ),
          PopupMenuButton<AppLanguage>(
            onSelected: lang.changeLanguage,
            icon: const Icon(Icons.language),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: AppLanguage.english,
                child: Text(lang.tr('english')),
              ),
              PopupMenuItem(
                value: AppLanguage.french,
                child: Text(lang.tr('french')),
              ),
              PopupMenuItem(
                value: AppLanguage.arabic,
                child: Text(lang.tr('arabic')),
              ),
            ],
          ),
        ],
      ),
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
}
