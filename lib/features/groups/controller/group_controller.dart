import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/groups/repository/group_repository.dart';
import 'package:whatsapp_clone/models/group_model.dart';

final groupControllerProvider = Provider(
  (ref) => GroupController(
    groupRepository: ref.watch(groupRepositoryProvider),
  ),
);

class GroupController {
  final GroupRepository groupRepository;

  GroupController({
    required this.groupRepository,
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

  Stream<List<GroupModel>> getGroupModels(BuildContext context){
    return groupRepository.getGroupModels(context);
  }
}
