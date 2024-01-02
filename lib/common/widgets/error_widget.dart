// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ErrorW extends StatelessWidget {
  final String error;
  const ErrorW({
    Key? key,
    this.error= '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Text('Invalid!! Error!!\n$error'),
    );
  }
}
