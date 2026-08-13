import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';

/// Wraps the geolocator plugin to get the user's current position.
///
/// How it works:
/// 1. We check if location services (GPS) are enabled on the device.
/// 2. We request permission from the user (the OS shows a dialog).
/// 3. Once granted, we ask the GPS for the current latitude/longitude.
class LocationService {
  /// Requests permission and returns the user's current position.
  /// Returns null if the user denies permission or services are off.
  Future<Position?> getCurrentPosition() async {
    // 1. Check if location services are enabled (GPS on?).
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    // 2. Check the current permission status.
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Ask the user for permission (shows the OS dialog).
      permission = await Geolocator.requestPermission();
    }

    // 3. If denied (or permanently denied), we can't get a position.
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    // 4. Get the current position from GPS.
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    // Guard against the "no GPS fix yet" bug where the device returns
    // (0, 0) — that's in the Gulf of Guinea, thousands of km away.
    // If we get (0, 0), treat it as "no location" so the app falls back
    // to the stored Firestore distances.
    if (position.latitude.abs() < 0.0001 && position.longitude.abs() < 0.0001) {
      return null;
    }

    return position;
  }

  /// Calculates the straight-line (Haversine) distance in km between
  /// two coordinates. This is the formula Google Maps uses for
  /// "as the crow flies" distance.
  static double distanceKm(Position from, double toLat, double toLng) {
    const earthRadiusKm = 6371.0;
    final dLat = _degToRad(toLat - from.latitude);
    final dLng = _degToRad(toLng - from.longitude);
    final lat1 = _degToRad(from.latitude);
    final lat2 = _degToRad(toLat);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  static double _degToRad(double deg) => deg * (math.pi / 180.0);
}
