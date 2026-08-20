import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';
import 'firestore_providers.dart';

/// Represents an appointment stored in Firestore.
///
/// Unlike the local `Appointment` in booking_provider.dart, this one is
/// loaded from the `appointments` collection and linked to a user.
class StoredAppointment {
  final String id;
  final String doctorId;
  final String doctorName;
  final String day;
  final String time;
  final String status;

  const StoredAppointment({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.day,
    required this.time,
    required this.status,
  });

  /// Creates a StoredAppointment from a Firestore document map.
  factory StoredAppointment.fromMap(String id, Map<String, dynamic> map) {
    return StoredAppointment(
      id: id,
      doctorId: map['doctorId'] as String? ?? '',
      doctorName: map['doctorName'] as String? ?? '',
      day: map['day'] as String? ?? '',
      time: map['time'] as String? ?? '',
      status: map['status'] as String? ?? 'confirmed',
    );
  }
}

/// Streams the logged-in user's upcoming appointments from Firestore.
///
/// Why StreamProvider? Like doctors/facilities, this listens to realtime
/// updates — when a booking is confirmed, the Profile screen updates
/// automatically.
final myAppointmentsProvider = StreamProvider<List<StoredAppointment>>((ref) {
  final db = ref.watch(firestoreProvider);
  final user = ref.watch(authStateProvider).value;

  // If not logged in, emit an empty list.
  if (user == null) {
    return Stream.value(const []);
  }

  // Keep this query to a single where filter. Combining this filter with an
  // orderBy requires a composite Firestore index and otherwise makes the
  // profile stream fail after a booking is created.
  return db
      .collection('appointments')
      .where('userId', isEqualTo: user.uid)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => StoredAppointment.fromMap(doc.id, doc.data()))
            .toList(),
      );
});

/// Saves a confirmed appointment to the Firestore `appointments` collection.
///
/// The appointment is linked to the logged-in user via their `uid`, so the
/// Profile screen can query "my appointments" with a simple `where` filter.
///
/// Returns the new document ID (used as the appointment ID on the
/// confirmation screen).
Future<String> saveAppointmentToFirestore({
  required String doctorId,
  required String doctorName,
  required String day,
  required String time,
}) async {
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  // Guard: the user must be logged in to book (enforced by the router
  // redirect, but double-check here too).
  if (user == null) {
    throw StateError('You must be logged in to book an appointment');
  }

  final docRef = await db.collection('appointments').add({
    'doctorId': doctorId,
    'doctorName': doctorName,
    'userId': user.uid,
    'day': day,
    'time': time,
    'status': 'confirmed',
    // Server timestamp lets us sort "upcoming" appointments by recency.
    'createdAt': FieldValue.serverTimestamp(),
  });

  return docRef.id;
}
