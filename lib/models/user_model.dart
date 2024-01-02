// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String uid;
  final String name;
  final String phoneNumber;
  final String profilePic;
  final bool isOnline;
  final List<String> groupsId;

  UserModel({
    required this.uid,
    required this.name,
    required this.phoneNumber,
    required this.profilePic,
    required this.isOnline,
    required this.groupsId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'phoneNumber': phoneNumber,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'groupsId': groupsId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        uid: map['uid'] as String,
        name: map['name'] as String,
        phoneNumber: map['phoneNumber'] as String,
        profilePic: map['profilePic'] as String,
        isOnline: map['isOnline'] as bool,
        groupsId: List<String>.from(
          (map['groupsId']),
        ));
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, phoneNumber: $phoneNumber, profilePic: $profilePic, isOnline: $isOnline, groupsId: $groupsId)';
  }
}
