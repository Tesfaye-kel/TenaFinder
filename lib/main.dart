import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'router/app_router.dart';

Future<void> main() async {
  // Ensure Flutter bindings are ready before any async work.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (reads google-services.json on Android).
  await Firebase.initializeApp();

  runApp(
    // ProviderScope makes Riverpod state available to the whole app.
    // This is where our appointment-booking state and Firestore streams live.
    const ProviderScope(child: TenaFinderApp()),
  );
}

class TenaFinderApp extends StatelessWidget {
  const TenaFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF00A86B), // healthcare green
    );

    return MaterialApp.router(
      title: 'TenaFinder',
      debugShowCheckedModeBanner: false,
      // go_router handles all navigation (bottom tabs + future screens).
      routerConfig: appRouter,
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: colorScheme.primary.withValues(alpha: 0.12),
          labelTextStyle: WidgetStatePropertyAll(
            GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
        // Clean flat design: no default card shadows.
        cardTheme: const CardThemeData(elevation: 0),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
