/*
@author: Omar
@date: 2025-03-09
@Developed by: Omar Nasr (https://moqa.dev)
@contact: omar@moqa.dev
*/
import 'package:flutter/material.dart';

class VacationRequestScreen extends StatefulWidget {
  const VacationRequestScreen({super.key});

  @override
  State<VacationRequestScreen> createState() => _VacationRequestScreenState();
}

class _VacationRequestScreenState extends State<VacationRequestScreen> {
  String _selectedFilter = 'Pending';
  final List<String> _filters = ['Pending', 'Approved', 'Rejected'];

  // Sample vacation request data
  final List<Map<String, dynamic>> _vacationRequests = [
    {
      'name': 'Summer Vacation',
      'date': '15 Jul - 30 Jul, 2023',
      'type': 'Annual Leave',
      'status': 'Pending',
      'daysAgo': 3,
      'days': 16,
    },
    {
      'name': 'Family Trip',
      'date': '10 Aug - 20 Aug, 2023',
      'type': 'Personal Leave',
      'status': 'Pending',
      'daysAgo': 7,
      'days': 11,
    },
    {
      'name': 'Winter Holiday',
      'date': '20 Dec - 5 Jan, 2023',
      'type': 'Annual Leave',
      'status': 'Pending',
      'daysAgo': 14,
      'days': 17,
    },
    {
      'name': 'Wedding Anniversary',
      'date': '25 Sep - 28 Sep, 2023',
      'type': 'Personal Leave',
      'status': 'Pending',
      'daysAgo': 21,
      'days': 4,
    },
    {
      'name': 'Medical Procedure',
      'date': '5 Nov - 12 Nov, 2023',
      'type': 'Medical Leave',
      'status': 'Pending',
      'daysAgo': 30,
      'days': 8,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Vacation Request',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Filter tabs
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: Colors.white,
            child: Row(
              children: [
                // Filter tabs in a scrollable row
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters.map((filter) {
                        bool isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF1a73e8)
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[700],
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Vacation requests list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _vacationRequests.length,
              itemBuilder: (context, index) {
                final request = _vacationRequests[index];
                return _buildVacationRequestItem(request);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddVacationForm(context);
        },
        backgroundColor: const Color(0xFF1a73e8),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1a73e8),
        unselectedItemColor: Colors.grey[400],
        currentIndex: 1, // Dashboard is selected
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pop();
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_outlined),
            activeIcon: Icon(Icons.access_time),
            label: 'Check In',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 8,
      ),
    );
  }

