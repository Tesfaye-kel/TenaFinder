/// Model representing a doctor.
///
/// Populated from a Firestore `doctors` collection (via `fromMap()`).
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

  /// Creates a Doctor from a Firestore document map.
  ///
  /// `id` comes from the document ID; the rest from the data fields.
  factory Doctor.fromMap(String id, Map<String, dynamic> map) {
    return Doctor(
      id: id,
      name: map['name'] as String? ?? '',
      specialization: map['specialization'] as String? ?? '',
      experience: (map['experience'] as num?)?.toInt() ?? 0,
      facilityName: map['facilityName'] as String? ?? '',
      fee: (map['fee'] as num?)?.toDouble() ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      photoUrl: map['photoUrl'] as String? ?? '',
    );
  }

  /// Converts this Doctor to a Firestore document map (for seeding/writing).
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialization': specialization,
      'experience': experience,
      'facilityName': facilityName,
      'fee': fee,
      'rating': rating,
      'photoUrl': photoUrl,
    };
  }
}
