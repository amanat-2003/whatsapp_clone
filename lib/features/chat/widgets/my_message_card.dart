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

class MyMessageCard extends ConsumerWidget {
  final String text;
  final String date;
  final String senderUserName;
  final String senderUserId;
  final MessageType messageType;
  final MessageReplyModel repliedMessageModel;
  final bool isSeen;
  final bool isGroupChat;

  const MyMessageCard({
    Key? key,
    required this.text,
    required this.date,
    required this.senderUserName,
    required this.senderUserId,
    required this.messageType,
    required this.repliedMessageModel,
    required this.isSeen,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwipeTo(
      onLeftSwipe: (_) {
        setMessageReply(
          ref,
          MessageReplyModel(
            userName: senderUserName,
            isMe: true,
            type: messageType,
            text: text,
            userId: senderUserId,
          ),
        );
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: messageColor,
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
                      padding: messageType == MessageType.text
                          ? const EdgeInsets.only(
                              left: 10,
                              right: 30,
                              top: 5,
                              bottom: 20,
                            )
                          : const EdgeInsets.only(
                              left: 5,
                              right: 5,
                              top: 5,
                              bottom: 25,
                            ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: 80),
                        child: DisplayMessageOrFile(
                          text: text,
                          messageType: messageType,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 10,
                      child: Row(
                        children: [
                          Text(
                            date,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white60,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Icon(
                            isSeen ? Icons.done_all : Icons.done,
                            size: 20,
                            color: isSeen ? Colors.blue : Colors.white60,
                          ),
                        ],
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
