import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tenafinder/main.dart';

void main() {
  testWidgets('Home screen renders', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TenaFinderApp()));

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

    // Nearby healthcare section + first facility cards
    expect(find.text('Nearby healthcare'), findsOneWidget);
    expect(find.text('Addis General Hospital'), findsOneWidget);

    // The remaining cards are below the fold in the 800x600 viewport,
    // so scroll the ListView down before asserting.
    await tester.scrollUntilVisible(
      find.text('Central Diagnostic Lab'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Central Diagnostic Lab'), findsOneWidget);
  });

  testWidgets('Doctors tab opens the Doctor Directory', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TenaFinderApp()));

    // Tap the "Doctors" tab in the bottom navigation bar.
    await tester.tap(
      find.widgetWithText(NavigationDestination, 'Doctors'),
    );
    await tester.pumpAndSettle();

    // Directory header + search box are shown.
    expect(find.text('Find a Doctor'), findsOneWidget);
    expect(
      find.text('Search by name, specialty, or facility...'),
      findsOneWidget,
    );

    // The hardcoded doctors are listed.
    expect(find.text('Dr. Abebe Kebede'), findsOneWidget);
    expect(find.text('Dr. Sara Ahmed'), findsOneWidget);
  });

  testWidgets('Doctor profile and booking flow', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TenaFinderApp()));

    // Open the Doctors tab.
    await tester.tap(
      find.widgetWithText(NavigationDestination, 'Doctors'),
    );
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
    await tester.pumpWidget(const ProviderScope(child: TenaFinderApp()));

    // Open the Doctors tab.
    await tester.tap(
      find.widgetWithText(NavigationDestination, 'Doctors'),
    );
    await tester.pumpAndSettle();

    // Type in the search box.
    await tester.enterText(
      find.byType(TextField),
      'cardiologist',
    );
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