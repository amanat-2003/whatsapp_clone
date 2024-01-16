import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/enums/message_type.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/chat/repository/chat_repository.dart';
import 'package:whatsapp_clone/models/contact_chat.dart';
import 'package:whatsapp_clone/models/message_model.dart';
import 'package:whatsapp_clone/models/message_reply.dart';

final chatControllerProvider = Provider(
  (ref) {
    final repository = ref.watch(chatRepositoryProvider);
    return ChatController(
      repository: repository,
      ref: ref,
    );
  },
);

class ChatController {
  final ChatRepository repository;
  final ProviderRef ref;

  ChatController({
    required this.repository,
    required this.ref,
  });

  void setMessageSeen({
    required BuildContext context,
    required MessageModel messageModel,
  }) {
    repository.setMessageSeen(
      context: context,
      messageModel: messageModel,
    );
  }

  void sendGIF({
    required BuildContext context,
    required String gifUrl,
    required String receiverUserId,
    required MessageReplyModel messageReplyModel,
  }) {
    ref.watch(getCurrentUserProvider).whenData(
      (value) {
        repository.sendGIF(
          context: context,
          gifUrl: gifUrl,
          receiverUserId: receiverUserId,
          senderUserModel: value!,
          messageReplyModel: messageReplyModel,
        );
      },
    );
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required MessageType messageType,
    required String receiverUserId,
    required MessageReplyModel messageReplyModel,
  }) {
    repository.sendFileMessage(
      context: context,
      file: file,
      messageType: messageType,
      ref: ref,
      receiverUserId: receiverUserId,
      messageReplyModel: messageReplyModel,
    );
  }

  Stream<List<MessageModel>> getChatMessages({
    required BuildContext context,
    required String receiverUserId,
  }) {
    return repository.getChatMessages(context, receiverUserId);
  }

  Stream<List<ContactChat>> getContactChats({
    required BuildContext context,
  }) {
    return repository.getContactChats(context);
  }

  void sendMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required MessageReplyModel messageReplyModel,
  }) {
    // late UserModel senderUserModel;
    // await ref.watch(getCurrentUserProvider).whenData((value) {
    //   senderUserModel = value!;
    // });

    // repository.sendMessage(
    //   context: context,
    //   text: text,
    //   receiverUserId: receiverUserId,
    //   senderUserModel: senderUserModel,
    // );

    ref.watch(getCurrentUserProvider).whenData(
      (value) {
        repository.sendMessage(
          context: context,
          text: text,
          receiverUserId: receiverUserId,
          senderUserModel: value!,
          messageReplyModel: messageReplyModel,
        );
      },
    );
  }
}
