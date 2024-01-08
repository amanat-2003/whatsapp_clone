import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/enums/message_type.dart';
import 'package:whatsapp_clone/features/chat/widgets/cached_video_widget.dart';

class DisplayMessageOrFile extends StatelessWidget {
  final String text;
  final MessageType messageType;
  const DisplayMessageOrFile({
    Key? key,
    required this.text,
    required this.messageType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return messageType == MessageType.text
        ? Text(
            text,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : messageType == MessageType.image || messageType == MessageType.gif
            ? CachedNetworkImage(imageUrl: text)
            : CachedVideo(videoUrl: text);
  }
}
