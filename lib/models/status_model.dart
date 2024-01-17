// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:whatsapp_clone/common/enums/message_type.dart';
import 'package:whatsapp_clone/models/user_model.dart';

class StatusModel {
  final UserModel userModel;
  final String statusId;
  final List<String> visibleTo;
  final List<StatusEntity> statusEntities;

  StatusModel({
    required this.userModel,
    required this.statusId,
    required this.visibleTo,
    required this.statusEntities,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userModel': userModel.toMap(),
      'userId': statusId,
      'visibleTo': visibleTo,
      'statusEntities': statusEntities.map((x) => x.toMap()).toList(),
    };
  }

  factory StatusModel.fromMap(Map<String, dynamic> map) {
    return StatusModel(
      userModel: UserModel.fromMap(map['userModel'] as Map<String, dynamic>),
      statusId: map['userId'] as String,
      visibleTo: List<String>.from((map['visibleTo'] as List<dynamic>)),
      statusEntities: List<StatusEntity>.from(
        (map['statusEntities'] as List<dynamic>).map<StatusEntity>(
          (statusEntityMap) =>
              StatusEntity.fromMap(statusEntityMap as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory StatusModel.fromJson(String source) =>
      StatusModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StatusModel(userModel: $userModel, userId: $statusId, visibleTo: $visibleTo, statusEntities: $statusEntities)';
  }
}

class StatusEntity {
  final MessageType statusEntityType;
  final String statusMediaText;
  final DateTime timePosted;
  final String statusEntityId;

  StatusEntity({
    required this.statusEntityType,
    required this.statusMediaText,
    required this.timePosted,
    required this.statusEntityId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'statusEntityType': statusEntityType.stringValue,
      'statusMediaText': statusMediaText,
      'statusEntityId': statusEntityId,
      'timePosted': timePosted.millisecondsSinceEpoch,
    };
  }

  factory StatusEntity.fromMap(Map<String, dynamic> map) {
    return StatusEntity(
      statusEntityType: (map['statusEntityType'] as String).toMessageType(),
      statusMediaText: map['statusMediaText'] as String,
      statusEntityId: map['statusEntityId'] as String,
      timePosted: DateTime.fromMillisecondsSinceEpoch(map['timePosted'] as int),
    );
  }

  @override
  String toString() {
    return 'StatusEntity(statusEntityType: $statusEntityType, statusMediaText: $statusMediaText, timePosted: $timePosted, statusEntityId: $statusEntityId)';
  }
}
