import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';

final selectContactsRepositoryProvider = Provider(
  (ref) => SelectContactsRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class SelectContactsRepository {
  final FirebaseFirestore firestore;

  SelectContactsRepository({required this.firestore});

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      final usersCollection = await firestore.collection('users').get();
      bool isFound = false;
      for (var document in usersCollection.docs) {
        final userModel = UserModel.fromMap(document.data());
        // debugPrint(selectedContact.phones.toString());
        String selectedContactNumber =
            selectedContact.phones[0].normalizedNumber.replaceAll(" ", "");
        debugPrint(selectedContactNumber);

        if (selectedContactNumber[0] != '+') {
          selectedContactNumber = '+91' + selectedContactNumber;
        }

        if (userModel.phoneNumber == selectedContactNumber) {
          isFound = true;
          Navigator.of(context)
              .pushNamed(MobileChatScreen.routeName, arguments: {
            'name': userModel.name,
            'uid': userModel.uid,
          });
        }
      }
      if (!isFound) {
        showSnackBar(
            context, '${selectedContact.displayName} is not on WorldApp');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<Contact>> getContacts(
      // BuildContext context,
      ) async {
    late List<Contact> contactsList = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contactsList = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
          withThumbnail: true,
        );
      }
    } catch (e) {
      // showSnackBar(context, e.toString());
      debugPrint(e.toString());
    }
    return contactsList;
  }
}
