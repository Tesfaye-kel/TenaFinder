/// Model representing a healthcare facility.
///
/// Populated from a Firestore `facilities` collection (via `fromMap()`).
class Facility {
  final String id;
  final String name;
  final String category; // "hospital" | "pharmacy" | "lab" | "doctors"
  final double rating;
  final double distanceKm;
  final double latitude;
  final double longitude;
  final bool isOpen;
  final String address;

  const Facility({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.distanceKm,
    required this.latitude,
    required this.longitude,
    required this.isOpen,
    required this.address,
  });

  /// Creates a Facility from a Firestore document map.
  factory Facility.fromMap(String id, Map<String, dynamic> map) {
    return Facility(
      id: id,
      name: map['name'] as String? ?? '',
      category: map['category'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      distanceKm: (map['distanceKm'] as num?)?.toDouble() ?? 0,
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
      isOpen: map['isOpen'] as bool? ?? false,
      address: map['address'] as String? ?? '',
    );
  }

  /// Converts this Facility to a Firestore document map (for seeding/writing).
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'rating': rating,
      'distanceKm': distanceKm,
      'latitude': latitude,
      'longitude': longitude,
      'isOpen': isOpen,
      'address': address,
    };
  }
}
