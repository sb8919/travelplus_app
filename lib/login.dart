import 'package:flutter/material.dart';
import 'package:travel_login2/join.dart';
import 'package:travel_login2/login_complete.dart';
import 'package:travel_login2/mainPage.dart';

class Login extends StatelessWidget {
  final String name;

  Login({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인을 해주세요.'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '로그인',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            // 아이디 입력란
            SizedBox(
              width: 200,  // 원하는 가로 길이를 지정해주세요
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '아이디',
                ),
              ),
            ),
            SizedBox(height: 16),
            // 비밀번호 입력란
            SizedBox(
              width: 200,  // 원하는 가로 길이를 지정해주세요
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '비밀번호',
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: 16),
            // 로그인 버튼
            ElevatedButton(
              onPressed: () {
                // 로그인 버튼 동작
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginComplete(name: name),
                  ),
                );
              },
              child: Text('로그인'),
            ),
            SizedBox(height: 16),
            // 회원가입 버튼
            TextButton(
              onPressed: () {
                // 회원가입 버튼 동작
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Join(name: name),
                  ),
                );
              },
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}