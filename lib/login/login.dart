import 'package:flutter/material.dart';
import 'package:travel_plus/login/join.dart';
import 'package:mysql1/mysql1.dart' as mysql;

import '../mainPage.dart';

class Login extends StatefulWidget {

  Login({String? region, String? city});

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
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 16),
                  // 아이디 입력란
                  SizedBox(
                    width: 200,
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
                    width: 200,
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
                          builder: (BuildContext context) => Join(),
                        ),
                      );
                    },
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
                    width: 400, // 다이얼로그 박스의 가로 크기 조정
                    height: 250,
                    child: AlertDialog(
                      title: Text('오류'),
                      content: Center(
                        child: Text('아이디와 비밀번호가 다릅니다.'),
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