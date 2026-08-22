import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/facility.dart';
import '../providers/firestore_providers.dart';
import '../services/location_service.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final LocationService _locationService = LocationService();
  GoogleMapController? _mapController;
  LatLng? _userLocation;
  bool _loadingLocation = true;
  String? _locationError;

  static const LatLng _defaultCenter = LatLng(9.0108, 38.7612);

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

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

    if (position != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          14,
        ),
      );
    }
  }

  Set<Marker> _buildMarkers(List<Facility> facilities) {
    final markers = <Marker>{};
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

    for (final facility in facilities) {
      markers.add(
        Marker(
          markerId: MarkerId(facility.id),
          position: LatLng(facility.latitude, facility.longitude),
          infoWindow: InfoWindow(
            title: facility.name,
            snippet: facility.isOpen ? 'Open now' : 'Closed',
          ),
        ),
      );
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesAsync = ref.watch(facilitiesStreamProvider);
    if (kIsWeb) return _buildWebFallback(facilitiesAsync);

    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Facilities')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _userLocation ?? _defaultCenter,
              zoom: 12,
            ),
            onMapCreated: (controller) => _mapController = controller,
            markers: facilitiesAsync.maybeWhen(
              data: _buildMarkers,
              orElse: () => _userLocation != null
                  ? _buildMarkers([])
                  : <Marker>{},
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            padding: const EdgeInsets.only(top: 8, bottom: 8),
          ),
          if (_loadingLocation)
            const Positioned.fill(
              child: ColoredBox(
                color: Colors.black26,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
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
                      Expanded(child: Text(_locationError!)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWebFallback(AsyncValue<List<Facility>> facilitiesAsync) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Facilities')),
      body: facilitiesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Unable to load facilities: $error'),
        ),
        data: (facilities) => facilities.isEmpty
            ? const Center(child: Text('No facilities found.'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: facilities.length,
                separatorBuilder: (_, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final facility = facilities[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(facility.name),
                      subtitle: Text(facility.address),
                      trailing: Text(facility.isOpen ? 'Open' : 'Closed'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
