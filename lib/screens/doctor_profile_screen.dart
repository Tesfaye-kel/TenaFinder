import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../models/doctor.dart';
import '../providers/booking_provider.dart';

/// Doctor Profile screen (Day 3).
///
/// Shows a doctor's full details and a "Book appointment" button that
/// starts the booking flow. The selected doctor is saved to the Riverpod
/// `bookingProvider` so the booking screens can read it.
class DoctorProfileScreen extends ConsumerWidget {
  final Doctor doctor;

  const DoctorProfileScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Doctor header: avatar + name + rating
          Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
                child: doctor.photoUrl.isEmpty
                    ? Text(
                        doctor.name.isNotEmpty
                            ? doctor.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      )
                    : ClipOval(
                        child: Image.network(
                          doctor.photoUrl,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor.specialization,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          doctor.rating.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.work_outline,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${doctor.experience} yrs exp',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Details card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _DetailRow(
                    icon: Icons.local_hospital_outlined,
                    label: 'Facility',
                    value: doctor.facilityName,
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    icon: Icons.attach_money,
                    label: 'Consultation Fee',
                    value: 'ETB ${doctor.fee.toStringAsFixed(0)}',
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    icon: Icons.verified_outlined,
                    label: 'Experience',
                    value: '${doctor.experience} years',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Book appointment button
          FilledButton.icon(
            onPressed: () {
              // Save the selected doctor to shared booking state, then
              // navigate to the booking screen.
              ref.read(bookingProvider.notifier).selectDoctor(doctor);
              context.push('/booking');
            },
            icon: const Icon(Icons.calendar_month),
            label: const Text('Book appointment'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A single label/value row inside the details card.
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}