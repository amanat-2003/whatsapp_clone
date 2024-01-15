// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';

class CachedVideo extends StatefulWidget {
  final String videoUrl;
  const CachedVideo({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<CachedVideo> createState() => _CachedVideoState();
}

class _CachedVideoState extends State<CachedVideo> {
  late CachedVideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: Stack(
            children: [
              _videoController.value.isInitialized
                  ? CachedVideoPlayer(
                      _videoController,
                    )
                  : Loader(),
              Center(
                child: IconButton(
                  iconSize: constraints.maxWidth/7,
                  onPressed: () {
                    setState(() {
                      _videoController.value.isPlaying
                          ? _videoController.pause()
                          : _videoController.play();
                    });
                  },
                  icon: _videoController.value.isPlaying
                      ? Icon(Icons.pause_circle)
                      : Icon(Icons.play_circle),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
