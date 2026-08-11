import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../providers/booking_provider.dart';

/// Confirmation screen (Day 3).
///
/// Shows the appointment ID, doctor name, and chosen date/time after a
/// successful booking. The `Appointment` object is passed via go_router's
/// `extra` parameter.
class ConfirmationScreen extends StatelessWidget {
  final Appointment appointment;

  const ConfirmationScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Confirmed'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success checkmark
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 56,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Appointment booked!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your appointment has been confirmed.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),

            // Appointment details card
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
                    _DetailRow(label: 'Appointment ID', value: appointment.id),
                    const Divider(height: 24),
                    _DetailRow(label: 'Doctor', value: appointment.doctor.name),
                    const Divider(height: 24),
                    _DetailRow(label: 'Day', value: appointment.day),
                    const Divider(height: 24),
                    _DetailRow(label: 'Time', value: appointment.time),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Done button — returns to the Doctors tab
            FilledButton(
              onPressed: () {
                // Pop back to the root (Doctors tab) and clear booking state.
                context.go('/doctors');
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 48,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single label/value row inside the appointment details card.
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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