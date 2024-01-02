import 'package:flutter/material.dart';

class UserInformationScreen extends StatefulWidget {
  static const routeName = "/user-information-screen";
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final nameController = TextEditingController();

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
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://thumbs.dreamstime.com/b/man-student-icon-solid-style-any-projects-man-student-icon-solid-style-any-projects-use-website-mobile-app-193904943.jpg',
                    ),
                    radius: 70,
                  ),
                  Positioned(
                    bottom: -10,
                    right: -10,
                    child: IconButton(
                      onPressed: () {},
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
                    onPressed: () {},
                    icon: Icon(Icons.done),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
