import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/enums/message_type.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/status/controller/status_controller.dart';

class AddStatusScreen extends ConsumerWidget {
  static const routeName = "/add-status-screen";
  const AddStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // return AddStatusField(receiverUserId: receiverUserId);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 250),
            Center(
              child: SizedBox(
                width: double.maxFinite,
                child: AddStatusField(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddStatusField extends ConsumerStatefulWidget {
  const AddStatusField({
    super.key,
  });

  @override
  ConsumerState<AddStatusField> createState() => _AddStatusFieldState();
}

class _AddStatusFieldState extends ConsumerState<AddStatusField> {
  final _messageController = TextEditingController();
  bool isTypedSomething = false;
  bool isShowEmojiContainer = false;
  FocusNode focusNode = FocusNode();
  bool isRecording = false;
  bool isRecorderInit = false;
  FlutterSoundRecorder? _soundRecorder;

  void uploadGIFStatusEntity() async {
    GiphyGif? gif;

    gif = await pickGIF(context);
    if (gif != null) {
      await ref.read(statusControllerProvider).uploadGIFStatusEntity(
            context: context,
            gifUrl: gif.url,
          );
      showSnackBar(context, "Status successfully uploaded");
      Navigator.pop(context);
    }
  }

  Future<void> _uploadPhotoVideoAudioStatusEntity({
    required File statusMedia,
    required MessageType statusEntityType,
  }) async {
    await ref.read(statusControllerProvider).uploadPhotoVideoAudioStatusEntity(
          context: context,
          statusMedia: statusMedia,
          statusEntityType: statusEntityType,
        );
  }

  Future<void> _uploadAudioStatusEntity({
    required File statusMedia,
  }) async {
    await _uploadPhotoVideoAudioStatusEntity(
      statusMedia: statusMedia,
      statusEntityType: MessageType.audio,
    );
  }

  void uploadVideoStatusEntity() async {
    File? video;

    video = await pickVideoFromGallery(context);
    if (video != null) {
      await _uploadPhotoVideoAudioStatusEntity(
        statusMedia: video,
        statusEntityType: MessageType.video,
      );
      showSnackBar(context, "Status successfully uploaded");
      Navigator.pop(context);
    }
  }

  void uploadImageStatusEntity() async {
    File? image;

    image = await pickImageFromGallery(context);
    if (image != null) {
      await _uploadPhotoVideoAudioStatusEntity(
        statusMedia: image,
        statusEntityType: MessageType.image,
      );
      showSnackBar(context, "Status successfully uploaded");
      Navigator.pop(context);
    }
  }

  void recordAndUploadAudio() async {
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
        await _uploadAudioStatusEntity(statusMedia: File(path));
        showSnackBar(context, "Status successfully uploaded");
        Navigator.pop(context);
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

  void uploadTextStatusEntity() async {
    if (isTypedSomething) {
      await ref.read(statusControllerProvider).uploadTextStatusEntity(
            context: context,
            statusText: _messageController.text,
          );
      setState(() {
        _messageController.text = '';
        isTypedSomething = false;
      });
      showSnackBar(context, "Status successfully uploaded");
      Navigator.pop(context);
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () => uploadGIFStatusEntity(),
                iconSize: 30,
                icon: Icon(
                  Icons.gif,
                  color: Colors.grey,
                ),
              ),
              IconButton(
                iconSize: 30,
                onPressed: () => uploadImageStatusEntity(),
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.grey,
                ),
              ),
              IconButton(
                iconSize: 30,
                onPressed: () => uploadVideoStatusEntity(),
                icon: Icon(
                  Icons.attach_file,
                  color: Colors.grey,
                ),
              ),
              IconButton(
                iconSize: 30,
                onPressed: () => recordAndUploadAudio(),
                icon: isRecording ? Icon(Icons.close) : Icon(Icons.mic),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  maxLines: 5,
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
                    hintText: 'Type a message!',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(
                      left: 20,
                      right: 10,
                      top: 10,
                      bottom: 10,
                    ),
                    suffix: IconButton(
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
                  ),
                ),
              ),
              SizedBox(width: 20),
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
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: isTypedSomething ? () => uploadTextStatusEntity() : null,
            child: Text('Send Text Status'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isTypedSomething ? const Color(0xFF128C7E) : greyColor,
            ),
          ),
        ],
      ),
    );
  }
}
