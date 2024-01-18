// import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AutomaticAudioPlayingWidget extends StatefulWidget {
  final String audioUrl;
  const AutomaticAudioPlayingWidget({
    Key? key,
    required this.audioUrl,
  }) : super(key: key);

  @override
  State<AutomaticAudioPlayingWidget> createState() =>
      _AutomaticAudioPlayingWidgetState();
}

class _AutomaticAudioPlayingWidgetState
    extends State<AutomaticAudioPlayingWidget> {
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    initAudio();
  }

  void initAudio() async {
    // await audioPlayer.setSourceUrl(widget.audioUrl);
    // final duration = await audioPlayer.getDuration();
    // log("Duration is "+(duration?.toString()??"null"));
    await audioPlayer.play(UrlSource(widget.audioUrl));
  }

  @override
  void dispose() {
    audioPlayer.pause();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.music_note,
      size: 40,
      color: Colors.white,
    );
  }
}
