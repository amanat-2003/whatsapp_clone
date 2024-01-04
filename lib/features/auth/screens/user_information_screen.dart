import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/strings/strings.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/common/widgets/custom_button.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const routeName = "/user-information-screen";
  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final nameController = TextEditingController();
  File? image;

  void pickImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() {
    final name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .uploadUserDataToFirebase(context, name, image);
    } else {
      showSnackBar(context, 'Please enter a valid name');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              Stack(
                children: [
                  image == null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                            defaultProfilePicUrl,
                          ),
                          radius: 70,
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(image!),
                          radius: 70,
                        ),
                  Positioned(
                    bottom: -10,
                    right: -10,
                    child: IconButton(
                      onPressed: pickImage,
                      icon: Icon(
                        Icons.add_photo_alternate,
                        color: Colors.amber,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: size.width * 0.85,
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      decoration: InputDecoration(hintText: 'Type your name'),
                      controller: nameController,
                    ),
                  ),
                  IconButton(
                    onPressed: storeUserData,
                    icon: Icon(Icons.done),
                  ),
                ],
              ),
              Spacer(),
              FutureBuilder(
                future:
                    ref.watch(authControllerProvider).userDataAlreadyPresent(),
                builder: (context, userDataAlreadyPresentSnapshot) {
                  if (userDataAlreadyPresentSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Loader();
                  } else {
                    return SizedBox(
                      width: size.width * 0.5,
                      child: CustomButton(
                        text: 'Skip',
                        onPressed: userDataAlreadyPresentSnapshot.data == true
                            ? () {
                                ref
                                    .read(authControllerProvider)
                                    .takeToMobileLayoutScreen(context: context);
                              }
                            : null,
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
