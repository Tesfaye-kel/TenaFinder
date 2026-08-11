/// Model representing a healthcare facility.
///
/// This is the hardcoded model used on Day 1. On Day 4 we'll wire it to
/// Firestore by adding `fromMap()`/`toMap()` methods that match the
/// database document fields.
class Facility {
  final String id;
  final String name;
  final String category; // "hospital" | "pharmacy" | "lab" | "doctors"
  final double rating;
  final double distanceKm;
  final bool isOpen;
  final String address;

  const Facility({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.distanceKm,
    required this.isOpen,
    required this.address,
  });
}