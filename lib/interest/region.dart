import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart' as mysql;

import 'Interests.dart';
import '../login/login.dart';

class Region extends StatefulWidget {
  final String name;

  Region({required this.name, required List<String> selectedInterests});

  @override
  _RegionState createState() => _RegionState();
}

class _RegionState extends State<Region> {
  String? selectedRegion;
  String? selectedCity;

  List<String> seoulCities = [
    '강남구',
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
    '중랑구',
  ];
  List<String> gyeonggiCities = [
    '수원',
    '용인',
    '성남',
    '부천',
    '안산',
    '안양',
    '남양주',
    '화성',
    '평택',
    '의정부',
    '시흥',
    '파주',
    '광명',
    '김포',
    '군포',
    '이천',
    '양주',
    '오산',
    '구리',
    '안성',
    '포천',
    '의왕',
    '하남',
    '여주',
  ];
  List<String> gangwonCities = [
    '춘천',
    '원주',
    '강릉',
    '속초',
    '동해',
    '태백',
    '홍천',
    '횡성',
    '영월',
    '평창',
    '정선',
    '철원',
    '화천',
    '양구',
    '인제',
    '고성',
    '양양',
  ];
  List<String> chungcheongCities = [
    '청주',
    '대전',
    '충주',
    '제천',
    '보령',
    '천안',
    '공주',
    '아산',
    '서산',
    '논산',
    '계룡',
    '당진',
    '금산',
    '부여',
    '서천',
    '청양',
    '홍성',
    '예산',
    '태안',
  ];
  List<String> gyeongsangCities = [
    '부산',
    '대구',
    '울산',
    '창원',
    '포항',
    '경주',
    '김천',
    '안동',
    '구미',
    '경산',
    '의성',
    '청송',
    '칠곡',
    '영주',
    '영천',
    '상주',
    '문경',
    '경산',
    '군위',
    '의성',
    '영양',
    '청도',
    '고령',
    '성주',
    '칠곡',
    '예천',
    '봉화',
    '울진',
    '울릉',
  ];
  List<String> jeollaCities = [
    '전주',
    '군산',
    '익산',
    '정읍',
    '남원',
    '김제',
    '완주',
    '진안',
    '무주',
    '장수',
    '임실',
    '순창',
    '고창',
    '부안',
    '목포',
    '여수',
    '순천',
    '나주',
    '광양',
    '담양',
    '곡성',
    '구례',
    '고흥',
    '보성',
    '화순',
    '장흥',
    '강진',
    '해남',
    '영암',
    '무안',
    '함평',
    '영광',
    '장성',
    '완도',
    '진도',
    '신안',
  ];
  List<String> jejuCities = [
    '제주시',
    '서귀포',
    '애월',
    '한림',
    '중문',
    '성산',
    '조천',
    '구좌',
    '남원',
    '표선',
    '송산',
    '안덕',
    '대정',
    '한경',
  ];

  Future<void> saveSelectedValues() async {
    print('$selectedRegion $selectedCity');

    try {
      final conn = await mysql.MySqlConnection.connect(
        mysql.ConnectionSettings(
          host: 'orion.mokpo.ac.kr',
          port: 8381,
          user: 'root',
          password: 'ScE1234**',
          db: 'Travelplus',
        ),
      );

      final result = await conn.query(
        'INSERT INTO User (interest_place) VALUES (?)',
        ['${selectedRegion} ${selectedCity}'],
      );

      if (result != null && result.affectedRows! > 0) {
        print('Region data saved successfully!');
      } else {
        print('Error saving region data.');
      }

      await conn.close();
    } catch (e) {
      print('Error saving region data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              Text(
                '관심 지역 선택',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: '지역',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedRegion,
                  items: [
                    DropdownMenuItem(
                      value: '서울',
                      child: Text('서울'),
                    ),
                    DropdownMenuItem(
                      value: '경기도',
                      child: Text('경기도'),
                    ),
                    DropdownMenuItem(
                      value: '강원도',
                      child: Text('강원도'),
                    ),
                    DropdownMenuItem(
                      value: '충청도',
                      child: Text('충청도'),
                    ),
                    DropdownMenuItem(
                      value: '경상도',
                      child: Text('경상도'),
                    ),
                    DropdownMenuItem(
                      value: '전라도',
                      child: Text('전라도'),
                    ),
                    DropdownMenuItem(
                      value: '제주도',
                      child: Text('제주도'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedRegion = value;
                      selectedCity = null;
                    });
                  },
                ),
              ),
              SizedBox(height: 30),
              if (selectedRegion != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: '도시',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedCity,
                    items: getCityItems(selectedRegion!),
                    onChanged: (value) {
                      setState(() {
                        selectedCity = value;
                      });
                    },
                  ),
                ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  if (selectedRegion != null && selectedCity != null) {
                    await saveSelectedValues();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(name: '',),
                      ),
                    );
                  }
                },
                child: Text('다음'),
              ),
              SizedBox(height: 50),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InterestsPage())
                  );
                },
                child: Text('이전'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> getCityItems(String region) {
    List<String> cities = [];
    if (region == '서울') {
      cities = seoulCities;
    } else if (region == '경기도') {
      cities = gyeonggiCities;
    } else if (region == '강원도') {
      cities = gangwonCities;
    } else if (region == '충청도') {
      cities = chungcheongCities;
    } else if (region == '경상도') {
      cities = gyeongsangCities;
    } else if (region == '전라도') {
      cities = jeollaCities;
    } else if (region == '제주도') {
      cities = jejuCities;
    }

    return cities.map((city) {
      return DropdownMenuItem(
        value: city,
        child: Text(city),
      );
    }).toList();
  }
}