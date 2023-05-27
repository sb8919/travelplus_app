import 'package:flutter/material.dart';
import 'Interests.dart';
import 'login.dart';
import 'Interests.dart';

class Region extends StatefulWidget {
  final String name;

  Region({required this.name});

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
    '상주',
    '문경',
    '영주',
    '영천',
    '군위',
    '고령',
    '성주',
    '칠곡',
    '예천',
    '봉화',
    '울릉',
    '독도',
  ];
  List<String> jeollaCities = [
    '광주',
    '전주',
    '여수',
    '순천',
    '남원',
    '익산',
    '목포',
    '군산',
    '정읍',
    '남해',
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

  List<DropdownMenuItem<String>> generateRegionItems() {
    List<String> regions = ['서울', '경기', '강원', '충청', '경상', '전라', '제주'];
    return regions.map((region) {
      return DropdownMenuItem<String>(
        value: region,
        child: Text(region),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> generateCityItems() {
    List<String> cities = [];
    switch (selectedRegion) {
      case '서울':
        cities = seoulCities;
        break;
      case '경기':
        cities = gyeonggiCities;
        break;
      case '강원':
        cities = gangwonCities;
        break;
      case '충청':
        cities = chungcheongCities;
        break;
      case '경상':
        cities = gyeongsangCities;
        break;
      case '전라':
        cities = jeollaCities;
        break;
      case '제주':
        cities = jejuCities;
        break;
    }
    return cities.map((city) {
      return DropdownMenuItem<String>(
        value: city,
        child: Text(city),
      );
    }).toList();
  }

  void printSelectedValues() {
    print('Selected Region: $selectedRegion');
    print('Selected City: $selectedCity');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '관심지역을 선택해주세요.',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '권역 선택',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: DropdownButton<String>(
                    value: selectedRegion,
                    items: generateRegionItems(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedRegion = value;
                        selectedCity = null; // 권역이 변경되면 도시 선택을 초기화합니다.
                      });
                    },
                    hint: Text('권역 선택'),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '지역 선택',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: DropdownButton<String>(
                    value: selectedCity,
                    items: generateCityItems(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedCity = value;
                      });
                    },
                    hint: Text('지역 선택'),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  InterestsPage(name: widget.name),
                            ),
                          );
                        },
                        child: Text('이전'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          printSelectedValues(); // 값 출력
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  Login(name: widget.name),
                            ),
                          );
                        },
                        child: Text('다음'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}