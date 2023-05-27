import 'package:flutter/material.dart';
import 'join_complete.dart';
import 'login.dart';
import 'mainPage.dart';

class Join extends StatelessWidget {
  final String name;

  Join({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '회원가입 정보 입력',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            // 이름 입력란
            SizedBox(
              width: 200,  // 원하는 가로 길이를 지정해주세요
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '이름',
                ),
              ),
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
            // 가입하기 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => JoinComplete(),
                  ),
                );
              },
              child: Text('가입하기'),
            ),
          ],
        ),
      ),
    );
  }
}