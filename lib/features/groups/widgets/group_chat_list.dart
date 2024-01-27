// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/chat/widgets/my_message_card.dart';
import 'package:whatsapp_clone/features/chat/widgets/sender_message_card.dart';
import 'package:whatsapp_clone/features/groups/controller/group_controller.dart';
import 'package:whatsapp_clone/models/group_message_model.dart';

class GroupChatList extends ConsumerStatefulWidget {
  final String groupId;
  const GroupChatList({
    required this.groupId,
    super.key,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupChatListState();
}

class _GroupChatListState extends ConsumerState<GroupChatList> {
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<GroupMessageModel>>(
      stream: ref.watch(groupControllerProvider).getChatMessages(context, widget.groupId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loader();
        } else {
          final groupMessageModelList = snapshot.data!;

          SchedulerBinding.instance.addPostFrameCallback((_) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          });

          return ListView.builder(
            controller: scrollController,
            itemCount: groupMessageModelList.length,
            itemBuilder: (context, index) {
              final groupMessageModel = groupMessageModelList[index];

              if (index == 1) {
                // log(messageModel.toString());
                log(groupMessageModel.toJson());
              }

              // log("(!messageModel.isSeen) = " +
              //     (!messageModel.isSeen).toString());
              // log("(messageModel.receiverUserModel.uid == FirebaseAuth.instance.currentUser!.uid) = " +
              //     (messageModel.receiverUserModel.uid ==
              //             FirebaseAuth.instance.currentUser!.uid)
              //         .toString());



              if (groupMessageModel.senderUserId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  senderUserName: groupMessageModel.senderUserName,
                  text: groupMessageModel.text,
                  date: DateFormat('h:mm a').format(groupMessageModel.time),
                  messageType: groupMessageModel.messageType,
                  repliedMessageModel: groupMessageModel.messageReplyModel,
                  senderUserId: groupMessageModel.senderUserId,
                  isSeen: false,
                  isGroupChat: true,
                );
              }
              return SenderMessageCard(
                senderUserName: groupMessageModel.senderUserName,
                text: groupMessageModel.text,
                date: DateFormat('h:mm a').format(groupMessageModel.time),
                messageType: groupMessageModel.messageType,
                repliedMessageModel: groupMessageModel.messageReplyModel,
                senderUserId: groupMessageModel.senderUserId,
                isGroupChat: true,
              );
            },
          );
        }
      },
    );
  }
}
