import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/doctor.dart';
import '../providers/booking_provider.dart';
import '../screens/booking_screen.dart';
import '../screens/confirmation_screen.dart';
import '../screens/doctor_directory_screen.dart';
import '../screens/doctor_profile_screen.dart';
import '../screens/home_screen.dart';
import '../screens/main_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/map_screen.dart';

/// Central go_router configuration.
///
/// Why go_router?
/// - Declarative URL-based routing: each screen has a path (e.g. `/doctors`),
///   which will matter later for deep links and web support.
/// - `StatefulShellRoute.indexedStack` keeps the bottom nav bar visible on
///   every tab while preserving each tab's scroll/state.
///
/// Day 3 routes:
/// - `/doctor-profile` — Doctor Profile (doctor passed via `extra`)
/// - `/booking` — day/time slot selection
/// - `/confirmation` — appointment confirmation (Appointment via `extra`)
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: [
        // Home tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Map tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/map',
              builder: (context, state) => const MapScreen(),
            ),
          ],
        ),
        // Doctors tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/doctors',
              builder: (context, state) => const DoctorDirectoryScreen(),
            ),
          ],
        ),
        // Profile tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    // Doctor Profile (pushed on top of the shell)
    GoRoute(
      path: '/doctor-profile',
      builder: (context, state) {
        // Defensive null check: if no doctor was passed (e.g. deep link),
        // show a fallback instead of crashing.
        final doctor = state.extra;
        if (doctor is Doctor) {
          return DoctorProfileScreen(doctor: doctor);
        }
        return const FallbackScreen(message: 'Doctor not found');
      },
    ),
    // Booking flow (pushed on top of the shell)
    GoRoute(
      path: '/booking',
      builder: (context, state) => const BookingScreen(),
    ),
    // Confirmation (pushed on top of the shell)
    GoRoute(
      path: '/confirmation',
      builder: (context, state) {
        final appointment = state.extra;
        if (appointment is Appointment) {
          return ConfirmationScreen(appointment: appointment);
        }
        return const FallbackScreen(message: 'Appointment not found');
      },
    ),
  ],
);

/// Simple fallback shown when a route is opened without its required data.
class FallbackScreen extends StatelessWidget {
  final String message;

  const FallbackScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/doctors'),
                child: const Text('Go to Doctors'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}