import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/screens/error_screen.dart';
import 'package:whatsapp_clone/common/screens/loading_screen.dart';
import 'package:whatsapp_clone/features/select_contacts/controller/select_contacts_controller.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const routeName = "/select-contacts-screen";
  const SelectContactsScreen({super.key});

  void onSelectContact({
    required Contact selectedContact,
    required WidgetRef ref,
    required BuildContext context,
  }) {
    ref
        .read(selectContactsControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Contacts'),
        backgroundColor: backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
        data: (contactsList) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final contact = contactsList[index];
              return InkWell(
                onTap: () => onSelectContact(
                  context: context,
                  ref: ref,
                  selectedContact: contact,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(contact.displayName),
                    leading: contact.photo == null
                        ? (contact.thumbnail == null
                            ? null
                            : CircleAvatar(
                                backgroundImage:
                                    MemoryImage(contact.thumbnail!),
                              ))
                        : CircleAvatar(
                            backgroundImage: MemoryImage(contact.photo!),
                          ),
                  ),
                ),
              );
            },
            itemCount: contactsList.length,
          );
        },
        error: (error, stackTrace) {
          return ErrorScreen(
            error: error.toString(),
          );
        },
        loading: () {
          return LoadingScreen();
        },
      ),
    );
  }
}
