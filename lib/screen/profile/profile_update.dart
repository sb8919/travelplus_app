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
  String? selectedRegion1;
  String? selectedRegion2;

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> updateUserData(String id, String newName, String newPassword, List<String> newInterests, String newRegion) async {
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
          'UPDATE User SET user_name = ?, user_pw = ?, interest_place = ?, interest_theme = ? WHERE user_id = ?',
          [newName, newPassword, newRegion, newInterests.join(', '), id],
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

  List<String> getRegion2Items(String? region1) {
    if (region1 == '서울특별시') {
      return [
        '강남구', '강동구', '강북구', '강서구', '관악구', '광진구', '구로구', '금천구',
        '노원구', '도봉구', '동대문구', '동작구', '마포구', '서대문구', '서초구', '성동구',
        '성북구', '송파구', '양천구', '영등포구', '용산구', '은평구', '종로구', '중구', '중랑구'
      ];
    } else if (region1 == '부산광역시') {
      return [
        '강서구', '금정구', '남구', '동구', '동래구', '부산진구', '북구', '사상구',
        '사하구', '서구', '수영구', '연제구', '영도구', '중구', '해운대구'
      ];
    } else if (region1 == '인천광역시') {
      return [
        '강화군', '계양구', '남동구', '동구', '미추홀구', '부평구', '서구', '연수구',
        '옹진군', '중구'
      ];
    }
    // Add other regions
    return [];
  }

  Widget buildInterestCheckbox(String title) {
    bool isChecked = interests.contains(title);
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              if (value!) {
                interests.add(title);
              } else {
                interests.remove(title);
              }
            });
          },
        ),
        Text(title),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '회원가입 정보 입력',
          style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.black),
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
                  // Add other regions
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRegion1 = newValue;
                    selectedRegion2 = null;
                  });
                },
              ),
              SizedBox(height: 16),
              if (selectedRegion1 != null)
                DropdownButtonFormField<String>(
                  value: selectedRegion2,
                  decoration: InputDecoration(
                    labelText: '관심지역 (구/군)',
                  ),
                  items: getRegion2Items(selectedRegion1!).map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRegion2 = newValue;
                    });
                  },
                ),
              SizedBox(height: 16),
              Text(
                '관심 테마',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              buildInterestCheckbox('가볼만한곳'),
              buildInterestCheckbox('가족여행'),
              buildInterestCheckbox('관람'),
              buildInterestCheckbox('맛집'),
              buildInterestCheckbox('우정여행'),
              buildInterestCheckbox('전통'),
              buildInterestCheckbox('체험'),
              buildInterestCheckbox('카페'),
              buildInterestCheckbox('캠핑'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  String id = idController.text;
                  String name = nameController.text;
                  String password = passwordController.text;
                  List<String> selectedInterests = interests;
                  String region = selectedRegion2 != null ? '$selectedRegion1 $selectedRegion2' : '';

                  updateUserData(id, name, password, selectedInterests, region);
                },
                child: Text('회원 정보 수정'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}