import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'login.dart';

class Join extends StatefulWidget {
  @override
  _JoinState createState() => _JoinState();
}

class _JoinState extends State<Join> {
  List<String> interests = [];
  String? selectedRegion1;
  String? selectedRegion2;

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
      String region = selectedRegion1!; // 선택한 지역(시) 값을 저장합니다.
      String interestsString = interests.join(', '); // 선택한 관심사들을 쉼표로 구분하여 문자열로 변환합니다.

      if (selectedRegion2 != null) {
        region += ' ' + selectedRegion2!; // 선택한 지역(구) 값이 있다면 추가합니다.
      }

      final result = await conn.query(
        'INSERT INTO User (user_name, user_id, user_pw, interest_place, interest_theme) VALUES (?, ?, ?, ?, ?)',
        [name, id, password, region, interestsString],
      );

      if (result.affectedRows! > 0) {
        print('User data saved successfully');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Login(
              name: name,
              id: id,
              password: password,
              region: region,
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
            'User: ${row['user_name']}, ID: ${row['user_id']}, Password: ${row['user_pw']}, Region: ${row['interest_place']}, Interests: ${row['interest_theme']}');
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
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: idController,
                decoration: InputDecoration(
                  labelText: '아이디',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedRegion1,
                decoration: InputDecoration(
                  labelText: '관심지역 (시/도)',
                ),
                items: <String>[
                  '서울특별시',
                  '부산광역시',
                  '인천광역시',
                  // Add other city names
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedRegion1 = value;
                    selectedRegion2 = null;
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedRegion2,
                decoration: InputDecoration(
                  labelText: '관심지역 (구/군)',
                ),
                items: getRegion2Items(selectedRegion1).map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedRegion2 = value;
                  });
                },
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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              if (value != null && value) {
                interests.add(label);
              } else {
                interests.remove(label);
              }
            });
          },
        ),
        Text(label),
      ],
    );
  }

  List<String> getRegion2Items(String? selectedRegion1) {
    if (selectedRegion1 == null) {
      return [];
    }

    // Add region 2 items based on selected region 1
    if (selectedRegion1 == '서울특별시') {
      return [
        '강남구',
        '강동구',
        '강북구',
        '강서구',
        '관악구',
        '광진구',
        '구로구',
        '금천구',
        '노원구',
        '도봉구',
        '동대문구',
        '동작구',
        '마포구',
        '서대문구',
        '서초구',
        '성동구',
        '성북구',
        '송파구',
        '양천구',
        '영등포구',
        '용산구',
        '은평구',
        '종로구',
        '중구',
        '중랑구'
      ];
    } else if (selectedRegion1 == '부산광역시') {
      return [
        '강서구',
        '금정구',
        '기장군',
        '남구',
        '동구',
        '동래구',
        '부산진구',
        '북구',
        '사상구',
        '사하구',
        '서구',
        '수영구',
        '연제구',
        '영도구',
        '중구',
        '해운대구'
      ];
    } else if (selectedRegion1 == '인천광역시') {
      return [
        '강화군',
        '계양구',
        '남동구',
        '동구',
        '미추홀구',
        '부평구',
        '서구',
        '연수구',
        '옹진군',
        '중구'
      ];
    } else {
      // Add other regions and their sub-regions
      return [];
    }
  }
}

class JoinComplete extends StatelessWidget {
  final String name;
  final String id;
  final String password;
  final String region;
  final List<String> interests;

  JoinComplete({required this.name, required this.id, required this.password, required this.region, required this.interests});

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
              '관심지역: $region',
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