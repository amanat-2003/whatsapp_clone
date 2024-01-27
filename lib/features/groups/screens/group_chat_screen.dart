import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/groups/widgets/group_bottom_text_field.dart';
import 'package:whatsapp_clone/features/groups/widgets/group_chat_list.dart';

class GroupChatScreen extends ConsumerWidget {
  static const routeName = "/group-chat-screen";

  final String groupName;
  final String groupId;

  const GroupChatScreen({
    Key? key,
    required this.groupName,
    required this.groupId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(groupName),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GroupChatList(
              groupId: groupId,
            ),
          ),
          GroupBottomTextField(groupId: groupId),
        ],
      ),
    );
  }
}
