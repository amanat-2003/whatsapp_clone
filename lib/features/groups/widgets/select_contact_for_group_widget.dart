import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/screens/error_screen.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/groups/providers/select_contacts_provider.dart';
import 'package:whatsapp_clone/features/select_contacts/controller/select_contacts_controller.dart';

class SelectContactForGroupWidget extends ConsumerStatefulWidget {
  const SelectContactForGroupWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactForGroupWidgetState();
}

class _SelectContactForGroupWidgetState
    extends ConsumerState<SelectContactForGroupWidget> {
  // List<Contact> selectedContacts = [];

  void addContact(Contact contact) {
    ref
        .read(selectedContactsProvider.notifier)
        .update((state) => [...state, contact]);
  }
  
  void removeContact(Contact contact) {
    ref
        .read(selectedContactsProvider.notifier)
        .update((state) => state..remove(contact));
  }

  @override
  Widget build(BuildContext context) {
    final selectedContacts = ref.watch(selectedContactsProvider);
    return Expanded(
      child: ref.watch(getContactsProvider).when(
        data: (contactList) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final contact = contactList[index];
              bool isSelected =
                  (selectedContacts.contains(contact)) ? true : false;
              return CheckboxListTile(
                title: Text(contact.displayName),
                onChanged: (value) {
                  if (isSelected) {
                    // setState(() {
                    //   selectedContacts.remove(contact);
                    // });
                      removeContact(contact);
                  } else {
                    // setState(() {
                    //   selectedContacts.add(contact);
                    // });
                      addContact(contact);
                  }
                },
                value: isSelected,
              );
            },
            itemCount: contactList.length,
          );
        },
        error: (error, stackTrace) {
          return ErrorScreen(
            error: error.toString(),
          );
        },
        loading: () {
          return Loader();
        },
      ),
    );
  }
}




