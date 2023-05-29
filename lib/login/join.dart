import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'join_complete.dart';
import 'login.dart';
import '../mainPage.dart';

class Join extends StatelessWidget {

  Join();

  // 데이터베이스에 회원 정보를 저장하는 메서드
  void saveUserData(String name, String id, String password) async {
    final settings = ConnectionSettings(
      host: 'orion.mokpo.ac.kr',
      port: 8381,
      user: 'root',
      password: 'ScE1234**',
      db: 'Travelplus',
    );

    final conn = await MySqlConnection.connect(settings);

    try {
      final result = await conn.query(
        'INSERT INTO User (user_id, user_pw, user_name) VALUES (?, ?, ?)',
        [name, id, password],
      );

      if (result?.affectedRows != null && result!.affectedRows! > 0) {
        print('User data saved successfully');
      } else {
        print('Failed to save user data');
      }
    } catch (e) {
      print('Error saving user data: $e');
    } finally {
      await conn.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController idController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

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
                controller: nameController,
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
            // 가입하기 버튼
            ElevatedButton(
              onPressed: () {
                String name = nameController.text;
                String id = idController.text;
                String password = passwordController.text;
                saveUserData(name, id, password);

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