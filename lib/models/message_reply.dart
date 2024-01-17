// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:whatsapp_clone/common/enums/message_type.dart';

class MessageReplyModel {
  final String userId;
  final String userName;
  final bool isMe;
  final MessageType type;
  final String text;

  MessageReplyModel({
    required this.userId,
    required this.userName,
    required this.isMe,
    required this.type,
    required this.text,
  });

  @override
  String toString() {
    return 'MessageReplyModel(userId: $userId, userName: $userName, isMe: $isMe, type: $type, text: $text)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userName': userName,
      'userId': userId,
      'isMe': isMe,
      'type': type.stringValue,
      'text': text,
    };
  }

  factory MessageReplyModel.fromMap(Map<String, dynamic> map) {
    return MessageReplyModel(
      userName: map['userName'] as String,
      userId: map['userId'] as String,
      isMe: map['isMe'] as bool,
      type: (map['type'] as String).toMessageType(),
      text: map['text'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageReplyModel.fromJson(String source) =>
      MessageReplyModel.fromMap(json.decode(source) as Map<String, dynamic>);

  bool get isNull {
    return this.text.isEmpty && this.userName.isEmpty && this.userId.isEmpty;
  }
}
