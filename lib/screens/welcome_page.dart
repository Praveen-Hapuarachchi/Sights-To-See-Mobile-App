import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Logger logger = Logger('WelcomePage'); // Set up logger

  String selectedMode = 'Enjoying'; // Default value for the mode selection
  String? firstName;
  String? selectedDistrict; // Variable to store the selected district

  final List<String> districts = [
    'Colombo',
    'Gampaha',
    'Kalutara',
    'Kandy',
    'Matale',
    'Nuwara Eliya',
    'Galle',
    'Matara',
    'Hambantota',
    'Jaffna',
    'Kilinochchi',
    'Mannar',
    'Vavuniya',
    'Mullaitivu',
    'Batticaloa',
    'Ampara',
    'Trincomalee',
    'Polonnaruwa',
    'Badulla',
    'Moneragala',
    'Kegalle',
    'Ratnapura',
    'Puttalam',
    'Anuradhapura'
  ];

  final List<String> types = [
    'Religious', 'Hiking', 'Beach', 'Adventure', 'Cultural', 'Eco-Tourism', 
    'Nature', 'Food Tour', 'Wildlife Safari', 'Enjoying' // Add 'Enjoying' to the list
  ];

  @override
  void initState() {
    super.initState();
    _setupLogging(); // Configure logging
    _fetchUserFirstName();
  }

  void _setupLogging() {
    Logger.root.level = Level.ALL; // Set logging level
    Logger.root.onRecord.listen((record) {
      debugPrint(
          '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
    });
  }

  Future<void> _fetchUserFirstName() async {
    try {
      final User? user = auth.currentUser;
      if (user != null) {
        final DocumentSnapshot userDoc =
            await firestore.collection('users').doc(user.uid).get();
        setState(() {
          firstName = userDoc['first_name'];
        });
      }
    } catch (e) {
      logger.severe('Error fetching user first name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Sights to See!',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 10),
              if (firstName != null) ...[
                Text(
                  'Hi, $firstName!',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ] else ...[
                const CircularProgressIndicator(), // Show a loading indicator while fetching
              ],
              const SizedBox(height: 20),
              
              // Dropdown for selecting district
              DropdownButton<String>(
                hint: const Text('Select your district'),
                value: selectedDistrict,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDistrict = newValue;
                  });
                },
                items: districts.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              
              // Dropdown for selecting mode
              DropdownButton<String>(
                value: selectedMode,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMode = newValue!;
                  });
                },
                items: types.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: () {
                  if (selectedDistrict != null) {
                    // Handle form submission
                    // For example, navigate to a new page with the selected values
                    Navigator.pushNamed(
                      context, 
                      '/places', 
                      arguments: {'district': selectedDistrict, 'mode': selectedMode}
                    );
                  } else {
                    // Show a snackbar if any field is missing
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select both district and mode.'))
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Submit'),
              ),
              const SizedBox(height: 20),
              
              // Log Out button
              ElevatedButton(
                onPressed: () {
                  auth.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Log Out'),
              ),
              const SizedBox(height: 20),
              
              // "See All Places" button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/all_places');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('See All Places'),
              ),
              const SizedBox(height: 20),
              
              // "Add Place" button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/add_place');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Add Place'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
