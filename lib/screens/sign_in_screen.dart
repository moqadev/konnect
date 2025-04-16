/*
@author: Omar
@date: 2025-03-09
@Developed by: Omar Nasr (https://moqa.dev)
@contact: omar@moqa.dev
*/
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';
import '../models/user_account.dart';
import '../services/session_manager.dart';

// Create a global client to maintain cookies between requests
final http.Client _client = http.Client();
// Store session cookies
Map<String, String> _cookies = {};

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  final LocalAuthentication _localAuth = LocalAuthentication();
  String _responseMessage = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Login with API
  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Please enter both email and password');
      return;
    }

    setState(() {
      _isLoading = true;
      _responseMessage = '';
    });

    try {
      // Create request with headers
      final request = http.Request(
          'POST',
          Uri.parse(
              'https://cben-dev.homains.online/api/method/homains_devops.auth.login'));

      // Set up common headers
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'Flutter/1.0',
        'X-Requested-With': 'XMLHttpRequest',
      });

      // Add any existing cookies to maintain session
      if (_cookies.isNotEmpty) {
        request.headers['Cookie'] = _generateCookieHeader();
      }

      request.body = jsonEncode({
        'usr': email,
        'pwd': password,
      });

      // Send the request using the client
      final streamedResponse = await _client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      // Store cookies from the response
      _updateCookies(response);

      // Store response for debugging
      final responseBody = response.body;
      print('API Response Status Code: ${response.statusCode}');
      print('API Response Body: $responseBody');
      print('Response Headers: ${response.headers}');
      print('Cookies after login: $_cookies');

      setState(() {
        _isLoading = false;
        _responseMessage = responseBody;
      });

      // For debugging: Show response dialog
      _showResponseDebugDialog(responseBody);

      try {
        // Parse the response
        final responseData = jsonDecode(responseBody);
        print('Parsed response data: $responseData');

        // Check if success field exists in the nested message object
        if (responseData.containsKey('message') &&
            responseData['message'] is Map &&
            responseData['message'].containsKey('success') &&
            responseData['message']['success'] == 1 &&
            responseData['message'].containsKey('message') &&
            responseData['message']['message'] == 'Authentication Success') {
          // Extract the session ID if present and store it
          String sessionId = '';
          if (responseData['message'].containsKey('sid')) {
            sessionId = responseData['message']['sid'];
            _cookies['sid'] = sessionId;
            print('Extracted SID from response: $sessionId');
          }

          // Show success dialog and navigate to home screen
          if (mounted) {
            _showSuccessDialog();
          }
        } else {
          // Show error dialog for invalid credentials
          if (mounted) {
            _showErrorDialog('Invalid Data');
          }
        }
      } catch (parseError) {
        print('Error parsing JSON response: $parseError');
        _showErrorDialog('Error parsing response: $parseError');
      }
    } catch (e) {
      print('API call error: $e');
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error: ${e.toString()}');
    }
  }

  // Fetch user account data
  Future<void> _fetchUserAccount() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Create request with headers
      final request = http.Request(
          'GET',
          Uri.parse(
              'https://cben-dev.homains.online/api/method/homains_devops.auth.account'));

      // Set up common headers
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'Flutter/1.0',
        'X-Requested-With': 'XMLHttpRequest',
      });

      // Add cookies to maintain session
      if (_cookies.isNotEmpty) {
        request.headers['Cookie'] = _generateCookieHeader();

        // If we have a session ID, also add it as a special header
        if (_cookies.containsKey('sid')) {
          request.headers['X-Frappe-Session-Id'] = _cookies['sid']!;
        }
      }

      print('Request headers for account API: ${request.headers}');

      // Send the request using the client
      final streamedResponse = await _client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      // Update cookies from the response
      _updateCookies(response);

      print('Account API Response Status Code: ${response.statusCode}');
      print('Account API Response Body: ${response.body}');
      print('Account API Response Headers: ${response.headers}');
      print('Cookies after account fetch: $_cookies');

      // Debug: Print the keys in the response JSON to help identify structure
      try {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        print('JSON keys: ${jsonData.keys.toList()}');

        if (jsonData.containsKey('message') && jsonData['message'] is Map) {
          print('Message keys: ${(jsonData['message'] as Map).keys.toList()}');
        }

        if (jsonData.containsKey('user_image')) {
          print(
              'Found user_image directly in response: ${jsonData['user_image']}');
        }
      } catch (e) {
        print('Error parsing response for debug: $e');
      }

      // For debugging: Show response dialog
      _showResponseDebugDialog(response.body);

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        try {
          // Load the user account data
          UserAccount.loadFromJson(response.body);
          print(
              'User Account loaded: ${UserAccount.instance.firstName} ${UserAccount.instance.lastName}');
          print('User Image Path: ${UserAccount.instance.userImagePath}');
          print('Full Image URL: ${UserAccount.instance.fullImageUrl}');

          // Save the user session if remember me is checked
          if (_rememberMe) {
            String sessionId = _cookies['sid'] ?? '';
            await SessionManager.saveLoginSession(UserAccount.instance,
                sessionId, Map<String, String>.from(_cookies));
            print('User session saved with remember me option');
          }

          // Navigate to home screen
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        } catch (parseError) {
          print('Error parsing account data: $parseError');
          _showErrorDialog('Error parsing account data: $parseError');
        }
      } else {
        // Show error dialog if account data fetch fails
        if (mounted) {
          _showErrorDialog(
              'Failed to fetch account data. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Account API error: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        _showErrorDialog('Error: ${e.toString()}');
      }
    }
  }

  // Helper method to update cookies from a response
  void _updateCookies(http.Response response) {
    String? allSetCookie = response.headers['set-cookie'];
    if (allSetCookie != null) {
      print('Set-Cookie header: $allSetCookie');

      // Since set-cookie can come in multiple formats, let's handle each part carefully
      // First, we'll try to extract using the standard format
      List<String> setCookieList = [];

      // Some servers send multiple Set-Cookie headers concatenated with comma or newline
      // Try splitting by both in case the server uses either format
      if (allSetCookie.contains(',')) {
        setCookieList = allSetCookie.split(',');
      } else if (allSetCookie.contains('\n')) {
        setCookieList = allSetCookie.split('\n');
      } else {
        setCookieList = [allSetCookie];
      }

      for (var cookie in setCookieList) {
        cookie = cookie.trim();

        // Skip empty cookies
        if (cookie.isEmpty) continue;

        // Extract the name-value part (before the first semicolon)
        int firstSemiColon = cookie.indexOf(';');
        String nameValueStr;

        if (firstSemiColon != -1) {
          nameValueStr = cookie.substring(0, firstSemiColon);
        } else {
          nameValueStr = cookie;
        }

        // Split name=value
        int equalsSign = nameValueStr.indexOf('=');
        if (equalsSign > 0) {
          String name = nameValueStr.substring(0, equalsSign).trim();
          String value = nameValueStr.substring(equalsSign + 1).trim();

          // Skip empty or special cookies
          if (name.isEmpty ||
              name.startsWith('__Secure-') ||
              name.startsWith('__Host-')) continue;

          // Store the cookie
          _cookies[name] = value;
          print('Stored cookie: $name=$value');
        }
      }

      // Look for 'sid' specifically, as this is often the session ID
      String? sid = response.headers['x-frappe-session-id'] ??
          response.headers['x-sid'] ??
          _extractSidFromSetCookie(allSetCookie);

      if (sid != null && sid.isNotEmpty) {
        _cookies['sid'] = sid;
        print('Found session ID: $sid');
      }
    }

    // Also check for any session ID in the response body (some APIs return it there)
    try {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('message') &&
          responseBody['message'] is Map &&
          responseBody['message'].containsKey('sid')) {
        String sid = responseBody['message']['sid'];
        _cookies['sid'] = sid;
        print('Found session ID in response body: $sid');
      }
    } catch (e) {
      // Ignore if we can't parse the body
    }
  }

  // Extract SID from cookie string
  String? _extractSidFromSetCookie(String setCookie) {
    // Look for sid= or sid: in the cookie string
    RegExp sidRegex = RegExp(r'sid=([^;]+)');
    Match? match = sidRegex.firstMatch(setCookie);
    if (match != null && match.groupCount >= 1) {
      return match.group(1);
    }
    return null;
  }

  // Helper method to generate a cookie header from the stored cookies
  String _generateCookieHeader() {
    return _cookies.entries.map((e) => '${e.key}=${e.value}').join('; ');
  }

  // Show success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1a73e8), Color(0xFF4285F4)],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF1a73e8),
                    size: 60,
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Login Success',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Welcome to HR Payroll App',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    _fetchUserAccount(); // Fetch user account data before navigating
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1a73e8),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Go to Dashboard',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.red.shade700,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  message == 'Invalid Data' ? 'Invalid Data' : 'Error',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  message == 'Invalid Data'
                      ? 'Please check your credentials and try again.'
                      : message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Authenticate with biometrics
  Future<void> _authenticateWithBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await _localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }

    if (!canCheckBiometrics) {
      // Show a snackbar if biometrics are not available
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Biometric authentication is not available on this device.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }

    if (availableBiometrics.isEmpty) {
      // Show a snackbar if no biometrics are enrolled
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No biometrics are enrolled on this device.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    bool authenticated = false;
    try {
      authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to sign in',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (authenticated && mounted) {
      // Navigate to home screen on successful authentication
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  // Debug dialog to show raw API response
  void _showResponseDebugDialog(String responseBody) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'API Response Debug',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: SingleChildScrollView(
                    child: Text(
                      responseBody,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App bar with back button and title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance for back button
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // Welcome text
                    const Center(
                      child: Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1a73e8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'Sign in to continue',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Email field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'johndoe@mail.com',
                          prefixIcon:
                              Icon(Icons.email, color: Color(0xFF1a73e8)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: '********************',
                          prefixIcon:
                              Icon(Icons.lock, color: Color(0xFF1a73e8)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Remember me and Forgot password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                              activeColor: const Color(0xFF1a73e8),
                            ),
                            const Text(
                              'Remember me',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle forgot password
                          },
                          child: const Text(
                            'Forget password ?',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Sign in button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1a73e8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                'Sign in',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Biometric authentication option
                    Center(
                      child: TextButton.icon(
                        onPressed: _authenticateWithBiometrics,
                        icon: const Icon(
                          Icons.fingerprint,
                          color: Color(0xFF1a73e8),
                          size: 28,
                        ),
                        label: const Text(
                          'Sign in with biometrics',
                          style: TextStyle(
                            color: Color(0xFF1a73e8),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Progress indicator
                    const SizedBox(height: 40),
                    Center(
                      child: Container(
                        width: 120,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1a73e8),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
