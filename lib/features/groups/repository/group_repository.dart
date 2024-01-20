// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/repository/file_upload_repository.dart';

import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/groups/providers/select_contacts_provider.dart';
import 'package:whatsapp_clone/models/group_model.dart';

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
}
