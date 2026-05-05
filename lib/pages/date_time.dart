import 'package:animate_do/animate_do.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/models/chat_contact.dart';
import 'package:day35/models/service_provider.dart';
import 'package:day35/models/booking.dart';
import 'package:day35/services/storage_service.dart';
import 'package:day35/pages/chat_detail.dart';
import 'package:day35/pages/my_bookings_page.dart';
import 'package:day35/widgets/app_actions.dart';
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
  int _bookingStep = 1;
  int _selectedDay = 2;
  int _selectedRepeat = 0;
  String _selectedHour = '13:30';
  List<int> _selectedExtraServices = [];
  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();
  bool _isUrgent = false;
  bool _safetyChecklistAccepted = false;
  bool _autoShareEmergencyContact = true;
  String? _selectedProblemPreset;

  ItemScrollController _scrollController = ItemScrollController();

  final List<dynamic> _days = [
    [1, 'Fri'], [2, 'Sat'], [3, 'Sun'], [4, 'Mon'], [5, 'Tue'], [6, 'Wed'], [7, 'Thu'],
    [8, 'Fri'], [9, 'Sat'], [10, 'Sun'], [11, 'Mon'], [12, 'Tue'], [13, 'Wed'], [14, 'Thu'],
    [15, 'Fri'], [16, 'Sat'], [17, 'Sun'], [18, 'Mon'], [19, 'Tue'], [20, 'Wed'], [21, 'Thu'],
    [22, 'Fri'], [23, 'Sat'], [24, 'Sun'], [25, 'Mon'], [26, 'Tue'], [27, 'Wed'], [28, 'Thu'],
    [29, 'Fri'], [30, 'Sat'], [31, 'Sun']
  ];

  final List<String> _hours = <String>[
    '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
    '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30',
    '16:00', '16:30', '17:00', '17:30', '18:00', '18:30', '19:00', '19:30',
    '20:00', '20:30', '21:00', '21:30', '22:00',
  ];

  static const Map<String, List<String>> _problemPresetsByService =
      <String, List<String>>{
    'Cleaning': <String>['Deep cleaning', 'Kitchen focus', 'Post-renovation', 'Weekly maintenance'],
    'Plumber': <String>['Water leak', 'Blocked sink', 'Water heater', 'Low pressure'],
    'Electrician': <String>['Power outage', 'Socket repair', 'Lighting', 'Safety check'],
    'AC Repair': <String>['No cooling', 'Noisy AC', 'Water dripping', 'Maintenance'],
    'Painter': <String>['Room repaint', 'Full repaint', 'Wall touch-up', 'Color consult'],
  };

  List<String> get _problemPresets =>
      _problemPresetsByService[widget.serviceName] ??
      <String>['Installation', 'Repair', 'Maintenance', 'Inspection'];

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
      0, (int sum, int i) => sum + widget.extras[i].priceTnd,
    );
    int total = widget.basePriceTnd + extraTotal;
    total += _distanceFee;
    if (_issueController.text.trim().length > 35) total += 8;
    if (_isUrgent) total += 15;
    
    if (_selectedRepeat == 1) total -= 5;
    else if (_selectedRepeat == 2) total -= 7;
    else if (_selectedRepeat == 3) total -= 10;
    
    return total < 20 ? 20 : total;
  }

  int get _minNegotiablePrice => (_totalPrice * 0.85).round();
  int? get _budgetValueTnd => int.tryParse(_budgetController.text.trim());

  void _confirmBooking() {
    final lang = AppLanguageController.instance;
    if (!_safetyChecklistAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.tr('safety_ack_needed'))),
      );
      return;
    }
    final booking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      providerName: widget.providerName,
      serviceName: widget.serviceName,
      providerImageUrl: widget.providerImageUrl,
      date: 'May $_selectedDay',
      time: _selectedHour,
      price: _totalPrice,
      status: BookingStatus.pending,
      arrivalCode: _generateArrivalCode(),
    );

    BookingStore.instance.add(booking);
    _autoShareSafetyContact();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(lang.tr('booking_confirmed_title')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            Text('${lang.tr('booking_pending_with')} ${widget.providerName}. ${lang.tr('track_in_profile')}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const MyBookingsPage()),
              );
            },
            child: Text(lang.tr('view_my_bookings')),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _emergencyContactController.text = StorageService.instance.getEmergencyContact();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_scrollController.isAttached) {
        _scrollController.scrollTo(
          index: 10,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _issueController.dispose();
    _budgetController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLanguageController lang = AppLanguageController.instance;
    final Color primary = Theme.of(context).colorScheme.primary;
    
    return AnimatedBuilder(
      animation: AppLanguageController.instance,
      builder: (context, _) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(lang.tr('book_service')),
          actions: [
            const AppActions(),
          ],
        ),
        bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _bookingStep == 1 ? lang.tr('booking_step_1') : lang.tr('booking_step_2'),
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text('$_totalPrice TND', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primary)),
                ],
              ),
              const SizedBox(height: 16),
              if (_bookingStep == 1)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => setState(() => _bookingStep = 2),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 0,
                    ),
                    child: Text(lang.tr('continue_to_schedule')),
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _bookingStep = 1),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: Text(lang.tr('back')),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _openNegotiationChat,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: Text(lang.tr('negotiate')),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _safetyChecklistAccepted ? _confirmBooking : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _safetyChecklistAccepted ? primary : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 0,
                        ),
                        child: Text(lang.tr('confirm_book')),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
        body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 20),
          FadeInDown(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(widget.providerImageUrl),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.providerName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified_user_rounded, size: 14, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(lang.tr('id_verified'), style: const TextStyle(fontSize: 12, color: Colors.blue)),
                      ],
                    ),
                    Text(lang.trService(widget.serviceName), style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: _buildStepChip(
                  label: lang.tr('booking_step_1'),
                  isActive: _bookingStep == 1,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStepChip(
                  label: lang.tr('booking_step_2'),
                  isActive: _bookingStep == 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Date Selection
          if (_bookingStep == 2) ...[
            FadeInLeft(
              child: Text(lang.tr('select_date'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _days.length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedDay == _days[index][0];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDay = _days[index][0]),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 70,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? primary : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: isSelected ? primary : Colors.grey.shade300),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_days[index][1], style: TextStyle(color: isSelected ? Colors.white : Colors.grey)),
                          const SizedBox(height: 5),
                          Text(_days[index][0].toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            FadeInLeft(
              child: Text(lang.tr('select_time'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 50,
              child: ScrollablePositionedList.builder(
                itemScrollController: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: _hours.length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedHour == _hours[index];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedHour = _hours[index]),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.orange : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSelected ? Colors.orange : Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text(_hours[index], style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black)),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            FadeInLeft(
              child: Text(lang.tr('additional_service'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.extras.length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedExtraServices.contains(index);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) _selectedExtraServices.remove(index);
                        else _selectedExtraServices.add(index);
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 120,
                      margin: const EdgeInsets.only(right: 15),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? primary.withValues(alpha: 0.1) : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? primary : Colors.grey.shade200, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(widget.extras[index].imageUrl, height: 40),
                          const SizedBox(height: 10),
                          Text(widget.extras[index].name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                          Text('+${widget.extras[index].priceTnd} TND', style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
          
          // Issue Details
          if (_bookingStep == 1)
            FadeInUp(
              child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lang.tr('describe_problem'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _problemPresets.map((preset) => ChoiceChip(
                      label: Text(preset),
                      selected: _selectedProblemPreset == preset,
                      onSelected: (selected) {
                        setState(() {
                          _selectedProblemPreset = selected ? preset : null;
                          if (selected) _issueController.text = preset;
                        });
                      },
                      selectedColor: primary.withValues(alpha: 0.2),
                      labelStyle: TextStyle(color: _selectedProblemPreset == preset ? primary : Colors.black),
                    )).toList(),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _issueController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: lang.tr('describe_more_here'),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _isUrgent ? Colors.red.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: _isUrgent ? Colors.red.withValues(alpha: 0.3) : Colors.blue.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isUrgent ? Icons.bolt_rounded : Icons.info_outline_rounded,
                          color: _isUrgent ? Colors.red : Colors.blue,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isUrgent ? lang.tr('urgent_request') : lang.tr('standard_request'),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _isUrgent ? Colors.red : Colors.blue.shade700,
                                ),
                              ),
                              Text(
                                _isUrgent 
                                  ? lang.tr('urgent_response_hint')
                                  : lang.tr('standard_response_hint'),
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _isUrgent,
                          onChanged: (v) => setState(() => _isUrgent = v),
                          activeThumbColor: Colors.red,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${lang.tr('budget')} (TND)', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _budgetController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: lang.tr('budget_example'),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shield_outlined, color: Colors.orange),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            lang.tr('safety_confirm_label'),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        Switch.adaptive(
                          value: _safetyChecklistAccepted,
                          onChanged: (v) => setState(() => _safetyChecklistAccepted = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _emergencyContactController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: lang.tr('emergency_contact'),
                      hintText: '+216...',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(lang.tr('auto_share_emergency_contact')),
                    value: _autoShareEmergencyContact,
                    onChanged: (v) => setState(() => _autoShareEmergencyContact = v),
                  ),
                ],
              ),
              ),
            ),
          
          const SizedBox(height: 100), // Space for bottom bar
        ],
      ),
      ),
    );
  }

  void _openNegotiationChat() {
    final String issueText = _issueController.text.trim().isEmpty
        ? (_selectedProblemPreset ?? 'I need help with ${widget.serviceName.toLowerCase()}.')
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
            quotedPriceTnd: _budgetValueTnd == null
                ? _totalPrice
                : ((_totalPrice + _budgetValueTnd!) / 2).round(),
            minNegotiablePriceTnd: _budgetValueTnd == null
                ? _minNegotiablePrice
                : (_budgetValueTnd! * 0.9).round().clamp(20, _totalPrice),
            issueDescription: issueText,
            isUrgent: _isUrgent,
            clientBudgetTnd: _budgetValueTnd,
            starterMessages: <String>[
              'Salem ${widget.providerName.split(' ').first}, $issueText',
              if (_isUrgent) 'This is an urgent request!',
              'My budget is ${_budgetController.text.trim().isEmpty ? 'open to discuss' : '${_budgetController.text.trim()} TND'}.',
            ],
          ),
        ),
      ),
    );
  }

  void _autoShareSafetyContact() {
    final lang = AppLanguageController.instance;
    final contact = _emergencyContactController.text.trim();
    if (contact.isEmpty) return;
    StorageService.instance.saveEmergencyContact(contact);
    if (!_autoShareEmergencyContact) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${lang.tr('safety_auto_shared_with')} $contact')),
    );
  }

  String _generateArrivalCode() {
    final int code = 1000 + (DateTime.now().millisecondsSinceEpoch % 9000);
    return code.toString();
  }

  Widget _buildStepChip({required String label, required bool isActive}) {
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.14) : Colors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isActive ? color : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
