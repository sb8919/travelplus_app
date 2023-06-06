import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'login.dart';

class Join extends StatefulWidget {
  @override
  _JoinState createState() => _JoinState();
}

class _JoinState extends State<Join> {
  List<String> interests = [];

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
      String interestsString = interests.join(', '); // 선택한 관심사들을 쉼표로 구분하여 문자열로 변환합니다.

      final result = await conn.query(
        'INSERT INTO User (user_name, user_id, user_pw, interest_theme) VALUES (?, ?, ?, ?)',
        [name, id, password, interestsString],
      );

      if (result.affectedRows! > 0) {
        print('User data saved successfully');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Login(
                  name: name,
                  id: id,
                  password: password,
                  interests: interests,
                ),
          ),
        );
      } else {
        print('Failed to save user data');
      }
    } catch (e) {
      print('Error saving user data: $e');
    } finally {
      await conn.close();
    }
  }

  void readUserData() async {
    final settings = ConnectionSettings(
      host: 'orion.mokpo.ac.kr',
      port: 8381,
      user: 'root',
      password: 'ScE1234**',
      db: 'Travelplus',
    );

    final conn = await MySqlConnection.connect(settings);

    try {
      final result = await conn.query('SELECT * FROM User');

      for (var row in result) {
        print(
            'User: ${row['user_name']}, ID: ${row['user_id']}, Password: ${row['user_pw']}, Interests: ${row['interest_theme']}');
      }
    } catch (e) {
      print('Error reading user data: $e');
    } finally {
      await conn.close();
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '회원가입 정보 입력',
          style: Theme
              .of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: '이름',
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
              SizedBox(height: 16),
              TextFormField(
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
              SizedBox(height: 16),
              TextFormField(
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
              SizedBox(height: 8),
              Wrap(
                children: [
                  buildInterestCheckbox('가볼만한곳'),
                  buildInterestCheckbox('가족여행'),
                  buildInterestCheckbox('관람'),
                  buildInterestCheckbox('맛집'),
                  buildInterestCheckbox('우정여행'),
                  buildInterestCheckbox('전통'),
                  buildInterestCheckbox('체험'),
                  buildInterestCheckbox('카페'),
                  buildInterestCheckbox('캠핑'),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  String name = nameController.text;
                  String id = idController.text;
                  String password = passwordController.text;

                  saveUserData(name, id, password);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF4B39EF),
                ),
                child: Text('회원가입'),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInterestCheckbox(String label) {
    final bool isChecked = interests.contains(label);
    final Color borderColor = isChecked ? Color(0xFF4B39EF) : Colors
        .transparent;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isChecked) {
            interests.remove(label);
          } else {
            interests.add(label);
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isChecked ? Color(0xFF4B39EF) : Colors.black,
          ),
        ),
      ),
    );
  }
}

class JoinComplete extends StatelessWidget {
  final String name;
  final String id;
  final String password;
  final List<String> interests;

  JoinComplete({required this.name, required this.id, required this.password, required this.interests,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입 완료'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '회원가입이 완료되었습니다.',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              '이름: $name',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '아이디: $id',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '비밀번호: $password',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '관심사: ${interests.join(", ")}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}