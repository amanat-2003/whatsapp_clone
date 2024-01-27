// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swipe_to/swipe_to.dart';

import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/enums/message_type.dart';
import 'package:whatsapp_clone/features/chat/repository/message_reply_provider.dart';
import 'package:whatsapp_clone/features/chat/widgets/display_message_or_file.dart';
import 'package:whatsapp_clone/features/chat/widgets/message_card_reply_preview.dart';
import 'package:whatsapp_clone/models/message_reply.dart';

class SenderMessageCard extends ConsumerWidget {
  const SenderMessageCard({
    Key? key,
    required this.text,
    required this.date,
    required this.messageType,
    required this.senderUserName,
    required this.repliedMessageModel,
    required this.senderUserId,
    required this.isGroupChat,
  }) : super(key: key);
  final String text;
  final String date;
  final MessageType messageType;
  final String senderUserName;
  final MessageReplyModel repliedMessageModel;
  final String senderUserId;
  final bool isGroupChat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwipeTo(
      onRightSwipe: (_) {
        setMessageReply(
          ref,
          MessageReplyModel(
            userName: senderUserName,
            isMe: false,
            type: messageType,
            text: text,
            userId: senderUserId,
          ),
        );
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: senderMessageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isGroupChat)
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      senderUserName,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                if (!repliedMessageModel.isNull)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MessageCardReplyPreview(
                      messageReplyModel: repliedMessageModel,
                    ),
                  ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 30,
                        top: 5,
                        bottom: 20,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: 70),
                        child: DisplayMessageOrFile(
                          text: text,
                          messageType: messageType,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 10,
                      child: Text(
                        date,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
