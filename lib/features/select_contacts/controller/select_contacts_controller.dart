import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/features/select_contacts/repository/select_contacts_repository.dart';

final getContactsProvider = FutureProvider(
  (ref) => ref.watch(selectContactsRepositoryProvider).getContacts(),
);

final selectContactsControllerProvider = Provider(
  (ref) => SelectContactsController(
    ref: ref,
    selectContactsRepository: ref.watch(selectContactsRepositoryProvider),
  ),
);

class SelectContactsController {
  final ProviderRef ref;
  final SelectContactsRepository selectContactsRepository;

  SelectContactsController({
    required this.ref,
    required this.selectContactsRepository,
  });

  void selectContact(Contact selectedContact, BuildContext context) {
    selectContactsRepository.selectContact(selectedContact, context);
  }

  // Future<List<Contact>> getContacts(
  //   BuildContext context,
  // ) {
  //   return ref.watch(selectContactsRepositoryProvider).getContacts(context);
  // }
}
