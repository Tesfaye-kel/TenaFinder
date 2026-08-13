// ignore_for_file: avoid_print
// This is a one-time CLI seed script; print() is appropriate here.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/// One-time seed script for the TenaFinder Firestore database.
///
/// Run from the project root with:
///   dart run tool/seed_firestore.dart
///
/// This creates the `facilities` and `doctors` collections with test data.
Future<void> main() async {
  // Initialize Firebase (reads google-services.json on Android).
  await Firebase.initializeApp();

  final db = FirebaseFirestore.instance;

  print('Seeding facilities...');
  final facilities = [
    {
      'name': 'Addis General Hospital',
      'category': 'hospital',
      'rating': 4.6,
      'distanceKm': 1.2,
      'latitude': 9.0108,
      'longitude': 38.7612,
      'isOpen': true,
      'address': 'Bole Road, Addis Ababa',
    },
    {
      'name': 'Neighborhood Pharmacy',
      'category': 'pharmacy',
      'rating': 4.3,
      'distanceKm': 0.8,
      'latitude': 9.0245,
      'longitude': 38.7467,
      'isOpen': true,
      'address': 'Megenagna, Addis Ababa',
    },
    {
      'name': 'Central Diagnostic Lab',
      'category': 'lab',
      'rating': 4.1,
      'distanceKm': 2.4,
      'latitude': 9.0082,
      'longitude': 38.7714,
      'isOpen': false,
      'address': 'Kazanchis, Addis Ababa',
    },
    {
      'name': 'St. Mary Clinic',
      'category': 'hospital',
      'rating': 4.5,
      'distanceKm': 3.1,
      'latitude': 9.0306,
      'longitude': 38.7352,
      'isOpen': true,
      'address': 'Piassa, Addis Ababa',
    },
    {
      'name': 'City Care Pharmacy',
      'category': 'pharmacy',
      'rating': 4.0,
      'distanceKm': 1.8,
      'latitude': 9.0129,
      'longitude': 38.7552,
      'isOpen': true,
      'address': 'Bole Medhanialem, Addis Ababa',
    },
  ];

  for (final facility in facilities) {
    await db.collection('facilities').add(facility);
    print('  Added: ${facility['name']}');
  }

  print('Seeding doctors...');
  final doctors = [
    {
      'name': 'Dr. Abebe Kebede',
      'specialization': 'Cardiologist',
      'experience': 15,
      'facilityName': 'Addis General Hospital',
      'fee': 1500,
      'rating': 4.8,
      'photoUrl': '',
    },
    {
      'name': 'Dr. Sara Ahmed',
      'specialization': 'Pediatrician',
      'experience': 10,
      'facilityName': 'Addis General Hospital',
      'fee': 1200,
      'rating': 4.6,
      'photoUrl': '',
    },
    {
      'name': 'Dr. Dawit Haile',
      'specialization': 'Dermatologist',
      'experience': 8,
      'facilityName': 'Central Diagnostic Lab',
      'fee': 1000,
      'rating': 4.3,
      'photoUrl': '',
    },
    {
      'name': 'Dr. Hanna Tesfaye',
      'specialization': 'Gynecologist',
      'experience': 12,
      'facilityName': 'St. Mary Clinic',
      'fee': 1300,
      'rating': 4.7,
      'photoUrl': '',
    },
    {
      'name': 'Dr. Yonas Girma',
      'specialization': 'General Physician',
      'experience': 6,
      'facilityName': 'Addis General Hospital',
      'fee': 800,
      'rating': 4.2,
      'photoUrl': '',
    },
  ];

  for (final doctor in doctors) {
    await db.collection('doctors').add(doctor);
    print('  Added: ${doctor['name']}');
  }

  print('Done! Seeded 5 facilities and 5 doctors.');
}
