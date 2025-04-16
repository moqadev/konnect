/*
@author: Omar
@date: 2025-03-09
@Developed by: Omar Nasr (https://moqa.dev)
@contact: omar@moqa.dev
*/
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  bool _isCheckedIn = false;
  bool _isCheckedOut = false;
  bool _isSliding = false;
  double _slideValue = 0.0;
  String _checkInStatus = 'Slide to check in';
  Timer? _resetTimer;

  // Google Maps related variables
  final Completer<GoogleMapController> _mapController = Completer();
  final Location _locationService = Location();
  LocationData? _currentLocation;
  final Set<Marker> _markers = {};
  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(
        37.42796133580664, -122.085749655962), // Default position (Google HQ)
    zoom: 14.0,
  );

  // Office location (example)
  final LatLng _officeLocation =
      const LatLng(37.42796133580664, -122.085749655962);

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  // Check and request location permissions
  Future<void> _checkLocationPermission() async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await _locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationService.requestService();
        if (!serviceEnabled) {
          // Location services are not enabled
          _showLocationServiceDialog();
          return;
        }
      }

      // Check location permission
      PermissionStatus permissionStatus =
          await _locationService.hasPermission();
      if (permissionStatus == PermissionStatus.denied) {
        permissionStatus = await _locationService.requestPermission();
        if (permissionStatus != PermissionStatus.granted) {
          // Location permissions are denied
          _showLocationPermissionDialog();
          return;
        }
      }

      // Initialize location service if permissions are granted
      _initLocationService();
    } catch (e) {
      print("Error checking location permission: $e");
      // Show a generic error dialog
      _showErrorDialog("Permission Error",
          "There was an error checking location permissions. Please try again.");
    }
  }

  // Show dialog when location service is disabled
  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Service Required'),
          content: const Text(
            'This app needs location services to be enabled for the check-in functionality. '
            'Please enable location services in your device settings.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _locationService.requestService();
              },
              child: const Text('Enable Location'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Show dialog to explain why location is needed
  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text(
            'This app needs access to your location for the check-in functionality. '
            'Please grant location permission in your device settings.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _locationService.requestPermission();
              },
              child: const Text('Grant Permission'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Show generic error dialog
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Initialize location service
  Future<void> _initLocationService() async {
    await _locationService.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
    );

    try {
      bool serviceEnabled = await _locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationService.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      // Get current location
      _currentLocation = await _locationService.getLocation();

      // Add office marker
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('office'),
            position: _officeLocation,
            infoWindow: const InfoWindow(
              title: 'Office Location',
              snippet: '123 Business Park, Floor 5, Room 502',
            ),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );
      });

      // Start location updates
      _locationService.onLocationChanged.listen((LocationData locationData) {
        if (mounted) {
          setState(() {
            _currentLocation = locationData;

            // Update user marker
            _markers.removeWhere((marker) => marker.markerId.value == 'user');
            _markers.add(
              Marker(
                markerId: const MarkerId('user'),
                position:
                    LatLng(locationData.latitude!, locationData.longitude!),
                infoWindow: const InfoWindow(
                  title: 'Your Location',
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
              ),
            );
          });
        }
      });

      // Move camera to current location
      if (_currentLocation != null) {
        _moveToCurrentLocation();
      }
    } catch (e) {
      print("Error initializing location service: $e");
      // Show error dialog if appropriate
      if (mounted) {
        _showErrorDialog("Location Error",
            "Failed to initialize location services. Please check your device settings and try again.");
      }
    }
  }

  // Move camera to current location
  Future<void> _moveToCurrentLocation() async {
    if (_currentLocation != null) {
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        ),
      );
    }
  }

  void _handleSlideComplete() {
    setState(() {
      _isSliding = false;

      if (!_isCheckedIn) {
        // Handle check-in
        _isCheckedIn = true;
        _checkInStatus = 'Checked in successfully!';
        _showSuccessDialog('Check-In Successful!',
            'You have checked in at ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}');
      } else {
        // Handle check-out
        _isCheckedOut = true;
        _checkInStatus = 'Checked out successfully!';
        _showSuccessDialog('Check-Out Successful!',
            'You have checked out at ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}');
      }
    });

    // Reset after 3 seconds
    _resetTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _slideValue = 0.0;
          if (_isCheckedIn && !_isCheckedOut) {
            _checkInStatus = 'Slide to check out';
          } else if (_isCheckedOut) {
            _checkInStatus = 'You are done for today';
          }
        });
      }
    });
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1a73e8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                  ),
                  child: const Text(
                    'OK',
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

  @override
  Widget build(BuildContext context) {
    // Determine the colors based on check-in/check-out status
    Color primaryColor = _isCheckedOut
        ? Colors.orange
        : (_isCheckedIn ? Colors.green : const Color(0xFF1a73e8));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _isCheckedIn && !_isCheckedOut ? 'Check Out' : 'Check In',
          style: const TextStyle(
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
          // Map section
          Expanded(
            child: Stack(
              children: [
                // Google Map with error handling
                Builder(
                  builder: (context) {
                    try {
                      return GoogleMap(
                        initialCameraPosition: _initialCameraPosition,
                        markers: _markers,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        mapToolbarEnabled: false,
                        compassEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                          _mapController.complete(controller);

                          // Move to current location if available
                          if (_currentLocation != null) {
                            _moveToCurrentLocation();
                          }
                        },
                      );
                    } catch (e) {
                      // If map fails to load, show a placeholder with error message
                      print("Error initializing Google Map: $e");
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.map_outlined,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Map unavailable",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0),
                                child: Text(
                                  "Please check your location settings and try again",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  // Try to initialize location again
                                  _checkLocationPermission();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),

                // Current location button
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.white,
                    onPressed: () {
                      _moveToCurrentLocation();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Centering on current location'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Check-in section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Location info
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: primaryColor,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Office Location',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '123 Business Park, Floor 5, Room 502',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Current time
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.access_time,
                        color: Colors.orange,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Time',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        StreamBuilder(
                          stream: Stream.periodic(const Duration(seconds: 1)),
                          builder: (context, snapshot) {
                            return Text(
                              '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Check-in status display
                if (_isCheckedIn && !_isCheckedOut && _slideValue == 0.0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Currently Checked In',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Since ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Slide to check in/out
                if (!_isCheckedOut)
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Stack(
                      children: [
                        // Slide progress
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width:
                              MediaQuery.of(context).size.width * _slideValue,
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),

                        // Slide text
                        Center(
                          child: Text(
                            _checkInStatus,
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),

                        // Slider thumb
                        Positioned(
                          left: _isSliding
                              ? (MediaQuery.of(context).size.width - 80) *
                                  _slideValue
                              : 0,
                          top: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onHorizontalDragStart: (details) {
                              if (!_isCheckedOut) {
                                setState(() {
                                  _isSliding = true;
                                });
                              }
                            },
                            onHorizontalDragUpdate: (details) {
                              if (!_isCheckedOut) {
                                setState(() {
                                  _slideValue = (_slideValue +
                                          details.delta.dx /
                                              (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  80))
                                      .clamp(0.0, 1.0);

                                  if (_slideValue > 0.1) {
                                    _checkInStatus = _isCheckedIn
                                        ? 'Checking out...'
                                        : 'Checking in...';
                                  }

                                  if (_slideValue >= 0.9) {
                                    _handleSlideComplete();
                                  }
                                });
                              }
                            },
                            onHorizontalDragEnd: (details) {
                              if (!_isCheckedOut && _slideValue < 0.9) {
                                setState(() {
                                  _slideValue = 0.0;
                                  _isSliding = false;
                                  _checkInStatus = _isCheckedIn
                                      ? 'Slide to check out'
                                      : 'Slide to check in';
                                });
                              }
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _isCheckedIn ? Icons.logout : Icons.login,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Checked out message
                if (_isCheckedOut)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: Colors.orange,
                          size: 50,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'You have completed your day',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Thank you for your work today!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
