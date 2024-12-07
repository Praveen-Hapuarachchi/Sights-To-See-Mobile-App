import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/place.dart';

class PlacesPage extends StatelessWidget {
  final String district;
  final String mode;

  const PlacesPage({
    super.key,
    required this.district,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Places'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('places').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching places'));
          }

          final places = snapshot.data?.docs.map((doc) {
            return Place.fromFirestore(doc);
          }).toList() ?? [];

          final filteredPlaces = places.where((place) {
            return place.district == district &&
                place.placeType.toString().split('.').last.toLowerCase() ==
                    mode.toLowerCase();
          }).toList();

          return filteredPlaces.isNotEmpty
              ? ListView.builder(
                  itemCount: filteredPlaces.length,
                  itemBuilder: (context, index) {
                    final place = filteredPlaces[index];
                    return Card(
                      child: ListTile(
                        leading: Image.network(place.imageUrl),
                        title: Text(place.name),
                        subtitle: Text(place.description),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text('No places found for the selected district and mode.'),
                );
        },
      ),
    );
  }
}
