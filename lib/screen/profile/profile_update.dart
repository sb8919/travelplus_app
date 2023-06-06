import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class ProfileUpdate extends StatefulWidget {
  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  List<String> interests = [];

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> updateUserData(String id, String newName, String newPassword, List<String> newInterests) async {
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
        'SELECT * FROM User WHERE user_id = ?',
        [id],
      );

      if (result.isNotEmpty) {
        final updateResult = await conn.query(
          'UPDATE User SET user_name = ?, user_pw = ?, interest_theme = ? WHERE user_id = ?',
          [newName, newPassword, newInterests.join(', '), id],
        );

        if (updateResult.affectedRows! > 0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('회원 정보 수정'),
                content: Text('회원 정보가 성공적으로 수정되었습니다.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('확인'),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('회원 정보 수정 실패'),
                content: Text('회원 정보 수정에 실패했습니다.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('확인'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('회원 정보 찾기 실패'),
              content: Text('해당 회원 정보를 찾을 수 없습니다.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('확인'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('회원 정보 수정 중 오류 발생'),
            content: Text('회원 정보 수정 중 오류가 발생했습니다: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    } finally {
      await conn.close();
    }
  }

  Widget buildInterestCheckbox(String label) {
    final bool isChecked = interests.contains(label);
    final Color borderColor = isChecked ? Color(0xFF4B39EF) : Colors.transparent;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '회원가입 정보 입력',
          style: Theme.of(context)
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
              SizedBox(height: 16),
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
                  String id = idController.text;
                  String name = nameController.text;
                  String password = passwordController.text;
                  List<String> selectedInterests = interests;

                  updateUserData(id, name, password, selectedInterests);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF4B39EF),
                ),
                child: Text('회원 정보 수정'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}