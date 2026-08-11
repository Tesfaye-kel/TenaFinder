/// Model representing a doctor.
///
/// On Day 4 this will be populated from a Firestore `doctors` collection
/// (via a `fromMap()` method) instead of hardcoded test data.
class Doctor {
  final String id;
  final String name;
  final String specialization;
  final int experience; // years of experience
  final String facilityName;
  final double fee;
  final double rating;
  final String photoUrl;

  const Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.experience,
    required this.facilityName,
    required this.fee,
    required this.rating,
    required this.photoUrl,
  });
}
