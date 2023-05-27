import 'package:flutter/material.dart';
import 'package:travel_login2/join.dart';
import 'package:travel_login2/login_complete.dart';
import 'package:travel_login2/mainPage.dart';

class Login extends StatelessWidget {
  final String name;

  Login({required this.name});

  // 데이터베이스에 로그인 정보를 확인하는 메서드
  void login(String id, String password) {
    // 여기에 데이터베이스 로그인 로직을 구현하세요.
    print('ID: $id');
    print('Password: $password');
    // 데이터베이스에 로그인 정보를 확인하는 로직을 추가하세요.
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController idController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

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
                controller: idController,
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
                controller: passwordController,
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
                String id = idController.text;
                String password = passwordController.text;
                login(id, password);

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