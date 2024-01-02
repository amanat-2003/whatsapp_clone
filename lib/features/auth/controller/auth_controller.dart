import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/repository/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(repository: authRepository);
});

class AuthController {
  final AuthRepository repository;

  AuthController({required this.repository});

  void signInWithPhoneNumber(BuildContext context, String phoneNumber) async {
    repository.signInWithPhoneNumber(phoneNumber, context);
  }

  void verifyOTP(
    BuildContext context,
    String userOTP,
    String verificationId,
  ) async {
    repository.verifyOTP(
      context: context,
      userOTP: userOTP,
      verificationId: verificationId,
    );
  }
}
