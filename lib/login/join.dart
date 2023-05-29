import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'join_complete.dart';

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
      String interestsString = interests.join(','); // 선택한 관심사들을 쉼표로 구분하여 문자열로 변환합니다.

      if (selectedRegion2 != null) {
        region += ' ' + selectedRegion2!; // 선택한 지역(구) 값이 있다면 추가합니다.
      }

      final result = await conn.query(
        'INSERT INTO User (user_name, user_id, user_pw, interest_place, interest_theme) VALUES (?, ?, ?, ?, ?)',
        [name, id, password, region, interestsString],
      );

      if (result.affectedRows! > 0) {
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
        print('User: ${row['user_name']}, ID: ${row['user_id']}, Password: ${row['user_pw']}, Region: ${row['interest_place']}, Interests: ${row['interest_theme']}');
      }
    } catch (e) {
      print('Error reading user data: $e');
    } finally {
      await conn.close();
    }
  }

  void updateUserData(int userId, String name, String id, String password) async {
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
        'UPDATE User SET user_name = ?, user_id = ?, user_pw = ? WHERE user_id = ?',
        [name, id, password, userId],
      );

      if (result.affectedRows! > 0) {
        print('User data updated successfully');
      } else {
        print('Failed to update user data');
      }
    } catch (e) {
      print('Error updating user data: $e');
    } finally {
      await conn.close();
    }
  }

  void deleteUserData(int userId) async {
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
        'DELETE FROM User WHERE user_id = ?',
        [userId],
      );

      if (result.affectedRows! > 0) {
        print('User data deleted successfully');
      } else {
        print('Failed to delete user data');
      }
    } catch (e) {
      print('Error deleting user data: $e');
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '회원가입 정보 입력',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: '이름',
                  ),
                ),
              ),
              SizedBox(height: 16),
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
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '관심사',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  CheckboxListTile(
                    title: const Text('가볼만한곳'),
                    value: interests.contains('가볼만한곳'),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value != null && value) {
                          interests.add('가볼만한곳');
                        } else {
                          interests.remove('가볼만한곳');
                        }
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('가족여행'),
                    value: interests.contains('가족여행'),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value != null && value) {
                          interests.add('가족여행');
                        } else {
                          interests.remove('가족여행');
                        }
                      });
                    },
                  ),
                  // Add other checkboxes for interests
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<String>(
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
              ),
              SizedBox(height: 16),
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<String>(
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
              ElevatedButton(
                onPressed: () {
                  readUserData();
                },
                child: Text('회원정보 불러오기'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  int userId = 1; // User ID to update
                  String name = nameController.text;
                  String id = idController.text;
                  String password = passwordController.text;

                  updateUserData(userId, name, id, password);
                },
                child: Text('회원정보 수정하기'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  int userId = 1; // User ID to delete

                  deleteUserData(userId);
                },
                child: Text('회원정보 삭제하기'),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  List<String> getRegion2Items(String? selectedRegion1) {
    if (selectedRegion1 == null) {
      return [];
    }

    // Add region 2 items based on selected region 1
    if (selectedRegion1 == '서울특별시') {
      return ['강남구', '강동구', '강북구', '강서구', '관악구', '광진구', '구로구', '금천구', '노원구', '도봉구', '동대문구', '동작구', '마포구', '서대문구', '서초구', '성동구', '성북구', '송파구', '양천구', '영등포구', '용산구', '은평구', '종로구', '중구', '중랑구'];
    } else if (selectedRegion1 == '부산광역시') {
      return ['강서구', '금정구', '기장군', '남구', '동구', '동래구', '부산진구', '북구', '사상구', '사하구', '서구', '수영구', '연제구', '영도구', '중구', '해운대구'];
    } else if (selectedRegion1 == '인천광역시') {
      return ['강화군', '계양구', '남동구', '동구', '미추홀구', '부평구', '서구', '연수구', '옹진군', '중구'];
    }
    // Add region 2 items for other city names

    return [];
  }
}