  Widget _buildVacationRequestItem(Map<String, dynamic> request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Vacation type icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color:
                      _getVacationTypeColor(request['type']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getVacationTypeIcon(request['type']),
                  color: _getVacationTypeColor(request['type']),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Vacation details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request['date'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getVacationTypeColor(request['type'])
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            request['type'],
                            style: TextStyle(
                              color: _getVacationTypeColor(request['type']),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${request['days']} Days',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Status and days ago
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      request['status'],
                      style: TextStyle(
                        color: _getStatusColor(request['status']),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${request['daysAgo']} Days Ago',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Divider and action buttons
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Reject button
              TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.close,
                  color: Colors.red[400],
                  size: 18,
                ),
                label: Text(
                  'Reject',
                  style: TextStyle(
                    color: Colors.red[400],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              const SizedBox(width: 12),
              // Approve button
              TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.check,
                  color: Colors.green[400],
                  size: 18,
                ),
                label: Text(
                  'Approve',
                  style: TextStyle(
                    color: Colors.green[400],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getVacationTypeColor(String type) {
    switch (type) {
      case 'Annual Leave':
        return Colors.teal;
      case 'Personal Leave':
        return Colors.purple;
      case 'Medical Leave':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  IconData _getVacationTypeIcon(String type) {
    switch (type) {
      case 'Annual Leave':
        return Icons.beach_access;
      case 'Personal Leave':
        return Icons.person;
      case 'Medical Leave':
        return Icons.local_hospital;
      default:
        return Icons.event;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showAddVacationForm(BuildContext context) {
    // Form controllers
    final nameController = TextEditingController();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();
    final reasonController = TextEditingController();
    String selectedVacationType = 'Annual Leave';

    // Calculate days between dates
    int calculateDays(String startDate, String endDate) {
      if (startDate.isEmpty || endDate.isEmpty) return 0;

      try {
        // Parse dates from format "DD MMM, YYYY"
        final startParts = startDate.split(' ');
        final endParts = endDate.split(' ');

        final startDay = int.parse(startParts[0]);
        final startMonth = _getMonthNumber(startParts[1].replaceAll(',', ''));
        final startYear = int.parse(startParts[2]);

        final endDay = int.parse(endParts[0]);
        final endMonth = _getMonthNumber(endParts[1].replaceAll(',', ''));
        final endYear = int.parse(endParts[2]);

        final start = DateTime(startYear, startMonth, startDay);
        final end = DateTime(endYear, endMonth, endDay);

        return end.difference(start).inDays +
            1; // Include both start and end days
      } catch (e) {
        return 0;
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          // Calculate days between selected dates
          final days =
              calculateDays(startDateController.text, endDateController.text);

          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a73e8),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'New Vacation Request',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Form
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Vacation Name
                        const Text(
                          'Vacation Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: 'Enter a name for your vacation',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Vacation Type
                        const Text(
                          'Vacation Type',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedVacationType,
                              isExpanded: true,
                              items: [
                                'Annual Leave',
                                'Personal Leave',
                                'Medical Leave',
                                'Other'
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedVacationType = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Date Range
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Start Date',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: startDateController,
                                    decoration: InputDecoration(
                                      hintText: 'Select date',
                                      suffixIcon:
                                          const Icon(Icons.calendar_today),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      final DateTime? picked =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now()
                                            .add(const Duration(days: 365)),
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          startDateController.text =
                                              "${picked.day} ${_getMonthName(picked.month)}, ${picked.year}";
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'End Date',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: endDateController,
                                    decoration: InputDecoration(
                                      hintText: 'Select date',
                                      suffixIcon:
                                          const Icon(Icons.calendar_today),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      if (startDateController.text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Please select a start date first'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }

                                      // Parse start date
                                      final startParts =
                                          startDateController.text.split(' ');
                                      final startDay = int.parse(startParts[0]);
                                      final startMonth = _getMonthNumber(
                                          startParts[1].replaceAll(',', ''));
                                      final startYear =
                                          int.parse(startParts[2]);
                                      final startDate = DateTime(
                                          startYear, startMonth, startDay);

                                      final DateTime? picked =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: startDate,
                                        firstDate: startDate,
                                        lastDate: DateTime.now()
                                            .add(const Duration(days: 365)),
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          endDateController.text =
                                              "${picked.day} ${_getMonthName(picked.month)}, ${picked.year}";
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Days count
                        if (days > 0)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blue[700],
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Total: $days days of vacation',
                                  style: TextStyle(
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 20),

                        // Reason
                        const Text(
                          'Reason',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: reasonController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Enter reason for vacation request',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.all(15),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Contact Information
                        const Text(
                          'Emergency Contact',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Contact name',
                                  prefixIcon: const Icon(Icons.person),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Contact phone number',
                                  prefixIcon: const Icon(Icons.phone),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Submit button
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate and submit form
                        if (nameController.text.isNotEmpty &&
                            startDateController.text.isNotEmpty &&
                            endDateController.text.isNotEmpty &&
                            reasonController.text.isNotEmpty) {
                          // Add new vacation request to the list
                          setState(() {
                            _vacationRequests.insert(0, {
                              'name': nameController.text,
                              'date':
                                  '${startDateController.text.split(',')[0]} - ${endDateController.text}',
                              'type': selectedVacationType,
                              'status': 'Pending',
                              'daysAgo': 0,
                              'days': days,
                            });
                          });

                          // Show success message and close form
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Vacation request submitted successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all required fields'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1a73e8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Submit Request',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  int _getMonthNumber(String month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months.indexOf(month) + 1;
  }
}
