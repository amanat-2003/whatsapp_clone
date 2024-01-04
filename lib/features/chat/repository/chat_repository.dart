// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:whatsapp_clone/common/enums/message_type.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/contact_chat.dart';
import 'package:whatsapp_clone/models/message_model.dart';
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
          .map((event) {
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
    required String senderUserId,
    required String receiverUserId,
    required MessageType messageType,
  }) async {
    final message = MessageModel(
      text: text,
      time: time,
      messageId: messageId,
      isSeen: isSeen,
      senderUserId: senderUserId,
      receiverUserId: receiverUserId,
      messageType: messageType,
    );

    // for display on sender side
    await firestore
        .collection('users')
        .doc(senderUserId)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    // for display on receiver side
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(senderUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUserModel,
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
        senderUserId: senderUserModel.uid,
        receiverUserId: receiverUserId,
        messageType: MessageType.text,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
