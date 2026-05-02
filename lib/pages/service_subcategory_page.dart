import 'package:animate_do/animate_do.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/pages/provider_selection.dart';
import 'package:day35/widgets/theme_toggle_action.dart';
import 'package:flutter/material.dart';

class ServiceSubCategoryPage extends StatelessWidget {
  final String serviceName;
  final String serviceImage;

  ServiceSubCategoryPage({
    super.key,
    required this.serviceName,
    required this.serviceImage,
  });

  final Map<String, List<Map<String, String>>> _subCategories = {
    'Cleaning': [
      {'name': 'House Cleaning', 'icon': 'https://img.icons8.com/color/2x/home.png'},
      {'name': 'Car Cleaning', 'icon': 'https://img.icons8.com/color/2x/car.png'},
      {'name': 'Office Cleaning', 'icon': 'https://img.icons8.com/color/2x/office.png'},
      {'name': 'Deep Cleaning', 'icon': 'https://img.icons8.com/color/2x/cleaning-service.png'},
    ],
    'Plumber': [
      {'name': 'Leak Repair', 'icon': 'https://img.icons8.com/color/2x/water-pipe.png'},
      {'name': 'Pipe Install', 'icon': 'https://img.icons8.com/color/2x/plumbing.png'},
      {'name': 'Sink/Drain', 'icon': 'https://img.icons8.com/color/2x/sink.png'},
      {'name': 'Water Heater', 'icon': 'https://img.icons8.com/color/2x/water-heater.png'},
    ],
    'Electrician': [
      {'name': 'Wiring', 'icon': 'https://img.icons8.com/color/2x/electricity.png'},
      {'name': 'Socket/Switch', 'icon': 'https://img.icons8.com/color/2x/wall-mount-camera.png'},
      {'name': 'Lighting', 'icon': 'https://img.icons8.com/color/2x/light-on.png'},
      {'name': 'Troubleshooting', 'icon': 'https://img.icons8.com/color/2x/electrical-sensor.png'},
    ],
    'Painter': [
      {'name': 'Room Painting', 'icon': 'https://img.icons8.com/color/2x/paint-roller.png'},
      {'name': 'Full House', 'icon': 'https://img.icons8.com/color/2x/exterior.png'},
      {'name': 'Wall Cracks', 'icon': 'https://img.icons8.com/color/2x/wall.png'},
      {'name': 'Exterior', 'icon': 'https://img.icons8.com/color/2x/house-with-a-garden.png'},
    ],
    'Carpenter': [
      {'name': 'Furniture Repair', 'icon': 'https://img.icons8.com/color/2x/chair.png'},
      {'name': 'Door/Window', 'icon': 'https://img.icons8.com/color/2x/door.png'},
      {'name': 'Cabinet Making', 'icon': 'https://img.icons8.com/color/2x/cupboard.png'},
      {'name': 'Flooring', 'icon': 'https://img.icons8.com/color/2x/parquet.png'},
    ],
    'Gardener': [
      {'name': 'Lawn Mowing', 'icon': 'https://img.icons8.com/color/2x/lawn-mower.png'},
      {'name': 'Tree Trimming', 'icon': 'https://img.icons8.com/color/2x/tree.png'},
      {'name': 'Garden Design', 'icon': 'https://img.icons8.com/color/2x/potted-plant.png'},
      {'name': 'Watering', 'icon': 'https://img.icons8.com/color/2x/water.png'},
    ],
    'Driver': [
      {'name': 'City Trip', 'icon': 'https://img.icons8.com/color/2x/city.png'},
      {'name': 'Airport Transfer', 'icon': 'https://img.icons8.com/color/2x/airport.png'},
      {'name': 'Personal Driver', 'icon': 'https://img.icons8.com/color/2x/driver.png'},
      {'name': 'Delivery', 'icon': 'https://img.icons8.com/color/2x/delivery.png'},
    ],
    'Babysitting': [
      {'name': 'Hourly Care', 'icon': 'https://img.icons8.com/color/2x/clock.png'},
      {'name': 'Full Day', 'icon': 'https://img.icons8.com/color/2x/sun.png'},
      {'name': 'Night Stay', 'icon': 'https://img.icons8.com/color/2x/moon.png'},
      {'name': 'Special Needs', 'icon': 'https://img.icons8.com/color/2x/heart-with-pulse.png'},
    ],
  };

  List<Map<String, String>> get _subs => 
      _subCategories[serviceName] ?? 
      [
        {'name': 'General Repair', 'icon': 'https://img.icons8.com/color/2x/maintenance.png'},
        {'name': 'Installation', 'icon': 'https://img.icons8.com/color/2x/settings.png'},
        {'name': 'Maintenance', 'icon': 'https://img.icons8.com/color/2x/support.png'},
        {'name': 'Inspection', 'icon': 'https://img.icons8.com/color/2x/search.png'},
      ];

  @override
  Widget build(BuildContext context) {
    final AppLanguageController lang = AppLanguageController.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.trService(serviceName)),
        actions: const [ThemeToggleAction()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            FadeInDown(
              child: Hero(
                tag: serviceName,
                child: Image.network(serviceImage, height: 100),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Select a specific service',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: _subs.length,
                itemBuilder: (context, index) {
                  final sub = _subs[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: 100 * index),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProviderSelectionPage(
                              serviceName: '${serviceName} - ${sub['name']}',
                              serviceImage: serviceImage,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(sub['icon']!, height: 50),
                            const SizedBox(height: 12),
                            Text(
                              sub['name']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
