import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/enums/message_type.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';

class BottomTextField extends ConsumerStatefulWidget {
  final String receiverUserId;
  const BottomTextField({
    required this.receiverUserId,
  });

  @override
  ConsumerState<BottomTextField> createState() => _BottomTextFieldState();
}

class _BottomTextFieldState extends ConsumerState<BottomTextField> {
  final _messageController = TextEditingController();
  bool isTypedSomething = false;
  bool isShowEmojiContainer = false;
  FocusNode focusNode = FocusNode();
  bool isRecording = false;
  bool isRecorderInit = false;
  FlutterSoundRecorder? _soundRecorder;

  void sendGIF() async {
    GiphyGif? gif;

    gif = await pickGIF(context);
    if (gif != null) {
      ref.read(chatControllerProvider).sendGIF(
            context: context,
            gifUrl: gif.url,
            receiverUserId: widget.receiverUserId,
          );
    }
  }

  void sendFile({
    required File file,
    required MessageType messageType,
  }) {
    ref.read(chatControllerProvider).sendFileMessage(
          context: context,
          file: file,
          messageType: messageType,
          receiverUserId: widget.receiverUserId,
        );
  }

  void sendAudio({
    required File file,
  }) {
    sendFile(
      file: file,
      messageType: MessageType.audio,
    );
  }

  void sendVideo() async {
    File? video;

    video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFile(
        file: video,
        messageType: MessageType.video,
      );
    }
  }

  void sendImage() async {
    File? image;

    image = await pickImageFromGallery(context);
    if (image != null) {
      sendFile(
        file: image,
        messageType: MessageType.image,
      );
    }
  }

  void sendMesssageOrRecordAudio() async {
    if (isTypedSomething) {
      ref.read(chatControllerProvider).sendMessage(
            context: context,
            text: _messageController.text,
            receiverUserId: widget.receiverUserId,
          );
      setState(() {
        _messageController.text = '';
      });
    } else {
      try {
        if (!isRecorderInit) {
          return;
        }
        final tempDir = await getTemporaryDirectory();
        final path = "${tempDir.path}/temporary_recording.aac";

        if (isRecording) {
          await _soundRecorder!.stopRecorder();
          setState(() {
            isRecording = false;
          });
          sendAudio(file: File(path));
        } else {
          await _soundRecorder!.startRecorder(toFile: path);
          setState(() {
            isRecording = true;
          });
        }
      } catch (e) {
        showSnackBar(context, e.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    initAudioRecorder();
  }

  void initAudioRecorder() async {
    final permissionStatus = await Permission.microphone.request();
    if (permissionStatus != PermissionStatus.granted) {
      return;
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  @override
  void dispose() {
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  focusNode: focusNode,
                  controller: _messageController,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        isTypedSomething = false;
                      });
                    } else {
                      setState(() {
                        isTypedSomething = true;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: mobileChatBoxColor,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isShowEmojiContainer = !isShowEmojiContainer;
                              });
                              if (isShowEmojiContainer) {
                                focusNode.unfocus();
                              } else {
                                focusNode.requestFocus();
                              }
                            },
                            icon: Icon(
                              Icons.emoji_emotions,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: sendGIF,
                            icon: Icon(
                              Icons.gif,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: sendImage,
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: sendVideo,
                            icon: Icon(
                              Icons.attach_file,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    hintText: 'Type a message!',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: GestureDetector(
                  onTap: sendMesssageOrRecordAudio,
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFF128C7E),
                    radius: 23,
                    child: isTypedSomething
                        ? Icon(Icons.send)
                        : isRecording
                            ? Icon(Icons.close)
                            : Icon(Icons.mic),
                  ),
                ),
              ),
            ],
          ),
          if (isShowEmojiContainer)
            SizedBox(
              height: 310,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  setState(() {
                    _messageController.text =
                        _messageController.text + emoji.emoji;
                    isTypedSomething = true;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
