import 'package:flutter/material.dart';

import '../mainPage.dart';

class LoginComplete extends StatelessWidget {

  LoginComplete();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인 완료'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '환영합니다 !',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => MainPage(),
                  ),
                );
              },
              child: Text('메인화면으로'),
            ),
          ],
        ),
      ),
    );
  }
}