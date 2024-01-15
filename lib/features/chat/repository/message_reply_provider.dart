import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/models/message_reply.dart';

final messageReplyProvider = StateProvider<MessageReplyModel?>((ref) => null);

void cancelMessageReply(WidgetRef ref) {
  ref.read(messageReplyProvider.notifier).update((state) => null);
}

void setMessageReply(WidgetRef ref, MessageReplyModel messageReply) {
  ref.read(messageReplyProvider.notifier).update((state) => messageReply);
}
