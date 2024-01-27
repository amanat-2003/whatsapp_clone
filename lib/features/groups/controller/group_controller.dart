import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/enums/message_type.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/groups/repository/group_repository.dart';
import 'package:whatsapp_clone/models/group_message_model.dart';
import 'package:whatsapp_clone/models/group_model.dart';
import 'package:whatsapp_clone/models/message_reply.dart';

final groupControllerProvider = Provider(
  (ref) => GroupController(
    groupRepository: ref.watch(groupRepositoryProvider),
    ref: ref,
  ),
);

class GroupController {
  final GroupRepository groupRepository;
  final ProviderRef ref;

  GroupController({
    required this.groupRepository,
    required this.ref,
  });

  void createGroup({
    required BuildContext context,
    required File groupProfilePicFile,
    required String groupName,
    required List<Contact> groupMembersContactList,
  }) {
    groupRepository.createGroup(
      context: context,
      groupProfilePicFile: groupProfilePicFile,
      groupName: groupName,
      groupMembersContactList: groupMembersContactList,
    );
  }

  Stream<List<GroupModel>> getGroupModels(BuildContext context) {
    return groupRepository.getGroupModels(context);
  }

  void sendMessage({
    required BuildContext context,
    required String groupId,
    required String messageText,
    required MessageReplyModel messageReplyModel,
  }) {
    ref.watch(getCurrentUserProvider).whenData(
      (value) {
        groupRepository.sendMessage(
          context: context,
          groupId: groupId,
          messageUserId: value!.uid,
          messageUserName: value.name,
          messageText: messageText,
          messageReplyModel: messageReplyModel,
        );
      },
    );
  }

  void sendGIF({
    required BuildContext context,
    required String gifUrl,
    required String groupId,
    required MessageReplyModel messageReplyModel,
  }) {
    ref.watch(getCurrentUserProvider).whenData(
      (value) {
        groupRepository.sendGIF(
          context: context,
          gifUrl: gifUrl,
          groupId: groupId,
          messageUserId: value!.uid,
          messageUserName: value.name,
          messageReplyModel: messageReplyModel,
        );
      },
    );
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required MessageType messageType,
    required String groupId,
    required MessageReplyModel messageReplyModel,
  }) {
    ref.watch(getCurrentUserProvider).whenData(
      (value) {
        groupRepository.sendFileMessage(
          context: context,
          file: file,
          messageType: messageType,
          groupId: groupId,
          messageUserId: value!.uid,
          messageUserName: value.name,
          messageReplyModel: messageReplyModel,
        );
      },
    );
  }

  Stream<List<GroupMessageModel>> getChatMessages(
      BuildContext context, String groupId) {
    return groupRepository.getChatMessages(
      context,
      groupId,
    );
  }
}
