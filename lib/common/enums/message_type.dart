enum MessageType {
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif');

  final String stringValue;
  const MessageType(this.stringValue);
}

extension StringToMessageType on String {
  MessageType toMessageType() {
    switch (this) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      case 'audio':
        return MessageType.audio;
      case 'video':
        return MessageType.video;
      case 'gif':
        return MessageType.gif;
      default:
        return MessageType.text;
    }
  }
}
