import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides access to FirebaseAuth.
/// Kept as a provider so tests can override it with a fake.
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Streams the current authentication state.
///
/// - `null` → user is logged out
/// - `User` → user is logged in
///
/// Why StreamProvider? FirebaseAuth's `authStateChanges()` is a stream that
/// emits whenever the user signs in or out. Watching this provider lets any
/// screen react to auth changes automatically.
final authStateProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges();
});

/// Convenience provider: true if the user is logged in.
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).value != null;
});