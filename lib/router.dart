import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/screens/error_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/login_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_clone/features/groups/screens/create_group_screen.dart';
import 'package:whatsapp_clone/features/groups/screens/group_chat_screen.dart';
import 'package:whatsapp_clone/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_clone/features/status/screens/add_status_screen.dart';
import 'package:whatsapp_clone/features/status/screens/show_status_list_screen.dart';
import 'package:whatsapp_clone/features/status/screens/show_status_screen.dart';
import 'package:whatsapp_clone/models/status_model.dart';
import 'package:whatsapp_clone/screens/mobile_layout_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(verificationId: verificationId),
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );
    case MobileLayoutScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const MobileLayoutScreen(),
      );
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );
    case MobileChatScreen.routeName:
      final args = settings.arguments as Map<String, dynamic>;
      final name = args['name'];
      final uid = args['uid'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
        ),
      );
    case GroupChatScreen.routeName:
      final args = settings.arguments as Map<String, dynamic>;
      final groupName = args['groupName'];
      final groupId = args['groupId'];
      return MaterialPageRoute(
        builder: (context) => GroupChatScreen(
          groupName: groupName,
          groupId: groupId,
        ),
      );
    case ShowStatusListScreen.routeName:
      final args = settings.arguments as Map<String, dynamic>;
      final name = args['name'];
      final uid = args['uid'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
        ),
      );
    case AddStatusScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const AddStatusScreen(),
      );
    case ShowStatusScreen.routeName:
      final statusModel = settings.arguments as StatusModel;
      return MaterialPageRoute(
        builder: (context) => ShowStatusScreen(
          statusModel: statusModel,
        ),
      );
    case CreateGroupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => CreateGroupScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(),
        ),
      );
  }
}
