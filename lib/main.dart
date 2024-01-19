import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/auth/repository/is_loggedin_provider.dart';
import 'package:whatsapp_clone/features/landing/screens/landing_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:whatsapp_clone/features/loading/providers/is_loading_provider.dart';
import 'package:whatsapp_clone/features/loading/screens/loading_overlay.dart';
import 'package:whatsapp_clone/router.dart';
import 'package:whatsapp_clone/screens/mobile_layout_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WorldApp',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: Overlay(initialEntries: [
        OverlayEntry(builder: (context) {
          return Consumer(builder: (_, ref, child) {
            ref.listen(isLoadingProvider, (__, isLoading) {
              if (isLoading) {
                LoadingOver.instance().show(context: context);
              } else {
                LoadingOver.instance().hide();
              }
            });

            final isLoggedIn = ref.watch(isLoggedInProvider);

            if (isLoggedIn) {
              return const MobileLayoutScreen();
            } else {
              return const LandingScreen();
            }

            // return ref.watch(getCurrentUserProvider).when(
            //   data: (user) {
            //     if (user == null) {
            //       return const LandingScreen();
            //     } else {
            //       return const MobileLayoutScreen();
            //     }
            //   },
            //   error: (error, stackTrace) {
            //     return ErrorScreen(
            //       error: error.toString(),
            //     );
            //   },
            //   loading: () {
            //     return LoadingScreen();
            //   },
            // );
          });
        }),
      ]),
      onGenerateRoute: generateRoute,
    );
  }
}
