import 'package:day35/models/booking.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/pages/rating_page.dart';
import 'package:day35/services/storage_service.dart';
import 'package:day35/theme/app_theme.dart';
import 'package:day35/widgets/app_actions.dart';
import 'package:flutter/material.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  static const List<String> _timelineSteps = <String>[
    'Searching',
    'Accepted',
    'On the way',
    'Arrived',
    'Done',
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookings = BookingStore.instance.all;
    final lang = AppLanguageController.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        actions: const [
          AppActions(),
        ],
      ),
      body: bookings.isEmpty
          ? const Center(child: Text('No bookings found'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(CompetitionTokens.radiusMd),
                  ),
                  shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.18),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(booking.providerImageUrl),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    booking.providerName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  Text(
                                    booking.serviceName,
                                    style: TextStyle(color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                            _buildStatusBadge(booking),
                          ],
                        ),
                        const Divider(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Date & Time', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                                Text('${booking.date} at ${booking.time}', style: const TextStyle(fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Total Price', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                                Text('${booking.price} TND', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                              ],
                            ),
                          ],
                        ),
                        if (booking.status == BookingStatus.pending) ...[
                          const SizedBox(height: 12),
                          _buildTimeline(booking),
                        ],
                        if ((booking.arrivalCode ?? '').isNotEmpty &&
                            booking.status == BookingStatus.pending) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: booking.safetyCodeVerified
                                  ? Colors.green.withValues(alpha: 0.08)
                                  : Colors.blue.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(CompetitionTokens.radiusSm),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  booking.safetyCodeVerified
                                      ? Icons.verified_user
                                      : Icons.shield_outlined,
                                  color: booking.safetyCodeVerified
                                      ? Colors.green
                                      : Colors.blue,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    booking.safetyCodeVerified
                                        ? 'Safety code verified'
                                        : '${lang.tr('arrival_code')}: ${booking.arrivalCode}',
                                    style: TextStyle(
                                      color: booking.safetyCodeVerified
                                          ? Colors.green
                                          : Colors.blue,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (booking.status == BookingStatus.pending &&
                            booking.progressStep >= 3 &&
                            !booking.safetyCodeVerified) ...[
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => _verifySafetyCode(booking),
                            icon: const Icon(Icons.lock_open_outlined),
                            label: const Text('Verify Safety Code'),
                          ),
                        ],
                        if (booking.status == BookingStatus.pending) ...[
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _triggerSos(booking),
                                  icon: const Icon(Icons.sos, color: Colors.red),
                                  label: const Text('SOS'),
                                ),
                              ),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: booking.progressStep >= 4
                                      ? null
                                      : () async {
                                          await BookingStore.instance.updateProgress(
                                            booking.id,
                                            booking.progressStep + 1,
                                          );
                                          if (mounted) {
                                            setState(() {});
                                          }
                                        },
                                  child: Text(
                                    booking.progressStep >= 4
                                        ? 'Timeline complete'
                                        : 'Next status',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      BookingStore.instance.updateStatus(booking.id, BookingStatus.cancelled);
                                    });
                                  },
                                  child: const Text('Cancel'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: booking.progressStep >= 4 &&
                                          booking.safetyCodeVerified
                                      ? () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => RatingPage(booking: booking)),
                                    );
                                    setState(() {});
                                  }
                                      : null,
                                  child: const Text('Mark Done'),
                                ),
                              ),
                            ],
                          ),
                        ] else if (booking.status == BookingStatus.completed) ...[
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 20),
                              const SizedBox(width: 4),
                              Text('${booking.rating ?? 0.0}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              if (booking.comment != null && booking.comment!.isNotEmpty) ...[
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '"${booking.comment}"',
                                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _triggerSos(Booking booking) async {
    final String emergencyContact = StorageService.instance.getEmergencyContact();
    final bool hasContact = emergencyContact.trim().isNotEmpty;
    final String message = hasContact
        ? 'SOS sent. Emergency contact: $emergencyContact'
        : 'SOS sent. Add emergency contact in Safety Center for direct calling.';

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Emergency SOS'),
          content: Text(
            'Provider: ${booking.providerName}\n'
            'Service: ${booking.serviceName}\n'
            '$message',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _verifySafetyCode(Booking booking) async {
    final TextEditingController codeController = TextEditingController();
    final bool? verified = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Verify arrival code'),
          content: TextField(
            controller: codeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter 4-digit code',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(
                context,
                codeController.text.trim() == (booking.arrivalCode ?? ''),
              ),
              child: const Text('Verify'),
            ),
          ],
        );
      },
    );

    if (verified == true) {
      await BookingStore.instance.verifySafetyCode(booking.id);
      if (!mounted) return;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Safety verification completed.')),
      );
      return;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid code. Please try again.')),
    );
  }

  Widget _buildTimeline(Booking booking) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Live timeline: ${_timelineSteps[booking.progressStep]}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(_timelineSteps.length, (int index) {
            final bool reached = booking.progressStep >= index;
            final bool isLast = index == _timelineSteps.length - 1;
            return Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: reached ? Colors.green : Colors.grey.shade300,
                    child: Icon(
                      reached ? Icons.check : Icons.circle,
                      size: 12,
                      color: reached ? Colors.white : Colors.grey.shade500,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: booking.progressStep > index
                            ? Colors.green
                            : Colors.grey.shade300,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: List.generate(_timelineSteps.length, (int index) {
            return Chip(
              label: Text(
                _timelineSteps[index],
                style: TextStyle(
                  fontSize: 11,
                  color: booking.progressStep >= index ? Colors.green : Colors.grey,
                ),
              ),
              backgroundColor: booking.progressStep >= index
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.grey.shade100,
              visualDensity: VisualDensity.compact,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(Booking booking) {
    final BookingStatus status = booking.status;
    Color color;
    String label;
    switch (status) {
      case BookingStatus.pending:
        color = Colors.orange;
        label = _timelineSteps[booking.progressStep];
        break;
      case BookingStatus.completed:
        color = Colors.green;
        label = 'Completed';
        break;
      case BookingStatus.cancelled:
        color = Colors.red;
        label = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(CompetitionTokens.radiusLg),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
