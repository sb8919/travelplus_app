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

  List<String> seoulCities = ['강남구', '강북구', '강서구'];
  List<String> gyeonggiCities = ['수원', '용인', '성남'];
  // 다른 권역과 해당 도시를 추가할 수 있습니다.

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
    // 다른 권역에 대한 도시 목록을 추가합니다.
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