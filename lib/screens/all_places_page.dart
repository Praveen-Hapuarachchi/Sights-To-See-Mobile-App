import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sights_to_see/models/place.dart'; // Import the Place model

class AllPlacesPage extends StatefulWidget {
  const AllPlacesPage({super.key});

  @override
  AllPlacesPageState createState() => AllPlacesPageState();
}

class AllPlacesPageState extends State<AllPlacesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to fetch places from Firestore
  Future<List<Place>> fetchPlaces() async {
    try {
      // Get the documents from the 'places' collection
      QuerySnapshot snapshot = await _firestore.collection('places').get();

      // Map the documents to the Place model
      return snapshot.docs.map((doc) {
        return Place(
          name: doc['name'],
          description: doc['description'],
          imageUrl: doc['imageUrl'],
          district: doc['district'],
          placeType: PlaceType.values.firstWhere(
            (e) => e.toString().split('.').last == doc['placeType'],
            orElse: () => PlaceType.enjoying, // Default fallback
          ),
        );
      }).toList();
    } catch (e) {
      throw Exception('Error fetching places: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Places'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Place>>(
        future: fetchPlaces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No places found.'));
          } else {
            // Display the list of places
            final places = snapshot.data!;
            return ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
                return ListTile(
                  title: Text(place.name),
                  subtitle: Text(place.description),
                  trailing: Image.network(place.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                  onTap: () {
                    // Handle onTap to show place details or navigate to another screen
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
