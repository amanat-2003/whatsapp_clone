// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/features/auth/repository/auth_repository.dart';
import 'package:whatsapp_clone/models/user_model.dart';

final authControllerProvider = Provider(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return AuthController(
      repository: authRepository,
      ref: ref,
    );
  },
);

final getAuthUserProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUser();
});

class AuthController {
  final AuthRepository repository;
  final ProviderRef ref;

  AuthController({
    required this.repository,
    required this.ref,
  });

  Future<UserModel?> getUser() async {
    final user = await repository.getCurrentUser();
    return user;
  }

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

  void uploadUserDataToFirebase(
    BuildContext context,
    String name,
    File? image,
  ) {
    repository.uploadUserDataToFirebase(
      context: context,
      name: name,
      image: image,
      ref: ref,
    );
  }
}
