import 'package:flutter/material.dart';
import 'package:travel_login2/login/join_complete.dart';

import 'login/login_complete.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메인화면'),
      ),
      body: Center(
        child: Text(
          '메인화면',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}