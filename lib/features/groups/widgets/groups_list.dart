import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/groups/controller/group_controller.dart';
import 'package:whatsapp_clone/features/groups/screens/group_chat_screen.dart';
import 'package:whatsapp_clone/models/group_model.dart';

class GroupsList extends ConsumerWidget {
  const GroupsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<GroupModel>>(
        stream: ref.watch(groupControllerProvider).getGroupModels(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader();
          } else {
            final groupModelsList = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: groupModelsList.length,
                itemBuilder: (context, index) {
                  final groupModel = groupModelsList[index];
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                                    context, GroupChatScreen.routeName,
                                    arguments: {
                                      'groupName': groupModel.groupName,
                                      'groupId': groupModel.groupId,
                                    });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            title: Text(
                              groupModel.groupName,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                groupModel.lastMessageText,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                groupModel.groupProfilePicUrl,
                              ),
                              radius: 30,
                            ),
                            trailing: Text(
                              DateFormat('EEEE, h:mm a')
                                  .format(groupModel.lastMessageTime),
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
            );
          }
        });
  }
}
