import 'package:animate_do/animate_do.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/models/chat_contact.dart';
import 'package:day35/models/service.dart';
import 'package:day35/models/service_provider.dart';
import 'package:day35/pages/after_sales.dart';
import 'package:day35/pages/chat_detail.dart';
import 'package:day35/pages/chat_list.dart';
import 'package:day35/pages/date_time.dart';
import 'package:day35/pages/offerer_profile.dart';
import 'package:day35/pages/user_profile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    },
    {
      'name': 'Michelle Baldwin',
      'service': 'Cleaning',
      'city': 'Sfax',
      'image': 'https://uifaces.co/our-content/donated/oLkb60i_.jpg',
      'rating': 4.6,
      'basePrice': 55,
    },
    {
      'name': 'Brenon Kalu',
      'service': 'Driver',
      'city': 'Sousse',
      'image': 'https://uifaces.co/our-content/donated/VUMBKh1U.jpg',
      'rating': 4.4,
      'basePrice': 65,
    }
  ];
  
  @override
  Widget build(BuildContext context) {
    final AppLanguageController lang = AppLanguageController.instance;
    final Color primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.tr('app_name')),
        actions: [
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
                        color: Colors.black.withOpacity(0.08),
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
                            Text("Cleaner", style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7), fontSize: 18),),
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
                  Text('Top Rated', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
                itemCount: workers.length,
                itemBuilder: (BuildContext context, int index) {
                  return FadeInUp(
                    delay: Duration(milliseconds: 500 * index),
                    child: workerContainer(workers[index], index),
                  );
                }
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
          color: Theme.of(context).cardColor.withOpacity(0.8),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0),
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
                    Text('${lang.trService(service)} - $city'),
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
                          basePriceTnd: basePrice,
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
                          workers[index]['rating'] = updatedRating;
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
}