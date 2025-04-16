/*
@author: Omar
@date: 2025-03-09
@Developed by: Omar Nasr (https://moqa.dev)
@contact: omar@moqa.dev
*/
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Dummy notification data
  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: 'Leave Request Approved',
      message: 'Your leave request for 27-28 Aug has been approved by the manager.',
      time: '2 hours ago',
      isRead: false,
      icon: Icons.check_circle,
      iconColor: Colors.green,
    ),
    NotificationItem(
      title: 'New Announcement',
      message: 'Company meeting scheduled for tomorrow at 10:00 AM in the conference room.',
      time: '5 hours ago',
      isRead: false,
      icon: Icons.campaign,
      iconColor: Colors.blue,
    ),
    NotificationItem(
      title: 'Expense Report',
      message: 'Your expense report #EXP-2023-089 has been processed and reimbursement is on the way.',
      time: 'Yesterday',
      isRead: true,
      icon: Icons.receipt_long,
      iconColor: Colors.purple,
    ),
    NotificationItem(
      title: 'Attendance Alert',
      message: 'You were marked late yesterday. Please ensure timely check-in.',
      time: '2 days ago',
      isRead: true,
      icon: Icons.access_time,
      iconColor: Colors.orange,
    ),
    NotificationItem(
      title: 'Payslip Generated',
      message: 'Your payslip for August 2023 has been generated and is available for download.',
      time: '3 days ago',
      isRead: true,
      icon: Icons.account_balance_wallet,
      iconColor: Colors.teal,
    ),
    NotificationItem(
      title: 'Team Update',
      message: 'Welcome Alex Johnson to the HR team! Please help them settle in.',
      time: '1 week ago',
      isRead: true,
      icon: Icons.people,
      iconColor: Colors.indigo,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifications',
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
            icon: const Icon(Icons.done_all, color: Colors.grey),
            onPressed: () {
              // Mark all as read
              setState(() {
                for (var notification in _notifications) {
                  notification.isRead = true;
                }
              });
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications marked as read'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationItem(_notifications[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Dismissible(
      key: Key(notification.title),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          _notifications.remove(notification);
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification removed'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                setState(() {
                  _notifications.add(notification);
                  // Sort notifications back to original order if needed
                });
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: notification.iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              notification.icon,
              color: notification.iconColor,
              size: 24,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.message,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                notification.time,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          onTap: () {
            // Mark as read when tapped
            setState(() {
              notification.isRead = true;
            });
            
            // Show notification details or take action
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Viewing: ${notification.title}'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String message;
  final String time;
  bool isRead;
  final IconData icon;
  final Color iconColor;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.icon,
    required this.iconColor,
  });
} 