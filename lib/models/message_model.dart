// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:whatsapp_clone/common/enums/message_type.dart';
import 'package:whatsapp_clone/models/message_reply.dart';
import 'package:whatsapp_clone/models/user_model.dart';

class MessageModel {
  final String text;
  final DateTime time;
  final String messageId;
  final bool isSeen;
  final UserModel senderUserModel;
  final UserModel receiverUserModel;
  final MessageType messageType;

  final MessageReplyModel messageReplyModel;

  MessageModel({
    required this.text,
    required this.time,
    required this.messageId,
    required this.isSeen,
    required this.senderUserModel,
    required this.receiverUserModel,
    required this.messageType,
    required this.messageReplyModel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'time': time.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
      'senderUserModel': senderUserModel.toMap(),
      'receiverUserModel': receiverUserModel.toMap(),
      'messageType': messageType.stringValue,
      'messageReplyModel': messageReplyModel.toMap(),
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      text: map['text'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      messageId: map['messageId'] as String,
      isSeen: map['isSeen'] as bool,
      senderUserModel:
          UserModel.fromMap(map['senderUserModel'] as Map<String, dynamic>),
      receiverUserModel:
          UserModel.fromMap(map['receiverUserModel'] as Map<String, dynamic>),
      messageType: (map['messageType'] as String).toMessageType(),
      messageReplyModel: MessageReplyModel.fromMap(
          map['messageReplyModel'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MessageModel(text: $text,\n time: $time, messageId: $messageId,\n isSeen: $isSeen,\n senderUserModel: $senderUserModel,\n receiverUserModel: $receiverUserModel,\n messageType: $messageType,\n messageReplyModel: $messageReplyModel,\n)\n';
  }
}

  // final String repliedMessageUserName;
  // final bool repliedMessageIsMe;
  // final MessageType repliedMessageType;
  // final String repliedMessageText;

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'text': text,
  //     'time': time.millisecondsSinceEpoch,
  //     'messageId': messageId,
  //     'isSeen': isSeen,
  //     'senderUserId': senderUserId,
  //     'receiverUserId': receiverUserId,
  //     'messageType': messageType.stringValue,
  //     'repliedMessageUserName': messageReplyModel.userName,
  //     'repliedMessageIsMe': messageReplyModel.isMe,
  //     'repliedMessageType': messageReplyModel.type,
  //     'repliedMessageText': messageReplyModel.text,
  //   };
  // }

  // factory MessageModel.fromMap(Map<String, dynamic> map) {
  //   return MessageModel(
  //     text: map['text'] as String,
  //     time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
  //     messageId: map['messageId'] as String,
  //     isSeen: map['isSeen'] as bool,
  //     senderUserId: map['senderUserId'] as String,
  //     receiverUserId: map['receiverUserId'] as String,
  //     messageType: (map['messageType'] as String).toMessageType(),
  //     messageReplyModel: MessageReplyModel(
  //       userName: map['repliedMessageUserName'] as String,
  //       isMe: map['repliedMessageIsMe'] as bool,
  //       type: (map['repliedMessageType'] as String).toMessageType(),
  //       text: map['repliedMessageText'] as String,
  //     ),
  //   );
  // }