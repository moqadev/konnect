/*
@author: Omar
@date: 2025-03-09
@Developed by: Omar Nasr (https://moqa.dev)
@contact: omar@moqa.dev
*/
import 'package:flutter/material.dart';

class DocumentManagementScreen extends StatefulWidget {
  const DocumentManagementScreen({super.key});

  @override
  State<DocumentManagementScreen> createState() => _DocumentManagementScreenState();
}

class _DocumentManagementScreenState extends State<DocumentManagementScreen> {
  // Sample document data
  final List<Map<String, dynamic>> _documents = [
    {
      'name': 'Employment Contract',
      'type': 'PDF',
      'size': '2.5 MB',
      'date': '15 Jan, 2023',
      'icon': Icons.picture_as_pdf,
      'color': Colors.red,
    },
    {
      'name': 'Salary Statement - Jan 2023',
      'type': 'PDF',
      'size': '1.2 MB',
      'date': '05 Feb, 2023',
      'icon': Icons.picture_as_pdf,
      'color': Colors.red,
    },
    {
      'name': 'Company Policy Handbook',
      'type': 'DOCX',
      'size': '3.7 MB',
      'date': '10 Dec, 2022',
      'icon': Icons.description,
      'color': Colors.blue,
    },
    {
      'name': 'Tax Documents - 2022',
      'type': 'ZIP',
      'size': '5.1 MB',
      'date': '20 Mar, 2023',
      'icon': Icons.folder_zip,
      'color': Colors.amber,
    },
    {
      'name': 'Performance Review - Q1 2023',
      'type': 'DOCX',
      'size': '1.8 MB',
      'date': '15 Apr, 2023',
      'icon': Icons.description,
      'color': Colors.blue,
    },
    {
      'name': 'Training Certificate',
      'type': 'PDF',
      'size': '0.8 MB',
      'date': '30 May, 2023',
      'icon': Icons.picture_as_pdf,
      'color': Colors.red,
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
          'Document Management',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Document categories
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildCategoryChip('All Documents', true),
                  _buildCategoryChip('PDF Files', false),
                  _buildCategoryChip('Word Documents', false),
                  _buildCategoryChip('Spreadsheets', false),
                  _buildCategoryChip('Archives', false),
                ],
              ),
            ),
          ),
          
          // Document list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _documents.length,
              itemBuilder: (context, index) {
                final document = _documents[index];
                return _buildDocumentItem(document);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show upload document dialog
          _showUploadDocumentDialog();
        },
        backgroundColor: const Color(0xFF1a73e8),
        child: const Icon(Icons.upload_file),
      ),
    );
  }
  
  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        backgroundColor: isSelected ? const Color(0xFF1a73e8) : Colors.grey[100],
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
  
  Widget _buildDocumentItem(Map<String, dynamic> document) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: document['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            document['icon'],
            color: document['color'],
            size: 24,
          ),
        ),
        title: Text(
          document['name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Text(
                document['type'],
                style: TextStyle(
                  color: document['color'],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                document['size'],
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                document['date'],
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            // Handle menu item selection
            if (value == 'view') {
              // View document
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Viewing ${document['name']}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            } else if (value == 'download') {
              // Download document
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Downloading ${document['name']}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            } else if (value == 'share') {
              // Share document
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sharing ${document['name']}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            } else if (value == 'delete') {
              // Delete document
              _showDeleteConfirmationDialog(document);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility, size: 20),
                  SizedBox(width: 8),
                  Text('View'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'download',
              child: Row(
                children: [
                  Icon(Icons.download, size: 20),
                  SizedBox(width: 8),
                  Text('Download'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'share',
              child: Row(
                children: [
                  Icon(Icons.share, size: 20),
                  SizedBox(width: 8),
                  Text('Share'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          // View document
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Viewing ${document['name']}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }
  
  void _showDeleteConfirmationDialog(Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Document'),
          content: Text('Are you sure you want to delete "${document['name']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Remove document from list
                setState(() {
                  _documents.remove(document);
                });
                
                // Close dialog
                Navigator.of(context).pop();
                
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Document deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
  
  void _showUploadDocumentDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
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
                        'Upload Document',
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
              
              // Upload options
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Document Type',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Document type options
                      _buildUploadOption(
                        icon: Icons.picture_as_pdf,
                        title: 'PDF Document',
                        subtitle: 'Upload PDF files',
                        color: Colors.red,
                      ),
                      const SizedBox(height: 15),
                      _buildUploadOption(
                        icon: Icons.description,
                        title: 'Word Document',
                        subtitle: 'Upload DOC or DOCX files',
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 15),
                      _buildUploadOption(
                        icon: Icons.table_chart,
                        title: 'Spreadsheet',
                        subtitle: 'Upload XLS or XLSX files',
                        color: Colors.green,
                      ),
                      const SizedBox(height: 15),
                      _buildUploadOption(
                        icon: Icons.image,
                        title: 'Image',
                        subtitle: 'Upload JPG, PNG or GIF files',
                        color: Colors.purple,
                      ),
                      const SizedBox(height: 15),
                      _buildUploadOption(
                        icon: Icons.folder_zip,
                        title: 'Archive',
                        subtitle: 'Upload ZIP or RAR files',
                        color: Colors.amber,
                      ),
                      const SizedBox(height: 30),
                      
                      // Or drag and drop area
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            style: BorderStyle.solid,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Drag and drop files here',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'or click to browse files',
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
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildUploadOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        // Handle upload option selection
        Navigator.pop(context);
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Uploading $title'),
            duration: const Duration(seconds: 1),
          ),
        );
        
        // Add new document to list
        setState(() {
          _documents.insert(0, {
            'name': '$title - ${DateTime.now().day} ${_getMonthName(DateTime.now().month)}, ${DateTime.now().year}',
            'type': title.contains('PDF') ? 'PDF' : 
                   title.contains('Word') ? 'DOCX' : 
                   title.contains('Spreadsheet') ? 'XLSX' : 
                   title.contains('Image') ? 'JPG' : 'ZIP',
            'size': '0.0 MB',
            'date': '${DateTime.now().day} ${_getMonthName(DateTime.now().month)}, ${DateTime.now().year}',
            'icon': icon,
            'color': color,
          });
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
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