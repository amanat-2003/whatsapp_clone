import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/strings/strings.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/common/widgets/custom_button.dart';
import 'package:whatsapp_clone/features/groups/controller/group_controller.dart';
import 'package:whatsapp_clone/features/groups/providers/select_contacts_provider.dart';
import 'package:whatsapp_clone/features/groups/widgets/select_contact_for_group_widget.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  static const routeName = "/create-group-screen";
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  File? image;
  final groupNameController = TextEditingController();

  void pickGroupPhoto() async {
    image = await pickImageFromGallery(context) ?? image;
    setState(() {});
  }

  void pickGroupPhotoCamera() async {
    image = await pickImageFromCamera(context) ?? image;
    setState(() {});
  }

  void createGroup() {
    final selectedContacts = ref.read(selectedContactsProvider);

    if (image != null &&
        groupNameController.text.trim().isNotEmpty &&
        selectedContacts.isNotEmpty) {
      ref.read(groupControllerProvider).createGroup(
            context: context,
            groupProfilePicFile: image!,
            groupName: groupNameController.text.trim(),
            groupMembersContactList: selectedContacts,
          );
    } else {
      showSnackBar(context, "Please enter the fields correctly.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                      right: 30,
                      child: IconButton(
                        onPressed: pickGroupPhotoCamera,
                        icon: Icon(
                          Icons.add_a_photo,
                          color: Colors.amber,
                          size: 30,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: IconButton(
                        onPressed: pickGroupPhoto,
                        icon: Icon(
                          Icons.add_photo_alternate,
                          color: Colors.amber,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: size.width * 0.75,
                  padding: EdgeInsets.only(
                    right: 20,
                    top: 20,
                    bottom: 20,
                  ),
                  child: TextField(
                    decoration:
                        InputDecoration(hintText: 'Type the group name'),
                    controller: groupNameController,
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Select Contacts",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SelectContactForGroupWidget(),
                SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.5,
                  child: CustomButton(
                    text: "Create Group",
                    onPressed: createGroup,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
