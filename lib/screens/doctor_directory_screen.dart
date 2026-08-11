import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/doctor.dart';
import '../widgets/doctor_card.dart';

/// Doctor Directory screen (Day 2).
///
/// Shows a searchable list of doctors. Data is hardcoded test data for now;
/// on Day 4 it will be replaced by a live Firestore query via a Riverpod
/// StreamProvider.
class DoctorDirectoryScreen extends StatefulWidget {
  const DoctorDirectoryScreen({super.key});

  @override
  State<DoctorDirectoryScreen> createState() => _DoctorDirectoryScreenState();
}

class _DoctorDirectoryScreenState extends State<DoctorDirectoryScreen> {
  // Hardcoded test data — replaced by Firestore on Day 4.
  static const List<Doctor> _allDoctors = [
    Doctor(
      id: 'd1',
      name: 'Dr. Abebe Kebede',
      specialization: 'Cardiologist',
      experience: 15,
      facilityName: 'Addis General Hospital',
      fee: 1500,
      rating: 4.8,
      photoUrl: '',
    ),
    Doctor(
      id: 'd2',
      name: 'Dr. Sara Ahmed',
      specialization: 'Pediatrician',
      experience: 10,
      facilityName: 'Addis General Hospital',
      fee: 1200,
      rating: 4.6,
      photoUrl: '',
    ),
    Doctor(
      id: 'd3',
      name: 'Dr. Dawit Haile',
      specialization: 'Dermatologist',
      experience: 8,
      facilityName: 'Central Diagnostic Lab',
      fee: 1000,
      rating: 4.3,
      photoUrl: '',
    ),
    Doctor(
      id: 'd4',
      name: 'Dr. Hanna Tesfaye',
      specialization: 'Gynecologist',
      experience: 12,
      facilityName: 'Neighborhood Pharmacy',
      fee: 1300,
      rating: 4.7,
      photoUrl: '',
    ),
    Doctor(
      id: 'd5',
      name: 'Dr. Yonas Girma',
      specialization: 'General Physician',
      experience: 6,
      facilityName: 'Addis General Hospital',
      fee: 800,
      rating: 4.2,
      photoUrl: '',
    ),
    Doctor(
      id: 'd6',
      name: 'Dr. Meron Bekele',
      specialization: 'Neurologist',
      experience: 14,
      facilityName: 'Central Diagnostic Lab',
      fee: 1800,
      rating: 4.9,
      photoUrl: '',
    ),
  ];

  String _searchQuery = '';

  /// Filters the hardcoded list by name or specialization as the user types.
  List<Doctor> get _filteredDoctors {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return _allDoctors;
    return _allDoctors.where((d) {
      return d.name.toLowerCase().contains(query) ||
          d.specialization.toLowerCase().contains(query) ||
          d.facilityName.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredDoctors;

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
          // Doctor list
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
                            context.push('/doctor-profile', extra: doctor);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}