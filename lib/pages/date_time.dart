import 'package:animate_do/animate_do.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/models/chat_contact.dart';
import 'package:day35/models/service_provider.dart';
import 'package:day35/pages/chat_detail.dart';
import 'package:day35/pages/chat_list.dart';
import 'package:day35/widgets/theme_toggle_action.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class DateAndTime extends StatefulWidget {
  final String serviceName;
  final String providerName;
  final String providerCity;
  final String providerImageUrl;
  final int basePriceTnd;
  final double? distanceKm;
  final List<String> availabilitySlots;
  final List<ServiceExtra> extras;

  const DateAndTime({
    Key? key,
    required this.serviceName,
    required this.providerName,
    required this.providerCity,
    required this.providerImageUrl,
    required this.basePriceTnd,
    this.distanceKm,
    this.availabilitySlots = const <String>[],
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
  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  bool _isUrgent = false;
  String? _selectedProblemPreset;

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

  static const Map<String, List<String>> _problemPresetsByService =
      <String, List<String>>{
    'Cleaning': <String>[
      'Deep cleaning (full home)',
      'Kitchen + bathroom focus',
      'Post-renovation cleaning',
      'Weekly maintenance cleaning',
    ],
    'Plumber': <String>[
      'Water leak',
      'Blocked sink / drain',
      'Water heater issue',
      'Low pressure',
    ],
    'Electrician': <String>[
      'Power outage in room',
      'Socket/switch replacement',
      'Lighting installation',
      'Circuit safety check',
    ],
    'AC Repair': <String>[
      'No cooling',
      'Noisy AC',
      'Water dripping',
      'Seasonal maintenance',
    ],
    'Painter': <String>[
      'Single room repaint',
      'Full apartment repaint',
      'Wall crack touch-up',
      'Color consultation',
    ],
  };

  List<String> get _problemPresets =>
      _problemPresetsByService[widget.serviceName] ??
      <String>[
        'Installation',
        'Repair',
        'Maintenance',
        'Inspection',
      ];

  int get _distanceFee {
    final double? distance = widget.distanceKm;
    if (distance == null) return 0;
    if (distance <= 5) return 0;
    if (distance <= 12) return 5;
    if (distance <= 20) return 10;
    return 15;
  }

  int get _totalPrice {
    final int extraTotal = _selectedExtraServices.fold<int>(
      0,
      (int sum, int i) => sum + widget.extras[i].priceTnd,
    );
    int total = widget.basePriceTnd + extraTotal;
    total += _distanceFee;
    if (_issueController.text.trim().length > 35) {
      total += 8;
    }
    if (_isUrgent) {
      total += 15;
    }
    if (_selectedRepeat == 1) {
      total -= 5;
    } else if (_selectedRepeat == 2) {
      total -= 7;
    } else if (_selectedRepeat == 3) {
      total -= 10;
    }
    return total < 20 ? 20 : total;
  }

  int get _minNegotiablePrice => (_totalPrice * 0.85).round();

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
  void dispose() {
    _issueController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLanguageController lang = AppLanguageController.instance;
    final Color primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        actions: [
          const ThemeToggleAction(),
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
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: ElevatedButton.icon(
          onPressed: _openNegotiationChat,
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Next: Negotiate & Confirm'),
          style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
        ),
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
        body: ListView(
          padding: EdgeInsets.all(20.0),
          children: [
            Column(
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
              if (widget.availabilitySlots.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  'Provider availability',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.availabilitySlots
                      .map(
                        (String slot) => Chip(
                          avatar: const Icon(Icons.schedule, size: 16),
                          label: Text(slot),
                        ),
                      )
                      .toList(),
                ),
              ],
              SizedBox(height: 20),
              FadeInUp(
                child: Text(
                  'Select issue category',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _problemPresets
                    .map(
                      (String preset) => ChoiceChip(
                        label: Text(preset),
                        selected: _selectedProblemPreset == preset,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedProblemPreset = selected ? preset : null;
                            if (selected && _issueController.text.trim().isEmpty) {
                              _issueController.text = preset;
                            }
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                child: Text(
                  'Describe your problem',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _issueController,
                maxLines: 3,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Example: Water leak under kitchen sink since yesterday...',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _budgetController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        labelText: 'Your budget (TND)',
                        hintText: '80',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SwitchListTile(
                      value: _isUrgent,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Urgent'),
                      onChanged: (bool value) {
                        setState(() => _isUrgent = value);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
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
                      if (widget.distanceKm != null) ...[
                        Text(
                          'Distance fee (${widget.distanceKm!.toStringAsFixed(1)} km): +$_distanceFee TND',
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text('Estimated quote: $_totalPrice TND',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('Negotiation range: $_minNegotiablePrice - $_totalPrice TND'),
                      const SizedBox(height: 4),
                      Text(
                        'Tap the chat button to negotiate directly with ${widget.providerName.split(' ').first}.',
                      ),
                    ],
                  ),
                ),
              ),
                const SizedBox(height: 24),
              ],
            ),
          ],
        ),
      )
    );
  }

  void _openNegotiationChat() {
    final String issueText = _issueController.text.trim().isEmpty
        ? (_selectedProblemPreset ??
            'I need help with ${widget.serviceName.toLowerCase()}.')
        : _issueController.text.trim();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatDetailPage(
          contact: ChatContact(
            name: widget.providerName,
            service: widget.serviceName,
            city: widget.providerCity,
            imageUrl: widget.providerImageUrl,
            quotedPriceTnd: _totalPrice,
            minNegotiablePriceTnd: _minNegotiablePrice,
            issueDescription: issueText,
            starterMessages: <String>[
              'Salem ${widget.providerName.split(' ').first}, $issueText',
              'Your estimated quote is $_totalPrice TND. My budget is ${_budgetController.text.trim().isEmpty ? 'open to discuss' : '${_budgetController.text.trim()} TND'}.',
              'Can we negotiate a bit?',
            ],
          ),
        ),
      ),
    );
  }
}