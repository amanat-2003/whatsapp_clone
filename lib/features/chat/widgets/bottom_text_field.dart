// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/colors.dart';
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

  void sendMesssage() {
    ref.read(chatControllerProvider).sendMessage(
          context: context,
          text: _messageController.text,
          receiverUserId: widget.receiverUserId,
        );
    setState(() {
      _messageController.text = '';
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
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
                        onPressed: () {},
                        icon: Icon(
                          Icons.emoji_emotions,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
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
                        onPressed: () {},
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
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
              onTap: sendMesssage,
              child: CircleAvatar(
                backgroundColor: const Color(0xFF128C7E),
                radius: 23,
                child: isTypedSomething ? Icon(Icons.send) : Icon(Icons.mic),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
