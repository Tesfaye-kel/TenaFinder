import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/doctor.dart';
import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import '../screens/booking_screen.dart';
import '../screens/confirmation_screen.dart';
import '../screens/doctor_directory_screen.dart';
import '../screens/doctor_profile_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/main_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/map_screen.dart';
import '../screens/signup_screen.dart';

/// Central go_router configuration.
///
/// Why go_router?
/// - Declarative URL-based routing: each screen has a path (e.g. `/doctors`),
///   which will matter later for deep links and web support.
/// - `StatefulShellRoute.indexedStack` keeps the bottom nav bar visible on
///   every tab while preserving each tab's scroll/state.
///
/// Day 6 routes:
/// - `/login` — email/password login
/// - `/signup` — create a new account
/// - The `redirect` guards the booking flow: a logged-out user is sent to
///   `/login` before they can book an appointment.
///
/// Why a Riverpod provider instead of a global?
/// - The redirect callback needs to read `isLoggedInProvider`. A global
///   `final GoRouter` is created before the `ProviderScope` exists, so
///   `ProviderScope.containerOf(context)` would fail on first navigation.
/// - Making it a provider ensures the router is created inside the
///   ProviderScope, so it can read auth state correctly.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    // Redirect logic: if a logged-out user tries to access the booking flow,
    // send them to the login screen first.
    redirect: (context, state) {
      final loggedIn = ref.read(isLoggedInProvider);
      final isBookingRoute = state.matchedLocation == '/booking' ||
          state.matchedLocation == '/confirmation';

      if (!loggedIn && isBookingRoute) {
        return '/login';
      }
      return null;
    },
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: [
        // Home tab
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
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
    // Login (pushed on top of the shell)
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    // Signup (pushed on top of the shell)
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
  ],
  );
});

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