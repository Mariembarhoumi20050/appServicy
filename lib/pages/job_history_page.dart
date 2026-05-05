import 'package:flutter/material.dart';
import 'package:day35/localization/app_language.dart';

class JobHistoryPage extends StatefulWidget {
  const JobHistoryPage({Key? key}) : super(key: key);

  @override
  State<JobHistoryPage> createState() => _JobHistoryPageState();
}

class _JobHistoryPageState extends State<JobHistoryPage> {
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Completed', 'Cancelled', 'Pending'];

  // Sample job history data
  final List<Map<String, dynamic>> _jobHistory = [
    {
      'id': 1,
      'clientName': 'Sarah M.',
      'service': 'Leaking Tap Repair',
      'date': '2024-05-01',
      'time': '14:30',
      'duration': '45 mins',
      'amount': '45 TND',
      'status': 'Completed',
      'rating': 4.5,
      'location': 'Tunis',
    },
    {
      'id': 2,
      'clientName': 'James K.',
      'service': 'Pipe Installation',
      'date': '2024-04-28',
      'time': '10:00',
      'duration': '2 hours',
      'amount': '120 TND',
      'status': 'Completed',
      'rating': 5.0,
      'location': 'Ariana',
    },
    {
      'id': 3,
      'clientName': 'Ahmed L.',
      'service': 'Sink Fix',
      'date': '2024-04-25',
      'time': '16:45',
      'duration': '30 mins',
      'amount': '60 TND',
      'status': 'Completed',
      'rating': 4.0,
      'location': 'Sfax',
    },
    {
      'id': 4,
      'clientName': 'Fatima Z.',
      'service': 'Emergency Water Leak',
      'date': '2024-04-22',
      'time': '09:00',
      'duration': '1.5 hours',
      'amount': '150 TND',
      'status': 'Completed',
      'rating': 5.0,
      'location': 'Sousse',
    },
    {
      'id': 5,
      'clientName': 'John D.',
      'service': 'Valve Replacement',
      'date': '2024-04-20',
      'time': '13:00',
      'duration': '1 hour',
      'amount': '80 TND',
      'status': 'Cancelled',
      'rating': null,
      'location': 'Monastir',
    },
  ];

  List<Map<String, dynamic>> get _filteredJobs {
    if (_selectedFilter == 'All') {
      return _jobHistory;
    }
    return _jobHistory.where((job) => job['status'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLanguageController.instance;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job History'),
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF0C1621) : Colors.white,
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: _filterOptions.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedFilter = filter);
                    },
                    backgroundColor: isDark
                        ? const Color(0xFF152130)
                        : const Color(0xFFF0F0F0),
                    selectedColor: primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Job List
          Expanded(
            child: _filteredJobs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history_rounded,
                            size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          'No jobs found',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredJobs.length,
                    itemBuilder: (context, index) {
                      final job = _filteredJobs[index];
                      final statusColor = _getStatusColor(job['status']);
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: isDark ? const Color(0xFF152130) : Colors.white,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            job['service'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                'Client: ${job['clientName']}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                '${job['date']} at ${job['time']}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                'Duration: ${job['duration']}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      job['status'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: statusColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (job['rating'] != null)
                                    Row(
                                      children: [
                                        const Icon(Icons.star_rounded,
                                            size: 16, color: Colors.amber),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${job['rating']}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                job['amount'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: primary,
                                ),
                              ),
                              Text(
                                job['location'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.white54
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          onTap: () => _showJobDetails(context, job, isDark),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showJobDetails(
      BuildContext context, Map<String, dynamic> job, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF0C1621) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                job['service'],
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _detailRow('Client', job['clientName']),
              _detailRow('Date', '${job['date']} at ${job['time']}'),
              _detailRow('Duration', job['duration']),
              _detailRow('Location', job['location']),
              _detailRow('Amount', job['amount']),
              _detailRow('Status', job['status']),
              if (job['rating'] != null)
                _detailRow('Rating', '⭐ ${job['rating']}/5'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
