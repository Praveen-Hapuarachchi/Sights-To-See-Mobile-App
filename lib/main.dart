import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';  // Import your firebase options
import 'package:sights_to_see/screens/welcome_page.dart'; // Import WelcomePage
import 'package:sights_to_see/screens/login_page.dart'; // Import LoginPage
import 'package:sights_to_see/screens/signup_page.dart'; // Import SignUpPage
import 'package:sights_to_see/screens/all_places_page.dart'; // Import AllPlacesPage
import 'package:sights_to_see/screens/add_place_form.dart'; // Import AddPlaceForm


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sights to See',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/welcome': (context) => const WelcomePage(),
        '/all_places': (context) => const AllPlacesPage(),
        '/add_place': (context) => const AddPlaceForm(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/welcome');
          },
          child: const Text('Go to Welcome Page'),
        ),
      ),
    );
  }
}
