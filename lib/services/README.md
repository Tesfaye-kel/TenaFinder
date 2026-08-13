# lib/services

This folder contains the data-access service classes used by the app.

- **`location_service.dart`** — Wraps the `geolocator` plugin: requests location
  permission, gets the user's GPS position, and computes distances between
  coordinates using the Haversine formula.
- **Firestore access** lives in `lib/providers/firestore_providers.dart` (via
  Riverpod `StreamProvider`s), streaming doctors and facilities in real time.
- **Authentication** (Firebase Auth) will be added here.

## Seeding the database

To populate Firestore with test data (facilities + doctors), run the standalone
CLI script from the project root:

```bash
dart run tool/seed_firestore.dart
```

This creates the `facilities` and `doctors` collections with sample Ethiopian
healthcare data.