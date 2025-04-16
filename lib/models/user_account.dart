/*
@author: Omar
@date: 2025-03-09
@Developed by: Omar Nasr (https://moqa.dev)
@contact: omar@moqa.dev
*/
import 'dart:convert';

class UserAccount {
  final String firstName;
  final String lastName;
  final String email;
  final String fullName;
  final String userImagePath;

  UserAccount({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.fullName,
    required this.userImagePath,
  });

  String get fullImageUrl {
    if (userImagePath.isEmpty) {
      return '';
    }
    // Construct full image URL using the base URL and image path
    return 'https://cben-stg-be.homains.online${userImagePath}';
  }

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    print('Parsing UserAccount from JSON: $json');

    // Extract the message object if it exists
    final messageData = json.containsKey('message') && json['message'] is Map
        ? json['message'] as Map<String, dynamic>
        : json;

    // Try different field names that might contain the data
    Map<String, dynamic> userData = messageData;
    if (messageData.containsKey('data') && messageData['data'] is Map) {
      userData = messageData['data'] as Map<String, dynamic>;
    } else if (messageData.containsKey('user') && messageData['user'] is Map) {
      userData = messageData['user'] as Map<String, dynamic>;
    }

    // Extract full name from the response
    String fullName = '';
    if (userData.containsKey('full_name')) {
      fullName = userData['full_name'] as String? ?? '';
    } else if (userData.containsKey('name')) {
      fullName = userData['name'] as String? ?? '';
    } else if (json.containsKey('full_name')) {
      fullName = json['full_name'] as String? ?? '';
    }

    print('Extracted fullName: $fullName');

    // Split the full name into first and last name
    List<String> nameParts = fullName.split(' ');
    String firstName = '';
    String lastName = '';

    // Try to get first name directly from the response
    if (userData.containsKey('first_name')) {
      firstName = userData['first_name'] as String? ?? '';
    } else if (nameParts.isNotEmpty) {
      firstName = nameParts[0];
    }

    // Try to get last name directly from the response
    if (userData.containsKey('last_name')) {
      lastName = userData['last_name'] as String? ?? '';
    } else if (nameParts.length > 1) {
      lastName = nameParts.skip(1).join(' ');
    }

    // Extract email
    String email = '';
    if (userData.containsKey('email')) {
      email = userData['email'] as String? ?? '';
    } else if (userData.containsKey('user_email')) {
      email = userData['user_email'] as String? ?? '';
    } else if (userData.containsKey('username')) {
      email = userData['username'] as String? ?? '';
    }

    // Extract user image path
    String userImagePath = '';
    if (userData.containsKey('user_image')) {
      userImagePath = userData['user_image'] as String? ?? '';
    } else if (json.containsKey('user_image')) {
      userImagePath = json['user_image'] as String? ?? '';
    }

    print(
        'Extracted user info - firstName: $firstName, lastName: $lastName, email: $email');
    print('Extracted user image path: $userImagePath');

    return UserAccount(
      firstName: firstName,
      lastName: lastName,
      email: email,
      fullName: fullName,
      userImagePath: userImagePath,
    );
  }

  static UserAccount? _instance;

  static UserAccount get instance {
    if (_instance == null) {
      throw Exception('UserAccount not initialized. Call loadFromJson first.');
    }
    return _instance!;
  }

  static void loadFromJson(String jsonString) {
    final Map<String, dynamic> data = jsonDecode(jsonString);
    _instance = UserAccount.fromJson(data);
  }

  static void loadFromUserData(Map<String, dynamic> userData) {
    _instance = UserAccount(
      firstName: userData['firstName'] as String? ?? '',
      lastName: userData['lastName'] as String? ?? '',
      email: userData['email'] as String? ?? '',
      fullName: userData['fullName'] as String? ?? '',
      userImagePath: userData['userImagePath'] as String? ?? '',
    );
  }

  static bool hasInstance() {
    return _instance != null;
  }

  static void clearInstance() {
    _instance = null;
  }
}
