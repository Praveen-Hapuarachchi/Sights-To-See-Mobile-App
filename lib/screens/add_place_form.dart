import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sights_to_see/models/place.dart'; // Import Place and PlaceType

class AddPlaceForm extends StatefulWidget {
  const AddPlaceForm({super.key});

  @override
  AddPlaceFormState createState() => AddPlaceFormState();
}

class AddPlaceFormState extends State<AddPlaceForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  // List of districts in Sri Lanka
  final List<String> districts = [
  'Colombo', 'Gampaha', 'Kalutara', 'Kandy', 'Matale', 'Nuwara Eliya',
  'Galle', 'Matara', 'Hambantota', 'Jaffna', 'Kilinochchi', 'Mannar',
  'Vavuniya', 'Mullaitivu', 'Batticaloa', 'Ampara', 'Trincomalee',
  'Polonnaruwa', 'Badulla', 'Moneragala', 'Kegalle', 'Ratnapura', 'Puttalam', 'Anuradhapura'
];


  String? _selectedDistrict;
  PlaceType? _selectedPlaceType;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to save place to Firestore
  Future<void> savePlaceToFirestore(Place place) async {
    try {
      // Adding the place to the 'places' collection
      await _firestore.collection('places').add({
        'name': place.name,
        'description': place.description,
        'imageUrl': place.imageUrl,
        'district': place.district,
        'placeType': place.placeType.toString().split('.').last, // Saving the place type as a string
        'placeId': place.placeId, // Save the generated place ID
      });

      // Check if the widget is still mounted before showing a SnackBar
      if (mounted) {
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Place added successfully!')),
        );

        // Navigate back after saving
        Navigator.pop(context);
      }
    } catch (e) {
      // Check if the widget is still mounted before showing an error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Place'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Place Name
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Place Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Description
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Image URL
            TextField(
              controller: imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // District Dropdown
            DropdownButtonFormField<String>(
              value: _selectedDistrict,
              decoration: const InputDecoration(
                labelText: 'District',
                border: OutlineInputBorder(),
              ),
              items: districts.map((district) {
                return DropdownMenuItem<String>(
                  value: district,
                  child: Text(district),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDistrict = newValue;
                });
              },
            ),
            const SizedBox(height: 20),

            // Place Type Dropdown
            DropdownButtonFormField<PlaceType>(
              value: _selectedPlaceType,
              decoration: const InputDecoration(
                labelText: 'Place Type',
                border: OutlineInputBorder(),
              ),
              items: PlaceType.values.map((placeType) {
                return DropdownMenuItem<PlaceType>(
                  value: placeType,
                  child: Text(placeType.toString().split('.').last),
                );
              }).toList(),
              onChanged: (PlaceType? newValue) {
                setState(() {
                  _selectedPlaceType = newValue;
                });
              },
            ),
            const SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                final String name = nameController.text;
                final String description = descriptionController.text;
                final String imageUrl = imageUrlController.text;

                // Check if all fields are filled and a place type and district are selected
                if (name.isNotEmpty &&
                    description.isNotEmpty &&
                    imageUrl.isNotEmpty &&
                    _selectedDistrict != null &&
                    _selectedPlaceType != null) {
                  final newPlace = Place(
                    name: name,
                    description: description,
                    imageUrl: imageUrl,
                    district: _selectedDistrict!,
                    placeType: _selectedPlaceType!,
                  );

                  // Save the place to Firestore
                  savePlaceToFirestore(newPlace);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All fields are required!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
