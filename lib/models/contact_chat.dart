class ContactChat {
  final String text;
  final DateTime time;
  final String profilePic;
  final String name;
  final String contactId;

  ContactChat({
    required this.text,
    required this.time,
    required this.profilePic,
    required this.name,
    required this.contactId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'time': time.millisecondsSinceEpoch,
      'profilePic': profilePic,
      'name': name,
      'contactId': contactId,
    };
  }

  factory ContactChat.fromMap(Map<String, dynamic> map) {
    return ContactChat(
      text: map['text'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      profilePic: map['profilePic'] as String,
      name: map['name'] as String,
      contactId: map['contactId'] as String,
    );
  }
}
