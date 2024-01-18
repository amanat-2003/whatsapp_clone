import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoggedInProvider = StateProvider<bool>((ref) {
  if (FirebaseAuth.instance.currentUser?.uid != null) {
    return true;
  } else {
    return false;
  }
});