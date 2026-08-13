import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Root shell of the app with the bottom navigation bar.
///
/// This widget receives a `navigationShell` from go_router's
/// `StatefulShellRoute.indexedStack`. The shell:
/// - keeps the bottom nav bar visible on every tab
/// - preserves each tab's scroll position and state when switching
/// - updates the URL (e.g. `/doctors`) as the user switches tabs
class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  void _onTabTapped(int index) {
    // goBranch switches the active tab while preserving the other
    // tabs' state (equivalent to the IndexedStack from Day 1).
    navigationShell.goBranch(
      index,
      // When re-tapping the current tab, pop back to its root screen.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTabTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Doctors',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
