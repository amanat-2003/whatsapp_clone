// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audioplayers/audioplayers.dart';
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
    bool isPlaying = false;
    AudioPlayer audioPlayer = AudioPlayer();

    return messageType == MessageType.text
        ? Text(
            text,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : messageType == MessageType.image || messageType == MessageType.gif
            ? CachedNetworkImage(imageUrl: text)
            : messageType == MessageType.video
                ? CachedVideo(videoUrl: text)
                : StatefulBuilder(builder: (context, setState) {
                    return IconButton(
                      onPressed: () async {
                        if (isPlaying) {
                          await audioPlayer.pause();
                          setState(() {
                            isPlaying = false;
                          });
                        } else {
                          await audioPlayer.play(UrlSource(text));
                          setState(() {
                            isPlaying = true;
                          });
                        }
                      },
                      icon: isPlaying
                          ? Icon(Icons.pause_circle)
                          : Icon(Icons.play_circle),
                    );
                  });
  }
}
