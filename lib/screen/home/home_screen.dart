import 'package:flutter/material.dart';
import 'body.dart';

class HomeScreen extends StatelessWidget {
  final String user_id;

  HomeScreen({required this.user_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(user_id: user_id),
    );
  }
}
