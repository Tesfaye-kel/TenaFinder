import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/doctor.dart';
import '../models/facility.dart';

/// Provides access to Firestore collections.
/// Kept as a provider so tests can override it with a fake.
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Streams all doctors from the `doctors` collection, ordered by name.
///
/// Why StreamProvider instead of FutureProvider?
/// - StreamProvider listens to Firestore's realtime updates: when a doctor
///   is added/updated/deleted in the console, the UI updates automatically
///   without the user having to refresh.
/// - FutureProvider would only fetch once and never update.
final doctorsStreamProvider = StreamProvider<List<Doctor>>((ref) {
  final db = ref.watch(firestoreProvider);
  return db
      .collection('doctors')
      .orderBy('name')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => Doctor.fromMap(doc.id, doc.data()))
            .toList(),
      );
});

/// Streams all facilities from the `facilities` collection, ordered by name.
final facilitiesStreamProvider = StreamProvider<List<Facility>>((ref) {
  final db = ref.watch(firestoreProvider);
  return db
      .collection('facilities')
      .orderBy('name')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => Facility.fromMap(doc.id, doc.data()))
            .toList(),
      );
});
