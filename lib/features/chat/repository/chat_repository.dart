// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:whatsapp_clone/common/enums/message_type.dart';
import 'package:whatsapp_clone/common/repository/file_upload_repository.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/contact_chat.dart';
import 'package:whatsapp_clone/models/message_model.dart';
import 'package:whatsapp_clone/models/message_reply.dart';
import 'package:whatsapp_clone/models/user_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  void setMessageSeen({
    required BuildContext context,
    required MessageModel messageModel,
  }) async {
    // for display on sender side
    await firestore
        .collection('users')
        .doc(messageModel.senderUserModel.uid)
        .collection('chats')
        .doc(messageModel.receiverUserModel.uid)
        .collection('messages')
        .doc(messageModel.messageId)
        .update({"isSeen": true});

    // for display on receiver side
    await firestore
        .collection('users')
        .doc(messageModel.receiverUserModel.uid)
        .collection('chats')
        .doc(messageModel.senderUserModel.uid)
        .collection('messages')
        .doc(messageModel.messageId)
        .update({"isSeen": true});
  }

  void sendGIF({
    required BuildContext context,
    required String gifUrl,
    required String receiverUserId,
    required UserModel senderUserModel,
    required MessageReplyModel messageReplyModel,
  }) async {
    try {
      final time = DateTime.now();

      final indexOfId = gifUrl.lastIndexOf('-') + 1;

      final idPart = gifUrl.substring(indexOfId);

      final actualGIFUrl = "https://i.giphy.com/media/$idPart/200.gif";

      final receiverUser =
          await firestore.collection('users').doc(receiverUserId).get();

      final receiverUserModel = UserModel.fromMap(receiverUser.data()!);

      _sendDataToContactChatSubCollection(
        text: '🖼️ GIF',
        time: time,
        senderUserModel: senderUserModel,
        receiverUserModel: receiverUserModel,
      );

      final messageId = Uuid().v1();

      _sendDataToMessageSubCollection(
        text: actualGIFUrl,
        time: time,
        messageId: messageId,
        isSeen: false,
        senderUserModel: senderUserModel,
        receiverUserModel: receiverUserModel,
        messageType: MessageType.gif,
        messageReplyModel: messageReplyModel,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required MessageType messageType,
    required ProviderRef ref,
    required String receiverUserId,
    required MessageReplyModel messageReplyModel,
  }) async {
    try {
      final messageId = Uuid().v1();

      final senderUserId = auth.currentUser!.uid;

      final senderUserModel = UserModel.fromMap(
          (await firestore.collection('users').doc(senderUserId).get())
              .data()!);

      final receiverUserModel = UserModel.fromMap(
          (await firestore.collection('users').doc(receiverUserId).get())
              .data()!);

      final uploadUrl =
          await ref.watch(fileUploadRepositoryProvider).uploadToFirebaseStorage(
                context,
                file,
                'chats/${messageType.stringValue}/${senderUserModel.uid}/${receiverUserModel.uid}/$messageId',
              );

      final time = DateTime.now();

      var contactChatText = '';

      switch (messageType) {
        case MessageType.image:
          contactChatText = "📷 Image";
          break;
        case MessageType.video:
          contactChatText = "🎥 Video";
          break;
        case MessageType.audio:
          contactChatText = "🔊 Audio";
          break;
        case MessageType.gif:
          contactChatText = "🖼️ GIF";
          break;
        default:
          contactChatText = "Error in chat repo send file message";
          break;
      }

      _sendDataToContactChatSubCollection(
        text: contactChatText,
        time: time,
        senderUserModel: senderUserModel,
        receiverUserModel: receiverUserModel,
      );

      _sendDataToMessageSubCollection(
        text: uploadUrl,
        time: time,
        messageId: messageId,
        isSeen: false,
        senderUserModel: senderUserModel,
        receiverUserModel: receiverUserModel,
        messageType: messageType,
        messageReplyModel: messageReplyModel,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Stream<List<MessageModel>> getChatMessages(
      BuildContext context, String receiverUserId) {
    try {
      return firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverUserId)
          .collection('messages')
          .orderBy('time')
          .snapshots()
          .asyncMap((event) {
        final List<MessageModel> messageModelList = [];
        for (var document in event.docs) {
          final messsageModel = MessageModel.fromMap(document.data());
          messageModelList.add(messsageModel);
        }
        return messageModelList;
      });
    } catch (e) {
      showSnackBar(context, e.toString());
      return Stream<List<MessageModel>>.value([]);
    }
  }

  Stream<List<ContactChat>> getContactChats(BuildContext context) {
    try {
      return firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .snapshots()
          .asyncMap(
        (event) {
          List<ContactChat> contactChatsList = [];
          for (var document in event.docs) {
            contactChatsList.add(
              ContactChat.fromMap(
                document.data(),
              ),
            );
          }
          return contactChatsList;
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
      return Stream<List<ContactChat>>.value([]);
    }
  }

  void _sendDataToContactChatSubCollection({
    required String text,
    required DateTime time,
    required UserModel senderUserModel,
    required UserModel receiverUserModel,
  }) async {
    final senderContactChat = ContactChat(
      text: text,
      time: time,
      profilePic: receiverUserModel.profilePic,
      name: receiverUserModel.name,
      contactId: receiverUserModel.uid,
    );

    await firestore
        .collection('users')
        .doc(senderUserModel.uid)
        .collection('chats')
        .doc(receiverUserModel.uid)
        .set(senderContactChat.toMap());

    final receiverContactChat = ContactChat(
      text: text,
      time: time,
      profilePic: senderUserModel.profilePic,
      name: senderUserModel.name,
      contactId: senderUserModel.uid,
    );

    await firestore
        .collection('users')
        .doc(receiverUserModel.uid)
        .collection('chats')
        .doc(senderUserModel.uid)
        .set(receiverContactChat.toMap());
  }

  void _sendDataToMessageSubCollection({
    required String text,
    required DateTime time,
    required String messageId,
    required bool isSeen,
    required UserModel senderUserModel,
    required UserModel receiverUserModel,
    required MessageType messageType,
    required MessageReplyModel messageReplyModel,
  }) async {
    final message = MessageModel(
      text: text,
      time: time,
      messageId: messageId,
      isSeen: isSeen,
      senderUserModel: senderUserModel,
      receiverUserModel: receiverUserModel,
      messageType: messageType,
      messageReplyModel: messageReplyModel,
    );

    // for display on sender side
    await firestore
        .collection('users')
        .doc(senderUserModel.uid)
        .collection('chats')
        .doc(receiverUserModel.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    // for display on receiver side
    await firestore
        .collection('users')
        .doc(receiverUserModel.uid)
        .collection('chats')
        .doc(senderUserModel.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUserModel,
    required MessageReplyModel messageReplyModel,
  }) async {
    try {
      final time = DateTime.now();

      final receiverUser =
          await firestore.collection('users').doc(receiverUserId).get();

      final receiverUserModel = UserModel.fromMap(receiverUser.data()!);

      _sendDataToContactChatSubCollection(
        text: text,
        time: time,
        senderUserModel: senderUserModel,
        receiverUserModel: receiverUserModel,
      );

      final messageId = Uuid().v1();

      _sendDataToMessageSubCollection(
        text: text,
        time: time,
        messageId: messageId,
        isSeen: false,
        senderUserModel: senderUserModel,
        receiverUserModel: receiverUserModel,
        messageType: MessageType.text,
        messageReplyModel: messageReplyModel,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
