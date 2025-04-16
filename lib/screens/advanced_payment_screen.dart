/*
@author: Omar
@date: 2025-03-09
@Developed by: Omar Nasr (https://moqa.dev)
@contact: omar@moqa.dev
*/
import 'package:flutter/material.dart';

class AdvancedPaymentScreen extends StatefulWidget {
  const AdvancedPaymentScreen({super.key});

  @override
  State<AdvancedPaymentScreen> createState() => _AdvancedPaymentScreenState();
}

class _AdvancedPaymentScreenState extends State<AdvancedPaymentScreen> {
  String _selectedFilter = 'Pending';
  final List<String> _filters = ['Pending', 'Approved', 'Rejected'];
  
  // Sample advanced payment data
  final List<Map<String, dynamic>> _advancedPayments = [
    {
      'title': 'Salary Advance',
      'date': '20 Jul, 2023',
      'amount': '\$500.00',
      'reason': 'Personal Emergency',
      'status': 'Pending',
      'daysAgo': 5,
    },
    {
      'title': 'Project Expense',
      'date': '15 Jul, 2023',
      'amount': '\$350.00',
      'reason': 'Client Meeting',
      'status': 'Pending',
      'daysAgo': 10,
    },
    {
      'title': 'Travel Advance',
      'date': '10 Jul, 2023',
      'amount': '\$800.00',
      'reason': 'Business Trip',
      'status': 'Pending',
      'daysAgo': 15,
    },
    {
      'title': 'Equipment Purchase',
      'date': '5 Jul, 2023',
      'amount': '\$1200.00',
      'reason': 'Office Setup',
      'status': 'Pending',
      'daysAgo': 20,
    },
    {
      'title': 'Training Fee',
      'date': '1 Jul, 2023',
      'amount': '\$450.00',
      'reason': 'Professional Development',
      'status': 'Pending',
      'daysAgo': 24,
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
          'Advanced Payment',
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
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF1a73e8) : Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey[700],
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
          
          // Advanced payments list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _advancedPayments.length,
              itemBuilder: (context, index) {
                final payment = _advancedPayments[index];
                return _buildAdvancedPaymentItem(payment);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPaymentForm(context);
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
  
  Widget _buildAdvancedPaymentItem(Map<String, dynamic> payment) {
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
      child: Row(
        children: [
          // Payment icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getReasonColor(payment['reason']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getReasonIcon(payment['reason']),
              color: _getReasonColor(payment['reason']),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          
          // Payment details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  payment['date'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  payment['reason'],
                  style: TextStyle(
                    color: _getReasonColor(payment['reason']),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Amount and action buttons
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                payment['amount'],
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${payment['daysAgo']} Days Ago',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  // Reject button
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.red[400],
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Approve button
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.green[400],
                      size: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Color _getReasonColor(String reason) {
    switch (reason) {
      case 'Personal Emergency':
        return Colors.red;
      case 'Client Meeting':
        return Colors.purple;
      case 'Business Trip':
        return Colors.blue;
      case 'Office Setup':
        return Colors.teal;
      case 'Professional Development':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }
  
  IconData _getReasonIcon(String reason) {
    switch (reason) {
      case 'Personal Emergency':
        return Icons.warning;
      case 'Client Meeting':
        return Icons.people;
      case 'Business Trip':
        return Icons.flight;
      case 'Office Setup':
        return Icons.computer;
      case 'Professional Development':
        return Icons.school;
      default:
        return Icons.attach_money;
    }
  }
  
  void _showAddPaymentForm(BuildContext context) {
    // Form controllers
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final dateController = TextEditingController();
    final reasonController = TextEditingController();
    String selectedReason = 'Personal Emergency';
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                            'New Advanced Payment',
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
                          // Title
                          const Text(
                            'Payment Title',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(
                              hintText: 'Enter payment title',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedReason,
                                isExpanded: true,
                                items: ['Personal Emergency', 'Client Meeting', 'Business Trip', 'Office Setup', 'Professional Development', 'Other']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedReason = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Amount
                          const Text(
                            'Amount',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter amount',
                              prefixText: '\$ ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Date
                          const Text(
                            'Date Needed',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: dateController,
                            decoration: InputDecoration(
                              hintText: 'Select date',
                              suffixIcon: const Icon(Icons.calendar_today),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            ),
                            readOnly: true,
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 90)),
                              );
                              if (picked != null) {
                                setState(() {
                                  dateController.text = "${picked.day} ${_getMonthName(picked.month)}, ${picked.year}";
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          
                          // Additional Details
                          const Text(
                            'Additional Details',
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
                              hintText: 'Enter additional details',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.all(15),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Repayment plan
                          const Text(
                            'Repayment Plan',
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
                                Row(
                                  children: [
                                    Icon(
                                      Icons.payments_outlined,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Salary Deduction',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'The advanced payment will be deducted from your next salary payment.',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
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
                          if (titleController.text.isNotEmpty &&
                              amountController.text.isNotEmpty &&
                              dateController.text.isNotEmpty) {
                            // Add new payment to the list
                            setState(() {
                              _advancedPayments.insert(0, {
                                'title': titleController.text,
                                'date': dateController.text,
                                'amount': '\$${amountController.text}',
                                'reason': selectedReason,
                                'status': 'Pending',
                                'daysAgo': 0,
                              });
                            });
                            
                            // Show success message and close form
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Advanced payment request submitted successfully'),
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
          }
        );
      },
    );
  }
  
  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
} 