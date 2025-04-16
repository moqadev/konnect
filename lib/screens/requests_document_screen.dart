/*
@author: Omar
@date: 2025-03-09
@Developed by: Omar Nasr (https://moqa.dev)
@contact: omar@moqa.dev
*/
import 'package:flutter/material.dart';

class RequestsDocumentScreen extends StatefulWidget {
  const RequestsDocumentScreen({super.key});

  @override
  State<RequestsDocumentScreen> createState() => _RequestsDocumentScreenState();
}

class _RequestsDocumentScreenState extends State<RequestsDocumentScreen> {
  String _selectedFilter = 'Pending';
  final List<String> _filters = ['Pending', 'Approved', 'Rejected'];
  
  // Sample document request data
  final List<Map<String, dynamic>> _documentRequests = [
    {
      'title': 'Employment Certificate',
      'date': '25 Aug, 2023',
      'type': 'Certificate',
      'purpose': 'Visa Application',
      'status': 'Pending',
      'daysAgo': 2,
    },
    {
      'title': 'Salary Statement',
      'date': '20 Aug, 2023',
      'type': 'Statement',
      'purpose': 'Bank Loan',
      'status': 'Pending',
      'daysAgo': 7,
    },
    {
      'title': 'Experience Letter',
      'date': '15 Aug, 2023',
      'type': 'Letter',
      'purpose': 'Professional Record',
      'status': 'Pending',
      'daysAgo': 12,
    },
    {
      'title': 'Tax Certificate',
      'date': '10 Aug, 2023',
      'type': 'Certificate',
      'purpose': 'Tax Filing',
      'status': 'Pending',
      'daysAgo': 17,
    },
    {
      'title': 'Promotion Letter',
      'date': '5 Aug, 2023',
      'type': 'Letter',
      'purpose': 'Personal Record',
      'status': 'Pending',
      'daysAgo': 22,
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
          'Requests Document',
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
          
          // Document requests list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _documentRequests.length,
              itemBuilder: (context, index) {
                final request = _documentRequests[index];
                return _buildDocumentRequestItem(request);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDocumentForm(context);
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
  
  Widget _buildDocumentRequestItem(Map<String, dynamic> request) {
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
          // Document type icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getDocumentTypeColor(request['type']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getDocumentTypeIcon(request['type']),
              color: _getDocumentTypeColor(request['type']),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          
          // Document details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request['title'],
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
                Text(
                  'Purpose: ${request['purpose']}',
                  style: TextStyle(
                    color: _getDocumentTypeColor(request['type']),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Status and action buttons
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
  
  Color _getDocumentTypeColor(String type) {
    switch (type) {
      case 'Certificate':
        return Colors.blue;
      case 'Statement':
        return Colors.purple;
      case 'Letter':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
  
  IconData _getDocumentTypeIcon(String type) {
    switch (type) {
      case 'Certificate':
        return Icons.verified;
      case 'Statement':
        return Icons.description;
      case 'Letter':
        return Icons.mail;
      default:
        return Icons.insert_drive_file;
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
  
  void _showAddDocumentForm(BuildContext context) {
    // Form controllers
    final titleController = TextEditingController();
    final purposeController = TextEditingController();
    String selectedDocumentType = 'Certificate';
    
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
                            'New Document Request',
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
                          // Document Title
                          const Text(
                            'Document Title',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(
                              hintText: 'Enter document title',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Document Type
                          const Text(
                            'Document Type',
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
                                value: selectedDocumentType,
                                isExpanded: true,
                                items: ['Certificate', 'Statement', 'Letter', 'Other']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedDocumentType = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Purpose
                          const Text(
                            'Purpose',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: purposeController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: 'Enter purpose for requesting this document',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.all(15),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Delivery Method
                          const Text(
                            'Delivery Method',
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
                              children: [
                                _buildDeliveryOption(
                                  icon: Icons.email,
                                  title: 'Email',
                                  description: 'Receive document via email',
                                  isSelected: true,
                                ),
                                const SizedBox(height: 10),
                                _buildDeliveryOption(
                                  icon: Icons.print,
                                  title: 'Hard Copy',
                                  description: 'Collect printed document from HR',
                                  isSelected: false,
                                ),
                                const SizedBox(height: 10),
                                _buildDeliveryOption(
                                  icon: Icons.cloud_download,
                                  title: 'Digital Download',
                                  description: 'Download from employee portal',
                                  isSelected: false,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Additional Notes
                          const Text(
                            'Additional Notes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: 'Any additional information (optional)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.all(15),
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
                              purposeController.text.isNotEmpty) {
                            // Add new document request to the list
                            setState(() {
                              _documentRequests.insert(0, {
                                'title': titleController.text,
                                'date': '${DateTime.now().day} ${_getMonthName(DateTime.now().month)}, ${DateTime.now().year}',
                                'type': selectedDocumentType,
                                'purpose': purposeController.text,
                                'status': 'Pending',
                                'daysAgo': 0,
                              });
                            });
                            
                            // Show success message and close form
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Document request submitted successfully'),
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
  
  Widget _buildDeliveryOption({
    required IconData icon,
    required String title,
    required String description,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.blue : Colors.grey[600],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.blue : Colors.black,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.blue[700] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Radio(
            value: true,
            groupValue: isSelected,
            onChanged: (value) {},
            activeColor: Colors.blue,
          ),
        ],
      ),
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