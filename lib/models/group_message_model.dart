// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:whatsapp_clone/common/enums/message_type.dart';
import 'package:whatsapp_clone/models/message_reply.dart';

class GroupMessageModel {
  final String text;
  final DateTime time;
  final String messageId;
  final String senderUserId;
  final String senderUserName;
  final String groupId;
  final MessageType messageType;
  final MessageReplyModel messageReplyModel;

  GroupMessageModel({
    required this.text,
    required this.time,
    required this.messageId,
    required this.senderUserId,
    required this.senderUserName,
    required this.groupId,
    required this.messageType,
    required this.messageReplyModel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'time': time.millisecondsSinceEpoch,
      'messageId': messageId,
      'senderUserId': senderUserId,
      'senderUserName': senderUserName,
      'groupId': groupId,
      'messageType': messageType.stringValue,
      'messageReplyModel': messageReplyModel.toMap(),
    };
  }

  factory GroupMessageModel.fromMap(Map<String, dynamic> map) {
    return GroupMessageModel(
      text: map['text'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      messageId: map['messageId'] as String,
      senderUserId: map['senderUserId'] as String,
      senderUserName: map['senderUserName'] as String,
      groupId: map['groupId'] as String,
      messageType: (map['messageType'] as String).toMessageType(),
      messageReplyModel: MessageReplyModel.fromMap(
          map['messageReplyModel'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupMessageModel.fromJson(String source) =>
      GroupMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GroupMessageModel(text: $text, time: $time, messageId: $messageId, senderUserId: $senderUserId, senderUserName: $senderUserName, groupId: $groupId, messageType: $messageType, messageReplyModel: $messageReplyModel)';
  }
}
