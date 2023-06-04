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
      String interestsString = interests.join(
          ', '); // 선택한 관심사들을 쉼표로 구분하여 문자열로 변환합니다.

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
            builder: (context) =>
                Login(
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
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedRegion1,
                decoration: InputDecoration(
                  labelText: '관심지역 (시/도)',
                  labelStyle: TextStyle(
                    color: Color(0xFF4B39EF), // 폰트 색상 변경
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF4B39EF), // 밑줄 색상 변경
                    ),
                  ),
                ),
                items: <String>[
                  '서울특별시', '부산광역시', '인천광역시', '경기도', '강원도', '충청북도', '충청남도', '전라북도', '전라남도', '경상북도', '경상남도', '제주특별자치도',
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
              if (selectedRegion1 != null)
              DropdownButtonFormField<String>(
                value: selectedRegion2,
                decoration: InputDecoration(
                  labelText: '관심지역 (구/군)',
                  labelStyle: TextStyle(
                    color: Color(0xFF4B39EF), // 폰트 색상 변경
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF4B39EF), // 밑줄 색상 변경
                    ),
                  ),
                ),
                items: getRegion2Items(selectedRegion1).map<
                    DropdownMenuItem<String>>((String value) {
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

  List<String> getRegion2Items(String? selectedRegion1) {
    if (selectedRegion1 == null) {
      return [];
    }
    if (selectedRegion1 == '서울특별시') {
      return [
        '강남구', '강동구', '강북구', '강서구', '관악구', '광진구', '구로구', '금천구',
        '노원구', '도봉구', '동대문구', '동작구', '마포구', '서대문구', '서초구', '성동구',
        '성북구', '송파구', '양천구', '영등포구', '용산구', '은평구', '종로구', '중구', '중랑구'
      ];
    } else if (selectedRegion1 == '부산광역시') {
      return [
        '강서구', '금정구', '남구', '동구', '동래구', '부산진구', '북구', '사상구',
        '사하구', '서구', '수영구', '연제구', '영도구', '중구', '해운대구'
      ];
    } else if (selectedRegion1 == '인천광역시') {
      return [
        '강화군', '계양구', '남동구', '동구', '미추홀구', '부평구', '서구', '연수구',
        '옹진군', '중구'
      ];
    } else if (selectedRegion1 == '경기도') {
      return [
        '가평군', '고양시', '과천시', '광명시', '광주시', '구리시', '군포시', '김포시',
        '남양주시', '동두천시', '부천시', '성남시', '수원시', '시흥시', '안산시', '안성시',
        '안양시', '양주시', '양평군', '여주시', '연천군', '오산시', '용인시', '의왕시',
        '의정부시', '이천시', '파주시', '평택시', '포천시', '하남시', '화성시'
      ];
    } else if (selectedRegion1 == '강원도') {
      return [
        '강릉시', '고성군', '동해시', '삼척시', '속초시', '양구군', '양양군', '영월군',
        '원주시', '인제군', '정선군', '철원군', '춘천시', '태백시', '평창군', '홍천군',
        '화천군', '횡성군'
      ];
    } else if (selectedRegion1 == '충청북도') {
      return [
        '괴산군', '단양군', '보은군', '영동군', '옥천군', '음성군', '제천시', '진천군',
        '청주시', '충주시'
      ];
    } else if (selectedRegion1 == '충청남도') {
      return [
        '계룡시', '공주시', '금산군', '논산시', '당진시', '보령시', '부여군', '서산시',
        '서천군', '아산시', '예산군', '천안시', '청양군', '태안군', '홍성군'
      ];
    } else if (selectedRegion1 == '전라북도') {
      return [
        '고창군', '군산시', '김제시', '남원시', '무주군', '부안군', '순창군', '완주군',
        '익산시', '임실군', '장수군', '전주시', '정읍시', '진안군'
      ];
    } else if (selectedRegion1 == '전라남도') {
      return [
        '강진군', '고흥군', '곡성군', '광양시', '구례군', '나주시', '담양군', '목포시',
        '무안군', '보성군', '순천시', '신안군', '여수시', '영광군', '영암군', '완도군',
        '장성군', '장흥군', '진도군', '함평군', '해남군', '화순군'
      ];
    } else if (selectedRegion1 == '경상북도') {
      return [
        '경산시', '경주시', '고령군', '구미시', '군위군', '김천시', '문경시', '봉화군',
        '상주시', '성주군', '안동시', '영덕군', '영양군', '영주시', '영천시', '예천군',
        '울릉군', '울진군', '의성군', '청도군', '청송군', '칠곡군', '포항시'
      ];
    } else if (selectedRegion1 == '경상남도') {
      return [
        '거제시', '거창군', '고성군', '김해시', '남해군', '밀양시', '사천시', '산청군',
        '양산시', '의령군', '진주시', '창녕군', '창원시', '통영시', '하동군', '함안군',
        '함양군', '합천군'
      ];
    } else if (selectedRegion1 == '제주특별자치도') {
      return [
        '서귀포시', '제주시'
      ];
    } else {
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