/*
@author: Omar
@date: 2025-03-09
@Developed by: Omar Nasr (https://moqa.dev)
@contact: omar@moqa.dev
*/
import 'package:flutter/material.dart';
import 'chat_detail_screen.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  // Selected filter
  String _selectedFilter = 'Designer';

  // Team members data
  final List<TeamMember> _teamMembers = [
    TeamMember(
      name: 'Jack Rich',
      position: 'Project Manager',
      category: 'My Team',
    ),
    TeamMember(
      name: 'Damian Daniel',
      position: 'UX Manager',
      category: 'Designer',
    ),
    TeamMember(
      name: 'Thomas Jeo',
      position: 'Account Manager',
      category: 'My Team',
    ),
    TeamMember(
      name: 'James Rhys',
      position: 'Managing Director',
      category: 'HR Admin',
    ),
    TeamMember(
      name: 'William Andi',
      position: 'Head of Project',
      category: 'My Team',
    ),
    TeamMember(
      name: 'Alexander',
      position: 'Project Manager',
      category: 'Designer',
    ),
    TeamMember(
      name: 'James Rhys',
      position: 'UI Designer',
      category: 'Designer',
    ),
    TeamMember(
      name: 'George Pika',
      position: 'HR Manager',
      category: 'HR Admin',
    ),
  ];

  // Filters
  final List<String> _filters = ['My Team', 'Designer', 'HR Admin'];

  @override
  Widget build(BuildContext context) {
    // Filter team members based on selected filter
    final filteredMembers = _teamMembers
        .where((member) => member.category == _selectedFilter)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Team',
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
      ),
      body: Column(
        children: [
          // Filter tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  _filters.map((filter) => _buildFilterTab(filter)).toList(),
            ),
          ),

          // Team members grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredMembers.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () =>
                      _showTeamMemberDetails(context, filteredMembers[index]),
                  child: _buildTeamMemberCard(filteredMembers[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showTeamMemberDetails(BuildContext context, TeamMember member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile image
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '78x75',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Name
              Text(
                member.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Position
              Text(
                member.position,
                style: TextStyle(
                  color: const Color(0xFF1a73e8),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Send message button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close bottom sheet

                    // Navigate to chat detail screen
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ChatDetailScreen(name: member.name),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOutCubic;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 500),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1a73e8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Send Message',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Cancel button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterTab(String filter) {
    final isSelected = _selectedFilter == filter;

    return GestureDetector(
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
            color: isSelected ? Colors.white : const Color(0xFF1a73e8),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMemberCard(TeamMember member) {
    return Column(
      children: [
        // Profile image
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '78x75',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Name
        Text(
          member.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        // Position
        Text(
          member.position,
          style: TextStyle(
            color: const Color(0xFF1a73e8),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class TeamMember {
  final String name;
  final String position;
  final String category;

  TeamMember({
    required this.name,
    required this.position,
    required this.category,
  });
}
