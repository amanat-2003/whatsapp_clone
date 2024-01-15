import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/chat/repository/message_reply_provider.dart';
import 'package:whatsapp_clone/features/chat/widgets/display_message_or_file.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    if (messageReply == null) {
      return SizedBox();
    } else {
      return Container(
        // width: 200,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: backgroundColor.withOpacity(0.5),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  messageReply.isMe ? 'You' : messageReply.userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () => cancelMessageReply(ref),
                  child: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  messageReply.type.stringValue,
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 350,
                    maxHeight: 100,
                  ),
                  child: DisplayMessageOrFile(
                    text: messageReply.text,
                    messageType: messageReply.type,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
