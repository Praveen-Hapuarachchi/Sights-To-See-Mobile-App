import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// Enum for place types
enum PlaceType {
  enjoying,
  religious,
  hiking,
  beach,
  adventure,
  cultural,
  ecoTourism,
  nature,
  foodTour,
  wildlifeSafari,
}

class Place {
  final String placeId; // Auto-generated
  final String name;
  final String description;
  final String imageUrl;
  final String district;
  final PlaceType placeType;

  Place({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.district,
    required this.placeType,
  }) : placeId = const Uuid().v4(); // Auto-generate the ID

  // Convert Firestore document to Place object
  factory Place.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Place(
      name: data['name'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      district: data['district'],
      placeType: PlaceType.values.firstWhere(
          (e) => e.toString() == 'PlaceType.${data['placeType']}'),
    );
  }
}
