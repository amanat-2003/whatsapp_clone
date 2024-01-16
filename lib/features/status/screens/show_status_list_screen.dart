import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowStatusListScreen extends ConsumerWidget {
  static const routeName = "/show-status-list-screen";

  const ShowStatusListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(body: Center(child: Text('Show Status List Screen'),),);
  }
}