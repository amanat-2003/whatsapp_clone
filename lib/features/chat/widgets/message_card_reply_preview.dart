import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/chat/widgets/display_message_or_file.dart';
import 'package:whatsapp_clone/models/message_reply.dart';

class MessageCardReplyPreview extends StatelessWidget {
  const MessageCardReplyPreview({
    super.key,
    required this.messageReplyModel,
  });

  final MessageReplyModel messageReplyModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 200,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // messageReplyModel.isMe ? 'You' : messageReplyModel.userName,
            FirebaseAuth.instance.currentUser!.uid == messageReplyModel.userId
                ? 'You'
                : messageReplyModel.userName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                messageReplyModel.type.stringValue,
                style: TextStyle(fontSize: 13,color: greyColor),
              ),
              SizedBox(width: 18),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 350,
                  maxHeight: 100,
                ),
                child: DisplayMessageOrFile(
                  text: messageReplyModel.text,
                  messageType: messageReplyModel.type,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
