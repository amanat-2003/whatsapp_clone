// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/common/enums/message_type.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/status/repository/status_repository.dart';
import 'package:whatsapp_clone/models/status_model.dart';

final statusControllerProvider = Provider(
  (ref) => StatusController(
    repository: ref.watch(statusRepositoryProvider),
    ref: ref,
  ),
);

class StatusController {
  final StatusRepository repository;
  final ProviderRef ref;

  StatusController({
    required this.repository,
    required this.ref,
  });

  void uploadTextStatusEntity({
    required BuildContext context,
    required String statusText,
  }) async {
    ref.watch(getCurrentUserProvider).whenData((currentUserModel) {
      repository.uploadTextStatusEntity(
        context: context,
        userModel: currentUserModel!,
        statusText: statusText,
      );
    });
  }

  void uploadGIFStatusEntity({
    required BuildContext context,
    required String gifUrl,
  }) async {
    ref.watch(getCurrentUserProvider).whenData((currentUserModel) {
      repository.uploadGIFStatusEntity(
        context: context,
        userModel: currentUserModel!,
        gifUrl: gifUrl,
      );
    });
  }

  void uploadPhotoVideoAudioStatusEntity({
    required BuildContext context,
    required File statusMedia,
    required MessageType statusEntityType,
  }) async {
    ref.watch(getCurrentUserProvider).whenData((currentUserModel) {
      repository.uploadPhotoVideoAudioStatusEntity(
        context: context,
        userModel: currentUserModel!,
        statusMedia: statusMedia,
        statusEntityType: statusEntityType,
      );
    });
  }

  Stream<List<StatusModel>> getStatusModelList(
      {required BuildContext context}) {
    return repository.getStatusModelList(context: context);
  }
}
