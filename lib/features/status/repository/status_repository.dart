// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:developer';
// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:uuid/uuid.dart';

// import 'package:whatsapp_clone/common/enums/message_type.dart';
// import 'package:whatsapp_clone/common/repository/file_upload_repository.dart';
// import 'package:whatsapp_clone/common/utils/utils.dart';
// import 'package:whatsapp_clone/models/status_model.dart';
// import 'package:whatsapp_clone/models/user_model.dart';

// final statusRepositoryProvider = Provider((ref) => StatusRepository(
//       auth: FirebaseAuth.instance,
//       firestore: FirebaseFirestore.instance,
//       ref: ref,
//     ));

// class StatusRepository {
//   final FirebaseAuth auth;
//   final FirebaseFirestore firestore;
//   final ProviderRef ref;

//   StatusRepository({
//     required this.auth,
//     required this.firestore,
//     required this.ref,
//   });

//   Future<void> uploadGIFStatusEntity({
//     required BuildContext context,
//     required UserModel userModel,
//     required String gifUrl,
//   }) async {
//     final indexOfId = gifUrl.lastIndexOf('-') + 1;

//     final idPart = gifUrl.substring(indexOfId);

//     final actualGIFUrl = "https://i.giphy.com/media/$idPart/200.gif";

//     final statusEntityId = Uuid().v1();

//     await _uploadStatusEntity(
//       context: context,
//       userModel: userModel,
//       statusMediaText: actualGIFUrl,
//       statusEntityType: MessageType.gif,
//       statusEntityId: statusEntityId,
//     );
//   }

//   Future<void> uploadTextStatusEntity({
//     required BuildContext context,
//     required UserModel userModel,
//     required String statusText,
//   }) async {
//     final statusEntityId = Uuid().v1();

//     await _uploadStatusEntity(
//       context: context,
//       userModel: userModel,
//       statusMediaText: statusText,
//       statusEntityType: MessageType.text,
//       statusEntityId: statusEntityId,
//     );
//   }

//   Future<void> uploadPhotoVideoAudioStatusEntity({
//     required BuildContext context,
//     required UserModel userModel,
//     required File statusMedia,
//     required MessageType statusEntityType,
//   }) async {
//     try {
//       final statusEntityId = Uuid().v1();
//       final fileUrl = await ref
//           .read(fileUploadRepositoryProvider)
//           .uploadToFirebaseStorage(context, statusMedia,
//               "status/${statusEntityType.stringValue}/${userModel.uid}/${statusEntityId}");

//       await _uploadStatusEntity(
//         context: context,
//         userModel: userModel,
//         statusMediaText: fileUrl,
//         statusEntityType: statusEntityType,
//         statusEntityId: statusEntityId,
//       );
//     } catch (e) {
//       showSnackBar(context, e.toString());
//     }
//   }

//   Future<void> _uploadStatusEntity({
//     required BuildContext context,
//     required UserModel userModel,
//     required String statusMediaText,
//     required MessageType statusEntityType,
//     required String statusEntityId,
//   }) async {
//     try {
//       final time = DateTime.now();

//       final statusEntity = StatusEntity(
//         statusEntityId: statusEntityId,
//         statusEntityType: statusEntityType,
//         statusMediaText: statusMediaText,
//         timePosted: time,
//       );

//       final statusModelDocs = await firestore
//           .collection('status')
//           .where(
//             'userId',
//             isEqualTo: userModel.uid,
//           )
//           .get();

//       if (statusModelDocs.docs.isNotEmpty) {
//         log("Status Model already present");
//         final statusModelDownloaded =
//             StatusModel.fromMap(statusModelDocs.docs[0].data());

//         List<StatusEntity> statusEntities =
//             statusModelDownloaded.statusEntities;

//         statusEntities.add(statusEntity);

//         List<StatusEntity> filteredStatusEntities = [];

//         for (var i in statusEntities) {
//           if (i.timePosted.isBefore(
//             DateTime.now().subtract(Duration(hours: 24)),
//           )) {
//             if (i.statusEntityType == MessageType.image ||
//                 i.statusEntityType == MessageType.video ||
//                 i.statusEntityType == MessageType.audio)
//               await ref
//                   .watch(fileUploadRepositoryProvider)
//                   .deleteFromFirebaseStorage(
//                     context,
//                     "status/${i.statusEntityType.stringValue}/${userModel.uid}/${i.statusEntityId}",
//                   );
//           } else {
//             filteredStatusEntities.add(i);
//           }
//         }

