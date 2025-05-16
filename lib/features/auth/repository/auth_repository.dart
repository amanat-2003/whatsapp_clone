// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/common/repository/file_upload_repository.dart';
import 'package:whatsapp_clone/common/strings/strings.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/screens/mobile_layout_screen.dart';


final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  void setUserOnlineState(bool isOnline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }

  void takeToMobileLayoutScreen({
    required BuildContext context,
  }) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        MobileLayoutScreen.routeName, (route) => false);
  }

  Future<bool> userDataAlreadyPresent() async {
    final uid = auth.currentUser!.uid;
    final userData =
        (await firestore.collection('users').doc(uid).get()).data();
    if (userData != null) {
      debugPrint('UserData is not null');
      return true;
    }
    return false;
  }

  void logOut() async {
    await auth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    UserModel? userModel;
    try {
      final userData =
          await firestore.collection('users').doc(auth.currentUser?.uid).get();

      final user = userData.data();

      if (user != null) {
        userModel = UserModel.fromMap(user);
      }
    } catch (e) {
      log(e.toString());
    }

    return userModel;
  }

  Stream<UserModel> userDataStream(String userId) {
    // debugPrint('Nothing completed');
    final a = firestore.collection('users').doc(userId);
    // debugPrint('a completed');
    final b = a.snapshots().map((event) => UserModel.fromMap(event.data()!));
    // debugPrint('b completed');
    // return firestore
    //     .collection('users')
    //     .doc(userId)
    //     .snapshots()
    //     .map((event) => UserModel.fromMap(event.data()!));
    return b;
  }

  void signInWithPhoneNumber(String phoneNumber, BuildContext context) async {
    try {
      auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          await auth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) async {
          throw Exception(error.message);
        },
        codeSent: (verificationId, forceResendingToken) async {
          Navigator.pushNamed(
            context,
            OTPScreen.routeName,
            arguments: verificationId,
          );
        },
        codeAutoRetrievalTimeout: (verificationId) async {},
      );
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.message!);
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String userOTP,
    required String verificationId,
  }) async {
    try {
      final phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(phoneAuthCredential);
      Navigator.pushNamedAndRemoveUntil(
        context,
        UserInformationScreen.routeName,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  void uploadUserDataToFirebase({
    required BuildContext context,
    required String name,
    required File? image,
    required ProviderRef ref,
  }) async {
    try {
      String profilePic = defaultProfilePicUrl;
      final uid = auth.currentUser!.uid;
      final userData =
          (await firestore.collection('users').doc(uid).get()).data();
      if (userData != null) {
        debugPrint('UserData is not null');
        Navigator.of(context).pushNamedAndRemoveUntil(
            MobileLayoutScreen.routeName, (route) => false);
        return;
      }

      if (image != null) {
        profilePic = await ref
            .read(fileUploadRepositoryProvider)
            .uploadToFirebaseStorage(context, image, "profilePics/$uid");
      }

      final user = UserModel(
        uid: uid,
        name: name,
        phoneNumber: auth.currentUser!.phoneNumber!,
        profilePic: profilePic,
        isOnline: true,
        groupsId: [],
      );

      await firestore.collection('users').doc(uid).set(user.toMap());

      showSnackBar(context, 'Your data has been stored');

      Navigator.of(context).pushNamedAndRemoveUntil(
          MobileLayoutScreen.routeName, (route) => false);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
