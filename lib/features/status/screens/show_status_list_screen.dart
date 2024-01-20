import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/status/controller/status_controller.dart';
import 'package:whatsapp_clone/features/status/screens/show_status_screen.dart';

class ShowStatusListScreen extends ConsumerWidget {
  static const routeName = "/show-status-list-screen";

  const ShowStatusListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: StreamBuilder(
      stream: ref
          .watch(statusControllerProvider)
          .getStatusModelList(context: context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loader();
        } else {
          final statusModelList = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: statusModelList.length,
              itemBuilder: (context, index) {
                final statusModel = statusModelList[index];
                // if (statusModel
                //     .statusEntities[statusModel.statusEntities.length - 1].timePosted
                //     .isBefore(
                //   DateTime.now().subtract(
                //     Duration(
                //       hours: 24,
                //     ),
                //   ),
                // )) {
                //   return SizedBox();
                // } else {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ShowStatusScreen.routeName,
                            arguments: statusModel,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            title: Text(
                              statusModel.userModel.name,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            // subtitle: Padding(
                            //   padding: const EdgeInsets.only(top: 6.0),
                            //   child: Text(
                            //     statusModel.userModel.phoneNumber,
                            //     style: const TextStyle(fontSize: 15),
                            //   ),
                            // ),
                            leading: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                statusModel.userModel.profilePic,
                              ),
                              radius: 30,
                            ),
                            trailing: Text(
                              DateFormat('EEEE, h:mm a').format(
                                  statusModel.statusEntities[0].timePosted),
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
                // }
              },
            ),
          );
        }
      },
    ));
  }
}
