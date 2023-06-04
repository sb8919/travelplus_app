import 'package:flutter/material.dart';
import 'package:travel_plus/login/join.dart';
import 'package:mysql1/mysql1.dart' as mysql;

import '../mainPage.dart';

class Login extends StatefulWidget {

  Login({String? region, String? city, required String name, required String id, required String password, required List<String> interests});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showErrorDialog = false;

  String user_id = ''; // user_id 변수 추가
  String user_pw = ''; // user_pw 변수 추가

  // 데이터베이스에 로그인 정보를 확인하는 메서드
  Future<void> login(String id, String password) async {
    if (id.isEmpty || password.isEmpty) {
      setState(() {
        showErrorDialog = true;
      });
      return;
    }

    final settings = mysql.ConnectionSettings(
      host: 'orion.mokpo.ac.kr',
      port: 8381,
      user: 'root',
      password: 'ScE1234**',
      db: 'Travelplus',
    );

    final conn = await mysql.MySqlConnection.connect(settings);

    try {
      final result = await conn.query(
        'SELECT * FROM User WHERE user_id = ? AND user_pw = ?',
        [id, password],
      );

      if (result.isNotEmpty) {
        // 로그인 성공
        print('로그인 성공');
        // 로그인 성공에 따른 처리를 추가하세요.

        // 로그인 성공 시 LoginComplete 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MainPage(),
          ),
        );
      } else {
        // 로그인 실패
        print('로그인 실패');
        // 로그인 실패에 따른 처리를 추가하세요.
        setState(() {
          showErrorDialog = true; // 다이얼로그 창을 보여주도록 상태 변경
        });
      }
    } catch (e) {
      // 예외 처리
      print('로그인 에러: $e');
      // 예외 처리에 따른 메시지나 로그를 출력하세요.
    } finally {
      await conn.close(); // 연결 종료
    }
  }

  void dismissErrorDialog() {
    setState(() {
      showErrorDialog = false; // 다이얼로그 창을 닫도록 상태 변경
    });
  }

  @override
  Widget build(BuildContext context) {
    // build 메서드 내에서 user_id와 user_pw 값을 설정
    user_id = idController.text;
    user_pw = passwordController.text;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '로그인',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF4B39EF), // 폰트 색상 변경
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: idController,
                      decoration: InputDecoration(
                        labelText: '아이디',
                        labelStyle: TextStyle(
                          color: Color(0xFF4B39EF), // 폰트 색상 변경
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF4B39EF), // 밑줄 색상 변경
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: '비밀번호',
                        labelStyle: TextStyle(
                          color: Color(0xFF4B39EF), // 폰트 색상 변경
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF4B39EF), // 밑줄 색상 변경
                          ),
                        ),
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      String id = idController.text;
                      String password = passwordController.text;
                      login(id, password);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF4B39EF), // 로그인 버튼 색상 변경
                    ),
                    child: Text('로그인'),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Join(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      primary: Color(0xFF4B39EF), // 회원가입 폰트 색상 변경
                    ),
                    child: Text('회원가입'),
                  ),
                ],
              ),
            ),
          ),
          if (showErrorDialog)
            Positioned.fill(
              child: Container(
                color: Color.fromRGBO(0, 0, 0, 0.5),
                child: Center(
                  child: Container(
                    width: 400,
                    height: 250,
                    child: AlertDialog(
                      title: Text('오류'),
                      content: Center(
                        child: Text('아이디와 비밀번호를 입력해주세요.'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            dismissErrorDialog();
                          },
                          child: Text('확인'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}