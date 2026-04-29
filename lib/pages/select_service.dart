import 'package:animate_do/animate_do.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/models/service.dart';
import 'package:day35/pages/chat_list.dart';
import 'package:day35/pages/provider_selection.dart';
import 'package:day35/features/voice/voice_screen.dart';
import 'package:day35/widgets/theme_toggle_action.dart';
import 'package:flutter/material.dart';

class SelectService extends StatefulWidget {
  const SelectService({Key? key}) : super(key: key);
  @override
  _SelectServiceState createState() => _SelectServiceState();
}

class _SelectServiceState extends State<SelectService> {
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
    Service('Cook', 'https://img.icons8.com/external-wanicon-flat-wanicon/2x/external-cooking-daily-routine-wanicon-flat-wanicon.png'),
    Service('AC Repair', 'https://img.icons8.com/color/2x/air-conditioner.png'),
    Service('Pest Control', 'https://img.icons8.com/color/2x/bug.png'),
    Service('Appliance Repair', 'https://img.icons8.com/color/2x/maintenance.png'),
    Service('Babysitting', 'https://img.icons8.com/color/2x/nanny.png'),
  ];

  int selectedService = -1;

  @override
  Widget build(BuildContext context) {
    final AppLanguageController lang = AppLanguageController.instance;
    final Color primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        actions: [
          const ThemeToggleAction(),
          IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatListPage())),
            icon: const Icon(Icons.chat_bubble_outline),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'voice',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VoiceScreen(
                  services: services.map((s) => s.name).toList(),
                ),
              ),
            ),
            backgroundColor: primary,
            child: const Icon(Icons.mic),
          ),
          if (selectedService >= 0) ...[
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'next',
              onPressed: () {
                final Service picked = services[selectedService];
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ProviderSelectionPage(
                    serviceName: picked.name,
                    serviceImage: picked.imageURL,
                  ),
                ));
              },
              backgroundColor: primary,
              child: const Icon(Icons.arrow_forward_ios, size: 20),
            ),
          ],
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverToBoxAdapter(
            child: FadeInUp(
              child: Padding(
                padding: const EdgeInsets.only(top: 42, right: 20, left: 20),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        primary.withValues(alpha: 0.18),
                        primary.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Text(
                    lang.tr('which_service'),
                    style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: services.length,
                  itemBuilder: (context, index) => FadeInUp(
                    delay: Duration(milliseconds: 500 * index),
                    child: serviceContainer(
                        services[index].imageURL, services[index].name, index),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  serviceContainer(String image, String name, int index) {
    final AppLanguageController lang = AppLanguageController.instance;
    final Color primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: () => setState(() =>
          selectedService = selectedService == index ? -1 : index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selectedService == index
              ? primary.withValues(alpha: 0.14)
              : Theme.of(context).cardColor.withValues(alpha: 0.8),
          border: Border.all(
            color: selectedService == index ? primary : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(image, height: 80),
            const SizedBox(height: 20),
            Text(lang.trService(name), style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}