import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tenafinder/main.dart';
import 'package:tenafinder/models/doctor.dart';
import 'package:tenafinder/models/facility.dart';
import 'package:tenafinder/providers/firestore_providers.dart';

/// Test data used to override the Firestore providers.
const _testDoctors = [
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
];

const _testFacilities = [
  Facility(
    id: 'f1',
    name: 'Addis General Hospital',
    category: 'hospital',
    rating: 4.6,
    distanceKm: 1.2,
    latitude: 9.0108,
    longitude: 38.7612,
    isOpen: true,
    address: 'Bole Road, Addis Ababa',
  ),
  Facility(
    id: 'f2',
    name: 'Neighborhood Pharmacy',
    category: 'pharmacy',
    rating: 4.3,
    distanceKm: 0.8,
    latitude: 9.0245,
    longitude: 38.7467,
    isOpen: true,
    address: 'Megenagna, Addis Ababa',
  ),
];

/// Builds the app with Firestore providers overridden by test data,
/// so tests don't need a real Firebase connection.
Widget _buildTestApp() {
  return ProviderScope(
    overrides: [
      doctorsStreamProvider.overrideWith((ref) => Stream.value(_testDoctors)),
      facilitiesStreamProvider.overrideWith(
        (ref) => Stream.value(_testFacilities),
      ),
    ],
    child: const TenaFinderApp(),
  );
}

void main() {
  testWidgets('Home screen renders', (tester) async {
    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    // App bar title
    expect(find.text('TenaFinder'), findsOneWidget);

    // Search bar placeholder
    expect(
      find.text('Search doctors, hospitals, pharmacies...'),
      findsOneWidget,
    );

    // 4 category cards ("Doctors" also appears in the bottom nav bar)
    expect(find.text('Hospital'), findsOneWidget);
    expect(find.text('Pharmacy'), findsOneWidget);
    expect(find.text('Lab'), findsOneWidget);
    expect(find.text('Doctors'), findsNWidgets(2));

    // Nearby healthcare section + facility cards from test data
    expect(find.text('Nearby healthcare'), findsOneWidget);
    expect(find.text('Addis General Hospital'), findsOneWidget);
    expect(find.text('Neighborhood Pharmacy'), findsOneWidget);
  });

  testWidgets('Doctors tab opens the Doctor Directory', (tester) async {
    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    // Tap the "Doctors" tab in the bottom navigation bar.
    await tester.tap(find.widgetWithText(NavigationDestination, 'Doctors'));
    await tester.pumpAndSettle();

    // Directory header + search box are shown.
    expect(find.text('Find a Doctor'), findsOneWidget);
    expect(
      find.text('Search by name, specialty, or facility...'),
      findsOneWidget,
    );

    // The test doctors are listed.
    expect(find.text('Dr. Abebe Kebede'), findsOneWidget);
    expect(find.text('Dr. Sara Ahmed'), findsOneWidget);
  });

  testWidgets('Doctor profile and booking flow', (tester) async {
    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    // Open the Doctors tab.
    await tester.tap(find.widgetWithText(NavigationDestination, 'Doctors'));
    await tester.pumpAndSettle();

    // Tap the first doctor card.
    await tester.tap(find.text('Dr. Abebe Kebede'));
    await tester.pumpAndSettle();

    // Profile screen shows doctor details + book button.
    expect(find.text('Doctor Profile'), findsOneWidget);
    expect(find.text('Cardiologist'), findsOneWidget);
    expect(find.text('ETB 1500'), findsOneWidget);
    expect(find.text('Book appointment'), findsOneWidget);

    // Start booking.
    await tester.tap(find.text('Book appointment'));
    await tester.pumpAndSettle();

    // Booking screen: select a day and a time.
    expect(find.text('Select a day'), findsOneWidget);
    await tester.tap(find.text('Monday'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('09:00'));
    await tester.pumpAndSettle();

    // Confirm.
    await tester.tap(find.text('Confirm booking'));
    await tester.pumpAndSettle();

    // Confirmation screen shows appointment details.
    expect(find.text('Appointment booked!'), findsOneWidget);
    expect(find.text('Dr. Abebe Kebede'), findsOneWidget);
    expect(find.text('Monday'), findsOneWidget);
    expect(find.text('09:00'), findsOneWidget);
    expect(find.textContaining('APT-'), findsOneWidget);

    // Tap "Done" to return to the Doctors tab. This also resets the
    // router stack so the next test starts from a clean state.
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Find a Doctor'), findsOneWidget);
  });

  testWidgets('Doctor search filters the list', (tester) async {
    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    // Open the Doctors tab.
    await tester.tap(find.widgetWithText(NavigationDestination, 'Doctors'));
    await tester.pumpAndSettle();

    // Type in the search box.
    await tester.enterText(find.byType(TextField), 'cardiologist');
    await tester.pumpAndSettle();

    // Only the cardiologist remains.
    expect(find.text('Dr. Abebe Kebede'), findsOneWidget);
    expect(find.text('Dr. Sara Ahmed'), findsNothing);

    // A non-matching search shows the empty state.
    await tester.enterText(find.byType(TextField), 'zzzzz');
    await tester.pumpAndSettle();
    expect(find.text('No doctors found'), findsOneWidget);
  });
}
