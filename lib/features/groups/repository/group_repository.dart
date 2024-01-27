// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/enums/message_type.dart';
import 'package:whatsapp_clone/common/repository/file_upload_repository.dart';

import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/groups/providers/select_contacts_provider.dart';
import 'package:whatsapp_clone/models/group_message_model.dart';
import 'package:whatsapp_clone/models/group_model.dart';
import 'package:whatsapp_clone/models/message_reply.dart';

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    ref: ref,
  ),
);

class GroupRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final ProviderRef ref;

  GroupRepository({
    required this.auth,
    required this.firestore,
    required this.ref,
  });

  void createGroup({
    required BuildContext context,
    required File groupProfilePicFile,
    required String groupName,
    required List<Contact> groupMembersContactList,
  }) async {
    try {
      final groupId = Uuid().v1();
      final groupProfilePicUrl =
          await ref.read(fileUploadRepositoryProvider).uploadToFirebaseStorage(
                context,
                groupProfilePicFile,
                "groupProfilePics/$groupId",
              );
      List<String> groupMembersIds = [];
      for (var contact in groupMembersContactList) {
        final registeredUsersCollection = await firestore
            .collection("users")
            .where("phoneNumber", isEqualTo: contact.phones[0].normalizedNumber)
            .get();
        if (registeredUsersCollection.docs.isNotEmpty) {
          groupMembersIds
              .add(registeredUsersCollection.docs[0].data()['uid'] as String);
        }
      }

      if (!(groupMembersIds.contains(auth.currentUser!.uid))) {
        groupMembersIds.add(auth.currentUser!.uid);
      }

      // final groupMembersIds = groupMembers.map((contact) => contact.).toList();

      final createdGroup = GroupModel(
        groupId: groupId,
        groupName: groupName,
        groupProfilePicUrl: groupProfilePicUrl,
        groupMembersIds: groupMembersIds,
        lastMessageUserId: "",
        lastMessageUserName: "",
        lastMessageText: "",
        lastMessageTime: DateTime.now(),
      );

      await firestore
          .collection("groups")
          .doc(groupId)
          .set(createdGroup.toMap());

      ref.read(selectedContactsProvider.notifier).update((state) => []);

      showSnackBar(context, "Group named $groupName successfully created.");
      Navigator.pop(context);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Stream<List<GroupModel>> getGroupModels(BuildContext context) {
    try {
      return firestore
          .collection('groups')
          .orderBy('lastMessageTime', descending: true)
          .snapshots()
          .asyncMap((event) {
        List<GroupModel> groupModelList = [];
        for (var document in event.docs) {
          final groupModel = GroupModel.fromMap(document.data());
          if (groupModel.groupMembersIds.contains(auth.currentUser!.uid)) {
            groupModelList.add(groupModel);
          }
        }
        return groupModelList;
      });
    } catch (e) {
      showSnackBar(context, e.toString());
      return Stream<List<GroupModel>>.value([]);
    }
  }

  void _sendDataToContactGroupSubCollection({
    required DateTime time,
    required String groupId,
    required String messageUserId,
    required String messageUserName,
    required String messageText,
  }) async {
    await firestore.collection('groups').doc(groupId).update({
      'lastMessageUserId': messageUserId,
      'lastMessageUserName': messageUserName,
      'lastMessageText': messageText,
      'lastMessageTime': time.millisecondsSinceEpoch,
    });
  }

  void _sendDataToGroupMessageSubCollection({
    required String text,
    required DateTime time,
    required String messageId,
    required bool isSeen,
    required String senderUserId,
    required String senderUserName,
    required String groupId,
    required MessageType messageType,
    required MessageReplyModel messageReplyModel,
  }) async {
    final groupMessage = GroupMessageModel(
      text: text,
      time: time,
      messageId: messageId,
      senderUserId: senderUserId,
      groupId: groupId,
      messageType: messageType,
      messageReplyModel: messageReplyModel,
      senderUserName: senderUserName,
    );

    await firestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .doc(messageId)
        .set(groupMessage.toMap());
  }

  void sendMessage({
    required BuildContext context,
    required String groupId,
    required String messageUserId,
    required String messageUserName,
    required String messageText,
    required MessageReplyModel messageReplyModel,
  }) async {
    try {
      final time = DateTime.now();

      _sendDataToContactGroupSubCollection(
        time: time,
        groupId: groupId,
        messageUserId: messageUserId,
        messageUserName: messageUserName,
        messageText: messageText,
      );

      final messageId = Uuid().v1();

      _sendDataToGroupMessageSubCollection(
        text: messageText,
        time: time,
        messageId: messageId,
        isSeen: false,
        senderUserId: messageUserId,
        senderUserName: messageUserName,
        groupId: groupId,
        messageType: MessageType.text,
        messageReplyModel: messageReplyModel,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void sendGIF({
    required BuildContext context,
    required String gifUrl,
    required String groupId,
    required String messageUserId,
    required String messageUserName,
    required MessageReplyModel messageReplyModel,
  }) async {
    try {
      final time = DateTime.now();

      final indexOfId = gifUrl.lastIndexOf('-') + 1;

      final idPart = gifUrl.substring(indexOfId);

      final actualGIFUrl = "https://i.giphy.com/media/$idPart/200.gif";

      _sendDataToContactGroupSubCollection(
        time: time,
        groupId: groupId,
        messageUserId: messageUserId,
        messageUserName: messageUserName,
        messageText: '🖼️ GIF',
      );

      final messageId = Uuid().v1();

      _sendDataToGroupMessageSubCollection(
        text: actualGIFUrl,
        time: time,
        messageId: messageId,
        isSeen: false,
        senderUserId: messageUserId,
        senderUserName: messageUserName,
        groupId: groupId,
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
    required String groupId,
    required String messageUserId,
    required String messageUserName,
    required MessageReplyModel messageReplyModel,
  }) async {
    try {
      final messageId = Uuid().v1();

      final senderUserId = auth.currentUser!.uid;

      final uploadUrl =
          await ref.watch(fileUploadRepositoryProvider).uploadToFirebaseStorage(
                context,
                file,
                'groups/${messageType.stringValue}/${groupId}/$messageId',
              );

      final time = DateTime.now();

      var contactGroupText = '';

      switch (messageType) {
        case MessageType.image:
          contactGroupText = "📷 Image";
          break;
        case MessageType.video:
          contactGroupText = "🎥 Video";
          break;
        case MessageType.audio:
          contactGroupText = "🔊 Audio";
          break;
        case MessageType.gif:
          contactGroupText = "🖼️ GIF";
          break;
        default:
          contactGroupText = "Error in group repo send file message";
          break;
      }

      _sendDataToContactGroupSubCollection(
        time: time,
        groupId: groupId,
        messageUserId: messageUserId,
        messageUserName: messageUserName,
        messageText: contactGroupText,
      );

      _sendDataToGroupMessageSubCollection(
        text: uploadUrl,
        time: time,
        messageId: messageId,
        isSeen: false,
        senderUserId: senderUserId,
        senderUserName: messageUserName,
        groupId: groupId,
        messageType: messageType,
        messageReplyModel: messageReplyModel,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Stream<List<GroupMessageModel>> getChatMessages(
      BuildContext context, String groupId) {
    try {
      return firestore
          .collection('groups')
          .doc(groupId)
          .collection('chats')
          .orderBy('time')
          .snapshots()
          .asyncMap((event) {
        final List<GroupMessageModel> groupMessageModelList = [];
        for (var document in event.docs) {
          final messsageModel = GroupMessageModel.fromMap(document.data());
          groupMessageModelList.add(messsageModel);
        }
        return groupMessageModelList;
      });
    } catch (e) {
      showSnackBar(context, e.toString());
      return Stream<List<GroupMessageModel>>.value([]);
    }
  }
}
