class GroupModel {
  final String groupId;
  final String groupName;
  final String groupProfilePicUrl;
  final List<String> groupMembersIds;
  final String lastMessageUserId;
  final String lastMessageUserName;
  final String lastMessageText;
  final DateTime lastMessageTime;

  GroupModel({
    required this.groupId,
    required this.groupName,
    required this.groupProfilePicUrl,
    required this.groupMembersIds,
    required this.lastMessageUserId,
    required this.lastMessageUserName,
    required this.lastMessageText,
    required this.lastMessageTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupId': groupId,
      'groupName': groupName,
      'groupProfilePic': groupProfilePicUrl,
      'groupMembersIds': groupMembersIds,
      'lastMessageUserId': lastMessageUserId,
      'lastMessageUserName': lastMessageUserName,
      'lastMessageText': lastMessageText,
      'lastMessageTime': lastMessageTime.millisecondsSinceEpoch,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      groupId: map['groupId'] as String,
      groupName: map['groupName'] as String,
      groupProfilePicUrl: map['groupProfilePic'] as String,
      groupMembersIds: List<String>.from((map['groupMembersIds'] as List<dynamic>)),
      lastMessageUserId: map['lastMessageUserId'] as String,
      lastMessageUserName: map['lastMessageUserName'] as String,
      lastMessageText: map['lastMessageText'] as String,
      lastMessageTime: DateTime.fromMillisecondsSinceEpoch(map['lastMessageTime'] as int),
    );
  }
}