//         await firestore.collection('status').doc(userModel.uid).update({
//           "statusEntities": filteredStatusEntities
//               .map((statusEntity) => statusEntity.toMap())
//               .toList(),
//         });
//         return;
//       } else {
//         log("Status Model absent");
//         List<String> contactsThisStatusVisibleTo = [];

//         List<Contact> contactsList = [];

//         if (await FlutterContacts.requestPermission()) {
//           contactsList = await FlutterContacts.getContacts(
//             withProperties: true,
//             withPhoto: true,
//           );
//         }

//         for (var contact in contactsList) {
//           final registeredUserDocs = await firestore
//               .collection('users')
//               .where('phoneNumber',
//                   isEqualTo: contact.phones[0].normalizedNumber)
//               .get();

//           if (registeredUserDocs.docs.isNotEmpty) {
//             final registeredUser =
//                 UserModel.fromMap(registeredUserDocs.docs[0].data());

//             final registeredUserId = registeredUser.uid;

//             contactsThisStatusVisibleTo.add(registeredUserId);
//           }
//         }

//         final statusModelToBeUploaded = StatusModel(
//           userModel: userModel,
//           statusId: userModel.uid,
//           visibleTo: contactsThisStatusVisibleTo,
//           statusEntities: [statusEntity],
//         );

//         await firestore
//             .collection('status')
//             .doc(userModel.uid)
//             .set(statusModelToBeUploaded.toMap());
//       }
//     } catch (e) {
//       showSnackBar(
//         context,
//         e.toString(),
//       );
//     }
//   }

//   Stream<List<StatusModel>> getStatusModelList(
//       {required BuildContext context}) {
//     try {
//       return firestore.collection('status').snapshots().asyncMap(
//         (event) {
//           List<StatusModel> statusModelList = [];
//           for (var document in event.docs) {
//             statusModelList.add(
//               StatusModel.fromMap(
//                 document.data(),
//               ),
//             );
//           }
//           return statusModelList;
//         },
//       );
//     } catch (e) {
//       showSnackBar(context, e.toString());
//       return Stream<List<StatusModel>>.value([]);
//     }
//   }
// }

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:whatsapp_clone/common/enums/message_type.dart';
import 'package:whatsapp_clone/common/repository/file_upload_repository.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/status_model.dart';
import 'package:whatsapp_clone/models/user_model.dart';

final statusRepositoryProvider = Provider((ref) => StatusRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      ref: ref,
    ));

final statusLoadingProvider = StateProvider<bool>((ref) => false);

class StatusRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final ProviderRef ref;

  StatusRepository({
    required this.auth,
    required this.firestore,
    required this.ref,
  });

  set isLoading(bool val) {
    ref.read(statusLoadingProvider.notifier).update((state) => val);
  }

  void uploadGIFStatusEntity({
    required BuildContext context,
    required UserModel userModel,
    required String gifUrl,
  }) async {
    isLoading = true;
    ref.read(statusLoadingProvider.notifier).state = true;
    final indexOfId = gifUrl.lastIndexOf('-') + 1;

    final idPart = gifUrl.substring(indexOfId);

    final actualGIFUrl = "https://i.giphy.com/media/$idPart/200.gif";

    final statusEntityId = Uuid().v1();

    _uploadStatusEntity(
      context: context,
      userModel: userModel,
      statusMediaText: actualGIFUrl,
      statusEntityType: MessageType.gif,
      statusEntityId: statusEntityId,
    );
    isLoading = false;
  }

  void uploadTextStatusEntity({
    required BuildContext context,
    required UserModel userModel,
    required String statusText,
  }) async {
    isLoading = true;
    final statusEntityId = Uuid().v1();

    _uploadStatusEntity(
      context: context,
      userModel: userModel,
      statusMediaText: statusText,
      statusEntityType: MessageType.text,
      statusEntityId: statusEntityId,
    );
    isLoading = false;
  }

  void uploadPhotoVideoAudioStatusEntity({
    required BuildContext context,
    required UserModel userModel,
    required File statusMedia,
    required MessageType statusEntityType,
  }) async {
    try {
      isLoading = true;
      final statusEntityId = Uuid().v1();
      final fileUrl = await ref
          .read(fileUploadRepositoryProvider)
          .uploadToFirebaseStorage(context, statusMedia,
              "status/${statusEntityType.stringValue}/${userModel.uid}/${statusEntityId}");

      _uploadStatusEntity(
        context: context,
        userModel: userModel,
        statusMediaText: fileUrl,
        statusEntityType: statusEntityType,
        statusEntityId: statusEntityId,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    } finally {
      isLoading = false;
    }
  }

  void _uploadStatusEntity({
    required BuildContext context,
    required UserModel userModel,
    required String statusMediaText,
    required MessageType statusEntityType,
    required String statusEntityId,
  }) async {
    try {
      isLoading = true;
      final time = DateTime.now();

      final statusEntity = StatusEntity(
        statusEntityId: statusEntityId,
        statusEntityType: statusEntityType,
        statusMediaText: statusMediaText,
        timePosted: time,
      );

      final statusModelDocs = await firestore
          .collection('status')
          .where(
            'userId',
            isEqualTo: userModel.uid,
          )
          .get();

      if (statusModelDocs.docs.isNotEmpty) {
        log("Status Model already present");
        final statusModelDownloaded =
            StatusModel.fromMap(statusModelDocs.docs[0].data());

        List<StatusEntity> statusEntities =
            statusModelDownloaded.statusEntities;

        statusEntities.add(statusEntity);

        List<StatusEntity> filteredStatusEntities = [];

        for (var i in statusEntities) {
          if (i.timePosted.isBefore(
            DateTime.now().subtract(Duration(hours: 12)),
          )) {
            if (i.statusEntityType == MessageType.image ||
                i.statusEntityType == MessageType.video ||
                i.statusEntityType == MessageType.audio)
              await ref
                  .watch(fileUploadRepositoryProvider)
                  .deleteFromFirebaseStorage(
                    context,
                    "status/${i.statusEntityType.stringValue}/${userModel.uid}/${i.statusEntityId}",
                  );
          } else {
            filteredStatusEntities.add(i);
          }
        }

        await firestore.collection('status').doc(userModel.uid).update({
          "statusEntities": filteredStatusEntities
              .map((statusEntity) => statusEntity.toMap())
              .toList(),
        });
        filteredStatusEntities = [];
        return;
      } else {
        log("Status Model absent");
        List<String> contactsThisStatusVisibleTo = [];

        List<Contact> contactsList = [];

        if (await FlutterContacts.requestPermission()) {
          contactsList = await FlutterContacts.getContacts(
            withProperties: true,
            withPhoto: true,
          );
        }

        for (var contact in contactsList) {
          final registeredUserDocs = await firestore
              .collection('users')
              .where('phoneNumber',
                  isEqualTo: contact.phones[0].normalizedNumber)
              .get();

          if (registeredUserDocs.docs.isNotEmpty) {
            final registeredUser =
                UserModel.fromMap(registeredUserDocs.docs[0].data());

            final registeredUserId = registeredUser.uid;

            contactsThisStatusVisibleTo.add(registeredUserId);
          }
        }

        final statusModelToBeUploaded = StatusModel(
          userModel: userModel,
          statusId: userModel.uid,
          visibleTo: contactsThisStatusVisibleTo,
          statusEntities: [statusEntity],
        );

        await firestore
            .collection('status')
            .doc(userModel.uid)
            .set(statusModelToBeUploaded.toMap());
      }
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    } finally {
      isLoading = false;
    }
  }

  Stream<List<StatusModel>> getStatusModelList(
      {required BuildContext context}) {
    try {
      return firestore.collection('status').snapshots().asyncMap(
        (event) {
          List<StatusModel> statusModelList = [];
          for (var document in event.docs) {
            statusModelList.add(
              StatusModel.fromMap(
                document.data(),
              ),
            );
          }
          return statusModelList;
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
      return Stream<List<StatusModel>>.value([]);
    }
  }
}
