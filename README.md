# TenaFinder

A healthcare discovery mobile app built with Flutter. Find doctors, view their profiles, book appointments, and see nearby healthcare facilities on a map.

## Features (Week 1 MVP)

- **Home screen** — search bar, service categories (Hospital, Pharmacy, Lab, Doctors), and nearby facility cards
- **Doctor Directory** — searchable list of doctors with name, specialization, experience, and facility
- **Doctor Profile** — full doctor details (rating, experience, facility, consultation fee)
- **Appointment Booking** — pick a day and time slot, get a confirmation with an appointment ID
- **Bottom navigation** — Home, Map, Doctors, Profile tabs

## Tech Stack

- **Flutter** (mobile)
- **Riverpod** — state management
- **go_router** — navigation
- **Firebase** — Firestore (live data) + Authentication
- **geolocator** — GPS location

## Getting Started

```bash
flutter pub get
flutter run
```

## Project Structure

```
lib/
├── models/       # Data models (Doctor, Facility)
├── providers/    # Riverpod state providers
├── router/       # go_router configuration
├── screens/      # App screens
├── services/     # Backend/data services (Firebase, location)
└── widgets/      # Reusable UI widgets
```

## Roadmap

- [x] Home screen UI
- [x] Doctor directory + search
- [x] Doctor profile + booking flow
- [x] Firebase integration (real data)
- [x] GPS location + live distances
- [ ] Google Maps API key (map screen)
- [ ] User authentication + real bookings
