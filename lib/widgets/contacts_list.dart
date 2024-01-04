import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_clone/models/contact_chat.dart';


class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<ContactChat>>(
        stream:
            ref.watch(chatControllerProvider).getContactChats(context: context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader();
          } else {
            final contactChatsList = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: contactChatsList.length,
                      itemBuilder: (context, index) {
                        final contactChat = contactChatsList[index];
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, MobileChatScreen.routeName,
                                    arguments: {
                                      'name': contactChat.name,
                                      'uid': contactChat.contactId,
                                    });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: ListTile(
                                  title: Text(
                                    contactChat.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      contactChat.text,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      contactChat.profilePic,
                                    ),
                                    radius: 30,
                                  ),
                                  trailing: Text(
                                    DateFormat('h:mm a')
                                        .format(contactChat.time),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(color: dividerColor, indent: 85),
                          ],
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: ref.read(authControllerProvider).logOut,
                    child: Text('Logout'),
                  ),
                ],
              ),
            );
          }
        });
  }
}
