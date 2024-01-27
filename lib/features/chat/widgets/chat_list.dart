// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/widgets/my_message_card.dart';
import 'package:whatsapp_clone/features/chat/widgets/sender_message_card.dart';
import 'package:whatsapp_clone/models/message_model.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;
  const ChatList({
    required this.receiverUserId,
    super.key,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
      stream: ref.watch(chatControllerProvider).getChatMessages(
            context: context,
            receiverUserId: widget.receiverUserId,
          ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loader();
        } else {
          final messageModelList = snapshot.data!;

          SchedulerBinding.instance.addPostFrameCallback((_) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          });

          return ListView.builder(
            controller: scrollController,
            itemCount: messageModelList.length,
            itemBuilder: (context, index) {
              final messageModel = messageModelList[index];

              if (index == 1) {
                // log(messageModel.toString());
                log(messageModel.toJson());
              }

              // log("(!messageModel.isSeen) = " +
              //     (!messageModel.isSeen).toString());
              // log("(messageModel.receiverUserModel.uid == FirebaseAuth.instance.currentUser!.uid) = " +
              //     (messageModel.receiverUserModel.uid ==
              //             FirebaseAuth.instance.currentUser!.uid)
              //         .toString());

              if (!messageModel.isSeen &&
                  messageModel.receiverUserModel.uid ==
                      FirebaseAuth.instance.currentUser!.uid) {
                ref.read(chatControllerProvider).setMessageSeen(
                      context: context,
                      messageModel: messageModel,
                    );
              }

              if (messageModel.senderUserModel.uid ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  senderUserName: messageModel.senderUserModel.name,
                  text: messageModel.text,
                  date: DateFormat('h:mm a').format(messageModel.time),
                  messageType: messageModel.messageType,
                  repliedMessageModel: messageModel.messageReplyModel,
                  senderUserId: messageModel.senderUserModel.uid,
                  isSeen: messageModel.isSeen,
                  isGroupChat: false,
                );
              }
              return SenderMessageCard(
                senderUserName: messageModel.senderUserModel.name,
                text: messageModel.text,
                date: DateFormat('h:mm a').format(messageModel.time),
                messageType: messageModel.messageType,
                repliedMessageModel: messageModel.messageReplyModel,
                senderUserId: messageModel.senderUserModel.uid,
                isGroupChat: false,
              );
            },
          );
        }
      },
    );
  }
}
