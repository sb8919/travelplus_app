import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mysql1/mysql1.dart' as mysql;
import '../mainPage.dart';
import 'join.dart';

class Login extends StatefulWidget {
  final String name;
  final String id;
  final String password;
  final List<String> interests;

  Login({
    required this.name,
    required this.id,
    required this.password,
    required this.interests,
  });

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showErrorDialog = false;
  bool isLoggedIn = false;

  String user_id = '';
  String user_pw = '';

  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs?.getBool('isLoggedIn') ?? false;
    user_id = prefs?.getString('user_id') ?? '';
    if (isLoggedIn) {
      navigateToNextScreen();
    }
  }

  void saveLoginStatus() async {
    await prefs?.setBool('isLoggedIn', true);
    await prefs?.setString('user_id', user_id);
  }

  void clearLoginStatus() async {
    await prefs?.remove('isLoggedIn');
    await prefs?.remove('user_id');
  }

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
        user_id = id;
        saveLoginStatus();
        print('로그인 성공');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MainPage(id: id),
          ),
        );
      } else {
        print('로그인 실패');
        setState(() {
          showErrorDialog = true;
        });
      }
    } catch (e) {
      print('로그인 에러: $e');
    } finally {
      await conn.close();
    }
  }

  void dismissErrorDialog() {
    setState(() {
      showErrorDialog = false;
    });
  }

  void navigateToNextScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => MainPage(id: user_id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      color: Color(0xFF4B39EF),
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
                          color: Color(0xFF4B39EF),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF4B39EF),
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
                          color: Color(0xFF4B39EF),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF4B39EF),
                          ),
                        ),
                      ),
                      obscuringCharacter: '●', // ● 문자로 대체
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
                      primary: Color(0xFF4B39EF),
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
                      primary: Color(0xFF4B39EF),
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
