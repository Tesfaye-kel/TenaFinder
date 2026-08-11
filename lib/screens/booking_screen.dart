import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/booking_provider.dart';

/// Booking screen (Day 3).
///
/// Shows the selected doctor, a list of available days (hardcoded:
/// Monday, Wednesday, Friday) and time slots. The user picks a day and
/// time, then taps "Confirm" to create an appointment and see the
/// Confirmation screen.
class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  // Hardcoded available days and time slots (Day 3).
  // On Day 6 these will come from the doctor's real availability.
  static const List<String> _availableDays = [
    'Monday',
    'Wednesday',
    'Friday',
  ];

  static const List<String> _timeSlots = [
    '09:00',
    '10:00',
    '11:30',
    '14:00',
    '15:30',
  ];

  @override
  Widget build(BuildContext context) {
    final booking = ref.watch(bookingProvider);
    final doctor = booking.doctor;

    // If no doctor was selected (e.g. deep link), go back.
    if (doctor == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Book Appointment')),
        body: const Center(child: Text('No doctor selected')),
      );
    }

    final canConfirm =
        booking.selectedDay != null && booking.selectedTime != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Selected doctor summary
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                child: Text(
                  doctor.name.isNotEmpty ? doctor.name[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              title: Text(
                doctor.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(doctor.specialization),
            ),
          ),
          const SizedBox(height: 24),

          // Available days
          Text(
            'Select a day',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final day in _availableDays)
                ChoiceChip(
                  label: Text(day),
                  selected: booking.selectedDay == day,
                  onSelected: (_) {
                    ref.read(bookingProvider.notifier).selectDay(day);
                  },
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Time slots
          Text(
            'Select a time',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final time in _timeSlots)
                ChoiceChip(
                  label: Text(time),
                  selected: booking.selectedTime == time,
                  onSelected: (_) {
                    ref.read(bookingProvider.notifier).selectTime(time);
                  },
                ),
            ],
          ),
          const SizedBox(height: 32),

          // Confirm button
          FilledButton(
            onPressed: canConfirm
                ? () {
                    // Create the appointment and navigate to confirmation.
                    final appointment =
                        ref.read(bookingProvider.notifier).confirm();
                    context.push('/confirmation', extra: appointment);
                  }
                : null,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text('Confirm booking'),
          ),
        ],
      ),
    );
  }
}