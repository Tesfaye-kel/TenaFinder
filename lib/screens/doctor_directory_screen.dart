import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/doctor.dart';
import '../providers/firestore_providers.dart';
import '../widgets/doctor_card.dart';

/// Doctor Directory screen (Day 4).
///
/// Shows a searchable list of doctors pulled live from Firestore via the
/// `doctorsStreamProvider` (a Riverpod StreamProvider). The list updates
/// automatically whenever the database changes.
class DoctorDirectoryScreen extends ConsumerStatefulWidget {
  const DoctorDirectoryScreen({super.key});

  @override
  ConsumerState<DoctorDirectoryScreen> createState() =>
      _DoctorDirectoryScreenState();
}

class _DoctorDirectoryScreenState extends ConsumerState<DoctorDirectoryScreen> {
  String _searchQuery = '';

  /// Filters the live Firestore list by name, specialization, or facility.
  List<Doctor> _filterDoctors(List<Doctor> doctors) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return doctors;
    return doctors.where((d) {
      return d.name.toLowerCase().contains(query) ||
          d.specialization.toLowerCase().contains(query) ||
          d.facilityName.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the live Firestore stream of doctors.
    final doctorsAsync = ref.watch(doctorsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Find a Doctor',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search box
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search by name, specialty, or facility...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Doctor list (loading / error / data states)
          Expanded(
            child: doctorsAsync.when(
              // Loading spinner while Firestore is fetching.
              loading: () => const Center(child: CircularProgressIndicator()),
              // Error state if Firestore call fails.
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud_off,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Could not load doctors',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Check your connection and try again.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Data state: filter + display the doctors.
              data: (doctors) {
                final filtered = _filterDoctors(doctors);
                return Column(
                  children: [
                    // Results count
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${filtered.length} doctor${filtered.length == 1 ? '' : 's'} found',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 48,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No doctors found',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Try a different search term',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final doctor = filtered[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: DoctorCard(
                                    doctor: doctor,
                                    onTap: () {
                                      // Navigate to the Doctor Profile screen,
                                      // passing the doctor object via `extra`.
                                      context.push(
                                        '/doctor-profile',
                                        extra: doctor,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
