import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/facility.dart';
import '../widgets/category_card.dart';
import '../widgets/facility_card.dart';

/// The Day 1 static Home screen.
///
/// No backend yet — the facilities list below is hardcoded test data.
/// On Day 4 it will come from Firestore, and on Day 5 the distance will
/// be calculated from the user's real GPS position.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Hardcoded test data — replaced by Firestore on Day 4.
  static const List<Facility> _facilities = [
    Facility(
      id: 'f1',
      name: 'Addis General Hospital',
      category: 'hospital',
      rating: 4.6,
      distanceKm: 1.2,
      isOpen: true,
      address: 'Bole Road, Addis Ababa',
    ),
    Facility(
      id: 'f2',
      name: 'Neighborhood Pharmacy',
      category: 'pharmacy',
      rating: 4.3,
      distanceKm: 0.8,
      isOpen: true,
      address: 'Megenagna, Addis Ababa',
    ),
    Facility(
      id: 'f3',
      name: 'Central Diagnostic Lab',
      category: 'lab',
      rating: 4.1,
      distanceKm: 2.4,
      isOpen: false,
      address: 'Kazanchis, Addis Ababa',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TenaFinder',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Profile',
            onPressed: () {
              // TODO(Day 6): navigate to Profile screen after Auth is added.
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---- Search bar (placeholder) ----
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search doctors, hospitals, pharmacies...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ---- Health topic + greeting ----
          Text(
            'How can we help you today?',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // ---- 4 service categories ----
          Row(
            children: [
              Expanded(
                child: CategoryCard(
                  icon: Icons.local_hospital,
                  label: 'Hospital',
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CategoryCard(
                  icon: Icons.local_pharmacy,
                  label: 'Pharmacy',
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CategoryCard(
                  icon: Icons.biotech,
                  label: 'Lab',
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CategoryCard(
                  icon: Icons.medical_services,
                  label: 'Doctors',
                  color: Colors.teal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ---- Nearby healthcare section ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nearby healthcare',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO(Day 5): open full map view / see-all list.
                },
                child: const Text('See all'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final facility in _facilities)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FacilityCard(facility: facility),
            ),
        ],
      ),
    );
  }
}