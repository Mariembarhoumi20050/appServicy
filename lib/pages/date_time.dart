import 'package:animate_do/animate_do.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/models/service_provider.dart';
import 'package:day35/pages/chat_list.dart';
import 'package:day35/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class DateAndTime extends StatefulWidget {
  final String serviceName;
  final String providerName;
  final int basePriceTnd;
  final List<ServiceExtra> extras;

  const DateAndTime({
    Key? key,
    required this.serviceName,
    required this.providerName,
    required this.basePriceTnd,
    required this.extras,
  }) : super(key: key);

  @override
  _DateAndTimeState createState() => _DateAndTimeState();
}

class _DateAndTimeState extends State<DateAndTime> {
  int _selectedDay = 2;
  int _selectedRepeat = 0;
  String _selectedHour = '13:30';
  List<int> _selectedExtraServices = [];

  ItemScrollController _scrollController = ItemScrollController();

  final List<dynamic> _days = [
    [1, 'Fri'],
    [2, 'Sat'],
    [3, 'Sun'],
    [4, 'Mon'],
    [5, 'Tue'],
    [6, 'Wed'],
    [7, 'Thu'],
    [8, 'Fri'],
    [9, 'Sat'],
    [10, 'Sun'],
    [11, 'Mon'],
    [12, 'Tue'],
    [13, 'Wed'],
    [14, 'Thu'],
    [15, 'Fri'],
    [16, 'Sat'],
    [17, 'Sun'],
    [18, 'Mon'],
    [19, 'Tue'],
    [20, 'Wed'],
    [21, 'Thu'],
    [22, 'Fri'],
    [23, 'Sat'],
    [24, 'Sun'],
    [25, 'Mon'],
    [26, 'Tue'],
    [27, 'Wed'],
    [28, 'Thu'],
    [29, 'Fri'],
    [30, 'Sat'],
    [31, 'Sun']
  ];

  final List<String> _hours = <String>[
    '01:00',
    '01:30',
    '02:00',
    '02:30',
    '03:00',
    '03:30',
    '04:00',
    '04:30',
    '05:00',
    '05:30',
    '06:00',
    '06:30',
    '07:00',
    '07:30',
    '08:00',
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
    '18:30',
    '19:00',
    '19:30',
    '20:00',
    '20:30',
    '21:00',
    '21:30',
    '22:00',
    '22:30',
    '23:00',
    '23:30',
  ];

  final List<String> _repeat = [
    'No repeat',
    'Every day',
    'Every week',
    'Every month'
  ];

  int get _totalPrice {
    int extraTotal = 0;
    for (final int i in _selectedExtraServices) {
      extraTotal += widget.extras[i].priceTnd;
    }
    return widget.basePriceTnd + extraTotal;
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500), () {
      _scrollController.scrollTo(
        index: 24,
        duration: Duration(seconds: 3),
        curve: Curves.easeInOut,
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppLanguageController lang = AppLanguageController.instance;
    final Color primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        actions: [
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        },
        child: Icon(Icons.arrow_forward_ios),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: FadeInUp(child: Padding(
                padding: EdgeInsets.only(top: 120.0, right: 20.0, left: 20.0),
                child: Text(
                  '${lang.tr('select_date')}\n${lang.trService(widget.serviceName)}',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.grey.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ))
          ];
        },
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              FadeInUp(child: Row(
                children: [
                  Text("October 2021"),
                  Spacer(),
                  IconButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {}, 
                    icon: Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.grey.shade700,),
                  )
                ],
              )),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(width: 1.5, color: Colors.grey.shade200),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _days.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FadeInUp(
                      delay: Duration(milliseconds: 500 * index),
                       child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDay = _days[index][0];
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: 62,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: _selectedDay == _days[index][0] ? primary.withOpacity(0.15) : Colors.transparent,
                          border: Border.all(
                            color: _selectedDay == _days[index][0] ? primary : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_days[index][0].toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            SizedBox(height: 10,),
                            Text(_days[index][1], style: TextStyle(fontSize: 16),),
                          ],
                        ),
                      ),
                    ));
                  }
                ),
              ),
              SizedBox(height: 10,),
              FadeInUp(child: Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(width: 1.5, color: Colors.grey.shade200),
                ),
                child: ScrollablePositionedList.builder(
                  itemScrollController: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: _hours.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedHour = _hours[index];
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: _selectedHour == _hours[index] ? Colors.orange.shade100.withOpacity(0.5) : Colors.orange.withOpacity(0),
                          border: Border.all(
                            color: _selectedHour == _hours[index] ? Colors.orange : Colors.white.withOpacity(0),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_hours[index], style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                          ],
                        ),
                      ),
                    );
                  }
                ),
              )),
              SizedBox(height: 40,),
              FadeInUp(child: Text(lang.tr('repeat'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),)),
              SizedBox(height: 10,),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _repeat.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedRepeat = index;
                        });
                      },
                      child: FadeInUp(
                        delay: Duration(milliseconds: 500 * index),
                        child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: _selectedRepeat == index ? primary : Theme.of(context).cardColor,
                        ),
                        margin: EdgeInsets.only(right: 20),
                        child: Center(child: Text(_repeat[index], 
                          style: TextStyle(fontSize: 18, color: _selectedRepeat == index ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color),)
                        ),
                      )),
                    );
                  },
                )
              ),
              SizedBox(height: 40,),
              FadeInUp(child: Text(lang.tr('additional_service'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),)),
              SizedBox(height: 10,),
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.extras.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_selectedExtraServices.contains(index)) {
                            _selectedExtraServices.remove(index);
                          } else {
                            _selectedExtraServices.add(index);
                          }
                        });
                      },
                      child: FadeInUp(
                        delay: Duration(milliseconds: 500 * index),
                        child: Container(
                        width: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: _selectedExtraServices.contains(index) ? primary : Theme.of(context).cardColor.withOpacity(0.35),
                        ),
                        margin: EdgeInsets.only(right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.network(widget.extras[index].imageUrl, height: 40,),
                            SizedBox(height: 10,),
                            Text(widget.extras[index].name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: _selectedExtraServices.contains(index) ? Colors.white : Colors.grey.shade800),),
                            SizedBox(height: 5,),
                            Text("+${widget.extras[index].priceTnd} TND", style: TextStyle(color: Colors.black),)
                          ],
                        )
                      ))
                    );
                  },  
                )
              ),
              SizedBox(height: 20),
              FadeInUp(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${lang.tr('provider')}: ${widget.providerName}'),
                      const SizedBox(height: 4),
                      Text('${lang.tr('base_price')}: ${widget.basePriceTnd} TND'),
                      const SizedBox(height: 4),
                      Text('${lang.tr('total')}: $_totalPrice TND',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ],
          ), 
        ),
      )
    );
  }
}