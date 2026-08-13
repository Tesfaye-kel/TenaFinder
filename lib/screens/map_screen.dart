import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/facility.dart';
import '../providers/firestore_providers.dart';
import '../services/location_service.dart';

/// Map screen (Day 5).
///
/// Shows the user's current location and pins for all facilities
/// in Firestore. Uses google_maps_flutter + geolocator.
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final LocationService _locationService = LocationService();

  // Map state
  GoogleMapController? _mapController;
  LatLng? _userLocation;
  bool _loadingLocation = true;
  String? _locationError;

  // Default to Addis Ababa center while waiting for GPS.
  static const LatLng _defaultCenter = LatLng(9.0108, 38.7612);

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  /// Gets the user's position, then adds a marker for them.
  Future<void> _getUserLocation() async {
    final position = await _locationService.getCurrentPosition();
    if (!mounted) return;

    setState(() {
      _loadingLocation = false;
      if (position != null) {
        _userLocation = LatLng(position.latitude, position.longitude);
      } else {
        _locationError =
            'Location permission denied or GPS off. Showing default map.';
      }
    });

    // Move the camera to the user's location if we have it.
    if (position != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          14,
        ),
      );
    }
  }

  /// Builds markers for the user + all facilities from Firestore.
  Set<Marker> _buildMarkers(List<Facility> facilities) {
    final markers = <Marker>{};

    // Blue dot for the user.
    if (_userLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user'),
          position: _userLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: const InfoWindow(title: 'You are here'),
        ),
      );
    }

    // Facility pins (red for hospitals, green for pharmacies, etc.).
    for (final f in facilities) {
      markers.add(
        Marker(
          markerId: MarkerId(f.id),
          position: LatLng(f.latitude, f.longitude),
          infoWindow: InfoWindow(
            title: f.name,
            snippet: f.isOpen ? 'Open now' : 'Closed',
          ),
        ),
      );
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesAsync = ref.watch(facilitiesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Facilities')),
      body: Stack(
        children: [
          // The Google Map widget
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _userLocation ?? _defaultCenter,
              zoom: 12,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: facilitiesAsync.maybeWhen(
              data: (facilities) => _buildMarkers(facilities),
              orElse: () =>
                  _userLocation != null ? _buildMarkers([]) : <Marker>{},
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            // ASK: why do we need these? See teaching note below.
            padding: const EdgeInsets.only(top: 8, bottom: 8),
          ),

          // Loading overlay while getting GPS position.
          if (_loadingLocation)
            const Positioned.fill(
              child: ColoredBox(
                color: Colors.black26,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),

          // Error message if location permission was denied.
          if (_locationError != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Card(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _locationError!,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
