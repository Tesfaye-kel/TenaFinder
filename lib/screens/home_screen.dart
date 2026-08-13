import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/facility.dart';
import '../providers/firestore_providers.dart';
import '../services/location_service.dart';
import '../widgets/category_card.dart';
import '../widgets/facility_card.dart';

/// The Home screen (Day 5).
///
/// Facilities come live from Firestore. Distances are calculated from the
/// user's real GPS position (Haversine formula) instead of hardcoded values.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final LocationService _locationService = LocationService();
  Position? _userPosition;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  /// Gets the user's GPS position once on app start.
  Future<void> _getUserLocation() async {
    final position = await _locationService.getCurrentPosition();
    if (!mounted) return;
    setState(() {
      _userPosition = position;
    });
  }

  /// Returns the distance to show on a facility card (live or fallback).
  double _distanceFor(Facility facility) {
    final user = _userPosition;
    if (user != null) {
      return LocationService.distanceKm(
        user,
        facility.latitude,
        facility.longitude,
      );
    }
    // Fallback to the stored Firestore distance if GPS unavailable.
    return facility.distanceKm;
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesAsync = ref.watch(facilitiesStreamProvider);

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
              // TODO: Navigate to the Profile screen once Authentication
              // is implemented (Firebase Auth).
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

          // Facilities from Firestore (loading / error / data states)
          facilitiesAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.cloud_off,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Could not load facilities',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            data: (facilities) => Column(
              children: [
                for (final facility in facilities)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: FacilityCard(
                      facility: facility,
                      // Override the distance with the live GPS value.
                      displayDistanceKm: _distanceFor(facility),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
