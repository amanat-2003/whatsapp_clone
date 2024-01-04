import 'package:whatsapp_clone/common/enums/message_type.dart';

class MessageModel {
  final String text;
  final DateTime time;
  final String messageId;
  final bool isSeen;
  final String senderUserId;
  final String receiverUserId;
  final MessageType messageType;

  MessageModel({
    required this.text,
    required this.time,
    required this.messageId,
    required this.isSeen,
    required this.senderUserId,
    required this.receiverUserId,
    required this.messageType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'time': time.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
      'senderUserId': senderUserId,
      'receiverUserId': receiverUserId,
      'messageType': messageType.stringValue,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      text: map['text'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      messageId: map['messageId'] as String,
      isSeen: map['isSeen'] as bool,
      senderUserId: map['senderUserId'] as String,
      receiverUserId: map['receiverUserId'] as String,
      messageType: (map['messageType'] as String).toMessageType(),
    );
  }
}
