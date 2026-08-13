import 'package:flutter/material.dart';

import '../models/facility.dart';

/// A rounded card displaying one healthcare facility: name, category icon,
/// rating, distance, and open/closed status.
///
/// On Day 5 the hardcoded `distanceKm` will be replaced by a live distance
/// calculated from the user's GPS position.
class FacilityCard extends StatelessWidget {
  final Facility facility;
  final VoidCallback? onTap;
  final double? displayDistanceKm;

  const FacilityCard({
    super.key,
    required this.facility,
    this.onTap,
    this.displayDistanceKm,
  });

  /// Returns a matching icon + color for each facility category.
  (IconData, Color) _categoryStyle() {
    switch (facility.category) {
      case 'hospital':
        return (Icons.local_hospital, Colors.redAccent);
      case 'pharmacy':
        return (Icons.local_pharmacy, Colors.green);
      case 'lab':
        return (Icons.biotech, Colors.indigo);
      default:
        return (Icons.medical_services, Colors.teal);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _categoryStyle();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Category icon bubble
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              // Facility details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      facility.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          facility.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          // Use the live GPS distance if provided,
                          // otherwise fall back to the stored value.
                          '${(displayDistanceKm ?? facility.distanceKm).toStringAsFixed(1)} km',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Open/closed badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: (facility.isOpen ? Colors.green : Colors.red)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  facility.isOpen ? 'Open' : 'Closed',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: facility.isOpen
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
