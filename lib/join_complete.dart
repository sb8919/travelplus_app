import 'package:flutter/material.dart';
import 'package:travel_login2/login.dart.';
import 'package:travel_login2/mainPage.dart';

class JoinComplete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입 완료'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '회원가입을 축하합니다!',
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