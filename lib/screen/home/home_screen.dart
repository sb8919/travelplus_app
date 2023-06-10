import 'package:flutter/material.dart';
import 'body.dart';

class HomeScreen extends StatelessWidget {
  final String user_id;

  HomeScreen({required this.user_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade200, // 어두운 흰색 배경 적용
        child: Body(user_id: user_id),
      ),
    );
  }
}
