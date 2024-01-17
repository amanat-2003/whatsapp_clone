import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/strings/strings.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';

final fileUploadRepositoryProvider = Provider(
  (ref) => FileUploadRepository(
    storage: FirebaseStorage.instance,
  ),
);

class FileUploadRepository {
  final FirebaseStorage storage;

  FileUploadRepository({required this.storage});

  Future<String> uploadToFirebaseStorage(
    BuildContext context,
    File? file,
    String path,
  ) async {
    String downloadUrl = errorPicUrl;
    try {
      if (file != null) {
        final task = storage.ref().child(path).putFile(file);
        final snapshot = await task;
        downloadUrl = await snapshot.ref.getDownloadURL();
      } else {
        throw Exception('File to be stored into cloud storage is null');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return downloadUrl;
  }

  Future<void> deleteFromFirebaseStorage(
    BuildContext context,
    String path,
  ) async {
    try {
      final storageRef = storage.ref();
      // Create a reference to the file to delete
      final pathRef = storageRef.child(path);

      // Delete the file
      await pathRef.delete();
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
