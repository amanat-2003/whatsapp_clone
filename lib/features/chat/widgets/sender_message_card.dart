import 'package:flutter/material.dart';

import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/enums/message_type.dart';
import 'package:whatsapp_clone/features/chat/widgets/display_message_or_file.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.text,
    required this.date,
    required this.messageType,
  }) : super(key: key);
  final String text;
  final String date;
  final MessageType messageType;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: senderMessageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 30,
                  top: 5,
                  bottom: 20,
                ),
                child: DisplayMessageOrFile(
                  text: text,
                  messageType: messageType,
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
        ),
      ),
    );
  }
}
