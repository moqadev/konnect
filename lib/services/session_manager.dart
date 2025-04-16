/*
@author: Omar
@date: 2025-03-09
@Developed by: Omar Nasr (https://moqa.dev)
@contact: omar@moqa.dev
*/
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_account.dart';

class SessionManager {
  // Keys for shared preferences
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userDataKey = 'userData';
  static const String _sessionIdKey = 'sessionId';
  static const String _cookiesKey = 'cookies';

  // Save login session
  static Future<bool> saveLoginSession(UserAccount userAccount,
      String sessionId, Map<String, String> cookies) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save login state
      await prefs.setBool(_isLoggedInKey, true);

      // Save user data
      final userData = {
        'firstName': userAccount.firstName,
        'lastName': userAccount.lastName,
        'email': userAccount.email,
        'fullName': userAccount.fullName,
        'userImagePath': userAccount.userImagePath,
      };
      await prefs.setString(_userDataKey, jsonEncode(userData));

      // Save session ID
      await prefs.setString(_sessionIdKey, sessionId);

      // Save cookies
      await prefs.setString(_cookiesKey, jsonEncode(cookies));

      return true;
    } catch (e) {
      print('Error saving login session: $e');
      return false;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  // Load user session
  static Future<Map<String, dynamic>?> loadUserSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if user is logged in
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      if (!isLoggedIn) {
        return null;
      }

      // Load user data
      final userDataString = prefs.getString(_userDataKey);
      if (userDataString == null) {
        return null;
      }

      final userData = jsonDecode(userDataString) as Map<String, dynamic>;

      // Create UserAccount instance
      UserAccount.loadFromUserData(userData);

      // Load session ID
      final sessionId = prefs.getString(_sessionIdKey) ?? '';

      // Load cookies
      final cookiesString = prefs.getString(_cookiesKey) ?? '{}';
      final cookies = Map<String, String>.from(jsonDecode(cookiesString));

      return {
        'userData': userData,
        'sessionId': sessionId,
        'cookies': cookies,
      };
    } catch (e) {
      print('Error loading user session: $e');
      return null;
    }
  }

  // Clear login session (logout)
  static Future<bool> clearLoginSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_isLoggedInKey);
      await prefs.remove(_userDataKey);
      await prefs.remove(_sessionIdKey);
      await prefs.remove(_cookiesKey);

      // Clear user account instance
      UserAccount.clearInstance();

      return true;
    } catch (e) {
      print('Error clearing login session: $e');
      return false;
    }
  }
}
