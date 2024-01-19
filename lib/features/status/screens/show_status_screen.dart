// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
// import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  String when = "";

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
      if (statusEntity.timePosted
          .isAfter(DateTime.now().subtract(Duration(hours: 24)))) {
        if (statusEntity.statusEntityType == MessageType.text) {
          storyItems.add(
            StoryItem.text(
              title: statusEntity.statusMediaText,
              backgroundColor: getRandomColor(),
              textStyle: TextStyle(fontSize: 30),
            ), 
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
              duration: Duration(seconds: 30),
            ),
          );
        }
      }
    }

    when = DateFormat('EEEE, h:mm a')
        .format(widget.statusModel.statusEntities[0].timePosted);
  }

  Widget _buildProfileView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
          radius: 24,
          backgroundImage:
              NetworkImage(widget.statusModel.userModel.profilePic),
        ),
        SizedBox(
          width: 16,
        ),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black54,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.statusModel.userModel.name,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                when,
                style: TextStyle(
                  color: Colors.white70,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          StoryView(
            storyItems: storyItems,
            controller: controller,
            onComplete: () {
              Navigator.of(context).pop();
            },
            onVerticalSwipeComplete: (v) {
              if (v == Direction.down) {
                Navigator.pop(context);
              }
            },
            onStoryShow: (storyItem) {
              int pos = storyItems.indexOf(storyItem);

              // the reason for doing setState only after the first
              // position is becuase by the first iteration, the layout
              // hasn't been laid yet, thus raising some exception
              // (each child need to be laid exactly once)
              if (pos > 0) {
                setState(() {
                  when = DateFormat('EEEE, h:mm a').format(
                      widget.statusModel.statusEntities[pos].timePosted);
                });
              }
            },
          ),
          Container(
            padding: EdgeInsets.only(
              top: 48,
              left: 16,
              right: 16,
            ),
            child: _buildProfileView(),
          )
        ],
      ),
      // body: StoryView(
      //   storyItems: storyItems,
      //   controller: controller,
      //   onComplete: () {
      //     Navigator.pop(context);
      //   },
      //   onVerticalSwipeComplete: (direction) {
      //     if (direction == Direction.down) {
      //       Navigator.pop(context);
      //     }
      //   },
      // ),
    );
  }
}
