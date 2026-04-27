import 'package:day35/models/chat_contact.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/models/service_provider.dart';
import 'package:day35/pages/chat_detail.dart';
import 'package:day35/pages/date_time.dart';
import 'package:flutter/material.dart';

class ProviderSelectionPage extends StatelessWidget {
  final String serviceName;
  final String serviceImage;

  const ProviderSelectionPage({
    super.key,
    required this.serviceName,
    required this.serviceImage,
  });

  static final Map<String, List<ServiceProvider>> _providersByService =
      <String, List<ServiceProvider>>{
    'Cleaning': const <ServiceProvider>[
      ServiceProvider(
        name: 'Yassine Ben Salem',
        city: 'Tunis',
        imageUrl: 'https://i.pravatar.cc/150?img=48',
        rating: 4.9,
        basePriceTnd: 55,
        starterMessages: <String>[
          'Salem Yassine, I need apartment cleaning.',
          'Can we negotiate if I book weekly?',
        ],
      ),
      ServiceProvider(
        name: 'Rym Triki',
        city: 'La Marsa',
        imageUrl: 'https://i.pravatar.cc/150?img=45',
        rating: 4.7,
        basePriceTnd: 60,
        starterMessages: <String>['Hello, do you bring your own products?'],
      ),
    ],
    'Plumber': const <ServiceProvider>[
      ServiceProvider(
        name: 'Ala Trabelsi',
        city: 'Sfax',
        imageUrl: 'https://i.pravatar.cc/150?img=12',
        rating: 4.8,
        basePriceTnd: 70,
        starterMessages: <String>['Salem, I have a leaking pipe in kitchen.'],
      ),
      ServiceProvider(
        name: 'Seif Chatti',
        city: 'Sousse',
        imageUrl: 'https://i.pravatar.cc/150?img=14',
        rating: 4.6,
        basePriceTnd: 65,
        starterMessages: <String>['Can you come this evening please?'],
      ),
    ],
  };

  static final List<ServiceProvider> _defaultProviders = const <ServiceProvider>[
    ServiceProvider(
      name: 'Mohamed Gharbi',
      city: 'Tunis',
      imageUrl: 'https://i.pravatar.cc/150?img=52',
      rating: 4.8,
      basePriceTnd: 50,
      starterMessages: <String>['Salem, can we discuss the price?'],
    ),
    ServiceProvider(
      name: 'Amira Jlassi',
      city: 'Nabeul',
      imageUrl: 'https://i.pravatar.cc/150?img=32',
      rating: 4.7,
      basePriceTnd: 55,
      starterMessages: <String>['Are you available tomorrow afternoon?'],
    ),
  ];

  static final Map<String, List<ServiceExtra>> _extrasByService =
      <String, List<ServiceExtra>>{
    'Cleaning': const <ServiceExtra>[
      ServiceExtra(
        name: 'Windows',
        imageUrl:
            'https://img.icons8.com/external-kiranshastry-lineal-color-kiranshastry/2x/external-window-interiors-kiranshastry-lineal-color-kiranshastry-1.png',
        priceTnd: 20,
      ),
      ServiceExtra(
        name: 'Fridge',
        imageUrl: 'https://img.icons8.com/cotton/2x/fridge.png',
        priceTnd: 15,
      ),
      ServiceExtra(
        name: 'Oven',
        imageUrl:
            'https://img.icons8.com/external-becris-lineal-color-becris/2x/external-oven-kitchen-cooking-becris-lineal-color-becris.png',
        priceTnd: 18,
      ),
    ],
    'Plumber': const <ServiceExtra>[
      ServiceExtra(
        name: 'Emergency visit',
        imageUrl: 'https://img.icons8.com/color/2x/error--v1.png',
        priceTnd: 25,
      ),
      ServiceExtra(
        name: 'Spare parts',
        imageUrl: 'https://img.icons8.com/color/2x/toolbox.png',
        priceTnd: 30,
      ),
    ],
    'Electrician': const <ServiceExtra>[
      ServiceExtra(
        name: 'Circuit check',
        imageUrl: 'https://img.icons8.com/color/2x/electrical.png',
        priceTnd: 20,
      ),
      ServiceExtra(
        name: 'New socket',
        imageUrl: 'https://img.icons8.com/color/2x/electrical-sensor.png',
        priceTnd: 15,
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final AppLanguageController lang = AppLanguageController.instance;
    final Color primary = Theme.of(context).colorScheme.primary;
    final List<ServiceProvider> providers =
        _providersByService[serviceName] ?? _defaultProviders;
    final List<ServiceExtra> extras =
        _extrasByService[serviceName] ??
        const <ServiceExtra>[
          ServiceExtra(
            name: 'Fast response',
            imageUrl: 'https://img.icons8.com/color/2x/clock.png',
            priceTnd: 10,
          ),
          ServiceExtra(
            name: 'Premium tools',
            imageUrl: 'https://img.icons8.com/color/2x/maintenance.png',
            priceTnd: 12,
          ),
        ];

    return Scaffold(
      appBar: AppBar(title: Text(lang.tr('choose_offerer'))),
      body: Column(
        children: [
          ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(serviceImage)),
            title: Text(lang.trService(serviceName)),
            subtitle: const Text('Select provider, chat and negotiate'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: providers.length,
              itemBuilder: (BuildContext context, int index) {
                final ServiceProvider provider = providers[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundImage:
                                  NetworkImage(provider.imageUrl),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    provider.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('${provider.city} - ${provider.rating}'),
                                ],
                              ),
                            ),
                            Text(
        '${provider.basePriceTnd} TND',
  style: TextStyle(  
    fontWeight: FontWeight.bold,
    color: primary,
                  ),
                ),
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
                                          name: provider.name,
                                          service: serviceName,
                                          city: provider.city,
                                          imageUrl: provider.imageUrl,
                                          starterMessages:
                                              provider.starterMessages,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.chat_bubble_outline),
                                label: Text(lang.tr('chat')),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DateAndTime(
                                        serviceName: serviceName,
                                        providerName: provider.name,
                                        basePriceTnd: provider.basePriceTnd,
                                        extras: extras,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.calendar_month),
                                label: Text(lang.tr('book')),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
