# TenaFinder

TenaFinder is a Flutter mobile application for discovering healthcare providers,
viewing doctor profiles, booking appointments, and finding nearby facilities.
The current release is a focused week-one MVP for Android.

## MVP User Journey

1. Browse nearby hospitals, pharmacies, and laboratories from the home screen.
2. Search the doctor directory by name, specialty, or facility.
3. Open a doctor's profile and review experience, rating, facility, and fee.
4. Create an account or sign in.
5. Select an appointment day and time slot.
6. Confirm the appointment and view it from the profile screen.
7. Open the map to see the user's location and facility markers.

## Features

- Home dashboard with healthcare categories and nearby facilities
- Doctor directory with live Firestore data and search filtering
- Doctor profiles with consultation details
- Email/password authentication with Firebase Authentication
- Appointment booking linked to the authenticated user's ID
- Profile screen showing the user's appointments
- Google Maps facility markers
- GPS permission handling and distance calculation
- Loading, empty, and basic error states
- Responsive Material 3 interface for Android phones

## Technology

- Flutter and Dart
- Riverpod for application state
- go_router for navigation
- Firebase Authentication for accounts
- Cloud Firestore for doctors, facilities, and appointments
- google_maps_flutter for the map
- geolocator for device location
- Google Fonts for typography

## Repository Layout

```text
lib/
  models/       Doctor and Facility data models
  providers/    Riverpod state, Firebase, auth, and appointment providers
  router/       go_router configuration
  screens/      Home, map, doctors, profile, auth, and booking screens
  services/     Location and device services
  widgets/      Reusable cards and UI components
test/           Widget tests for the main user journey
tool/           Firestore seed data
android/        Android application configuration
```

## Requirements

- Flutter SDK 3.44 or newer
- Dart SDK compatible with `pubspec.yaml`
- Android Studio and Android SDK
- An Android phone with USB debugging enabled, or an Android emulator
- A Firebase project
- A Google Maps Android API key

## Firebase Setup

1. Create or open the Firebase project.
2. Register the Android app with package name `com.example.tenafinder`.
3. Download `google-services.json`.
4. Place it at:

	```text
	android/app/google-services.json
	```

5. Enable **Email/Password** under Firebase Authentication.
6. Create a Cloud Firestore database.
7. Add the `doctors` and `facilities` documents. Example records are in
	`tool/seed_firestore.dart`.
8. Add the Firestore rules appropriate for your environment.

The Firebase configuration file is intentionally ignored by Git. Never commit
service credentials or private keys.

## Google Maps Setup

1. Enable **Maps SDK for Android** in Google Cloud.
2. Create an Android-restricted API key.
3. Restrict the key to package `com.example.tenafinder` and the app's SHA-1
	certificate fingerprints.
4. Put the key in the local Android manifest at:

	```text
	android/app/src/main/AndroidManifest.xml
	```

The manifest contains a placeholder in the repository. Do not commit a real API
key. If a key was exposed, revoke it and create a replacement.

## Run Locally

From the `tenafinder` directory:

```powershell
flutter pub get
flutter devices
flutter run -d <device-id>
```

For the connected TECNO KI7 used during development:

```powershell
flutter run -d 105025438M101456
```

If the phone is not detected, unlock it, select **File transfer**, enable USB
debugging, and accept the USB debugging authorization prompt.

## Test and Build

Run the widget tests:

```powershell
flutter test
```

Run static analysis:

```powershell
flutter analyze
```

Build a release APK:

```powershell
flutter build apk --release
```

The APK is generated at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

The current Android release configuration uses the debug signing key for local
demonstrations. A production release requires a private signing keystore and a
secure Gradle signing configuration.

## Firestore Collections

### `facilities`

Each facility should include:

```text
name, category, rating, distanceKm, latitude, longitude, isOpen, address
```

For Addis Ababa data, latitude values are approximately `9.x` and longitude
values are approximately `38.x`. Both coordinate fields must be Firestore
numbers, not strings.

### `doctors`

Each doctor should include:

```text
name, specialization, experience, facilityName, fee, rating, photoUrl
```

### `appointments`

Appointments are created by the app and include:

```text
doctorId, doctorName, userId, day, time, status, createdAt
```

The `userId` field connects each appointment to the signed-in Firebase user.

## Current Status

- [x] Home screen and nearby facility cards
- [x] Doctor search and directory
- [x] Doctor profile
- [x] Appointment booking flow
- [x] Firebase Authentication
- [x] Firestore doctor, facility, and appointment integration
- [x] GPS location and distance calculation
- [x] Google Maps integration
- [x] Profile appointment history
- [x] Widget tests and Android debug run

## Future Enhancements

- Add more verified facilities around Sululta and Addis Ababa
- Add real doctor availability and calendar dates
- Add appointment cancellation and rescheduling
- Add production Firebase security rules and monitoring
- Add a production Android signing key and release pipeline
- Add Amharic and Afaan Oromo translations
- Add pharmacy search, telemedicine, and other planned services
