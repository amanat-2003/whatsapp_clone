// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp_clone/common/enums/message_type.dart';
import 'package:whatsapp_clone/features/status/widgets/automatic_music_playing_widget.dart';

import 'package:whatsapp_clone/models/status_model.dart';

class ShowStatusScreen extends StatefulWidget {
  static const routeName = "/show-status-screen";

  final StatusModel statusModel;
  const ShowStatusScreen({
    Key? key,
    required this.statusModel,
  }) : super(key: key);

  @override
  State<ShowStatusScreen> createState() => _ShowStatusScreenState();
}

class _ShowStatusScreenState extends State<ShowStatusScreen> {
  final controller = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
    initStoryItems();
  }

  Color getRandomColor() {
    final List<Color> colorList = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
    ];

    final Random random = Random();
    final int randomIndex = random.nextInt(colorList.length);

    return colorList[randomIndex];
  }

  void initStoryItems() async {
    for (var statusEntity in widget.statusModel.statusEntities) {
      if (statusEntity.statusEntityType == MessageType.text) {
        storyItems.add(
          StoryItem.text(
              title: statusEntity.statusMediaText,
              backgroundColor: getRandomColor(),
              textStyle: TextStyle(fontSize: 30)),
        );
      } else if (statusEntity.statusEntityType == MessageType.image) {
        storyItems.add(StoryItem.pageImage(
          url: statusEntity.statusMediaText,
          controller: controller,
        ));
      } else if (statusEntity.statusEntityType == MessageType.video) {
        storyItems.add(StoryItem.pageVideo(
          statusEntity.statusMediaText,
          controller: controller,
        ));
      } else if (statusEntity.statusEntityType == MessageType.gif) {
        storyItems.add(StoryItem.pageImage(
          url: statusEntity.statusMediaText,
          controller: controller,
        ));
      } else if (statusEntity.statusEntityType == MessageType.audio) {
        // AudioPlayer audioPlayer = AudioPlayer();
        // await audioPlayer.setSourceUrl(statusEntity.statusMediaText);
        // final duration = await audioPlayer.getDuration();
        // dev.log("Duration is "+(duration?.toString()??"null"));

        storyItems.add(
          StoryItem(
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(color: getRandomColor()),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200),
                child: AutomaticAudioPlayingWidget(
                  audioUrl: statusEntity.statusMediaText,
                ),
              ),
            ),
            duration: Duration(seconds: 60),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryView(
        storyItems: storyItems,
        controller: controller,
        onComplete: () {
          Navigator.pop(context);
        },
        onVerticalSwipeComplete: (direction) {
          if (direction == Direction.down) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
