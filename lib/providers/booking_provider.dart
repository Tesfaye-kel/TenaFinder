import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/doctor.dart';

/// Represents a confirmed appointment booking (Day 3, local state only).
///
/// On Day 6 this will be written to a Firestore `appointments` collection
/// and linked to the logged-in user's ID.
class Appointment {
  final String id;
  final Doctor doctor;
  final String day;
  final String time;

  const Appointment({
    required this.id,
    required this.doctor,
    required this.day,
    required this.time,
  });
}

/// Holds the currently selected booking details while the user is in the
/// booking flow (doctor, chosen day, chosen time).
class BookingState {
  final Doctor? doctor;
  final String? selectedDay;
  final String? selectedTime;

  const BookingState({this.doctor, this.selectedDay, this.selectedTime});

  BookingState copyWith({
    Doctor? doctor,
    String? selectedDay,
    String? selectedTime,
  }) {
    return BookingState(
      doctor: doctor ?? this.doctor,
      selectedDay: selectedDay ?? this.selectedDay,
      selectedTime: selectedTime ?? this.selectedTime,
    );
  }
}

/// Riverpod StateNotifier that manages the booking flow state.
///
/// Why Riverpod instead of plain setState?
/// - The booking state needs to be shared across multiple screens
///   (Doctor Profile → Booking → Confirmation) without passing it
///   through every constructor.
/// - Riverpod makes the state globally accessible and testable.
class BookingNotifier extends StateNotifier<BookingState> {
  BookingNotifier() : super(const BookingState());

  void selectDoctor(Doctor doctor) {
    state = BookingState(doctor: doctor);
  }

  void selectDay(String day) {
    state = state.copyWith(selectedDay: day);
  }

  void selectTime(String time) {
    state = state.copyWith(selectedTime: time);
  }

  /// Creates a confirmed appointment from the current selection.
  Appointment confirm() {
    final doctor = state.doctor;
    final day = state.selectedDay;
    final time = state.selectedTime;
    if (doctor == null || day == null || time == null) {
      throw StateError('Cannot confirm booking without doctor, day, and time');
    }
    return Appointment(
      id: 'APT-${DateTime.now().millisecondsSinceEpoch}',
      doctor: doctor,
      day: day,
      time: time,
    );
  }

  void reset() {
    state = const BookingState();
  }
}

/// The global provider for the booking state.
final bookingProvider = StateNotifierProvider<BookingNotifier, BookingState>((
  ref,
) {
  return BookingNotifier();
});
