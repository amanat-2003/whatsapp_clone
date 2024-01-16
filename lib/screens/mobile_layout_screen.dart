import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whatsapp_clone/widgets/contacts_list.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  static const routeName = "/mobile-layout-screen";
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserOnlineState(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserOnlineState(false);
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: FutureBuilder(
              future: ref.watch(authControllerProvider).getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                    'how are you?',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return Text(
                    'how are you? ${snapshot.data!.name}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
              }),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
              Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body: const ContactsList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(SelectContactsScreen.routeName),
          backgroundColor: tabColor,
          child: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
