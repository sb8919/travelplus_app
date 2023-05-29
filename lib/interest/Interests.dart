import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:travel_login2/interest/region.dart';

class InterestsPage extends StatefulWidget {

  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  List<String> selectedInterests = [];

  void toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
  }

  Future<void> saveInterestsToDatabase() async {
    // MySQL1 패키지를 사용하여 데이터베이스에 연결
    final settings = ConnectionSettings(
      host: 'orion.mokpo.ac.kr',
      port: 8381,
      user: 'root',
      password: 'ScE1234**',
      db: 'Travelplus',
    );
    final conn = await MySqlConnection.connect(settings);

    try {
      // 선택한 관심사를 데이터베이스에 저장하는 INSERT 쿼리 실행
      for (String interest_theme in selectedInterests) {
        await conn.query(
          'INSERT INTO User (interest_theme) VALUES (?)',
          [interest_theme],
        );
      }

      print('Interests saved to database!');
    } catch (e) {
      print('Error saving interests to database: $e');
    } finally {
      // 연결 종료
      await conn.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 60.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  '무엇을 좋아하세요?',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.0),
                child: Text(
                  '딱 맞는 여행지를 추천해드립니다.',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              SizedBox(height: 20.0), // 간격을 넓히기 위한 SizedBox 추가
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: <Widget>[
                        buildInterestTile('가볼만한곳', selectedInterests.contains('가볼만한곳')),
                        buildInterestTile('가족여행', selectedInterests.contains('가족여행')),
                        buildInterestTile('관람', selectedInterests.contains('관람')),
                        buildInterestTile('맛집', selectedInterests.contains('맛집')),
                        buildInterestTile('우정여행', selectedInterests.contains('우정여행')),
                        buildInterestTile('전통', selectedInterests.contains('전통')),
                        buildInterestTile('체험', selectedInterests.contains('체험')),
                        buildInterestTile('카페', selectedInterests.contains('카페')),
                        buildInterestTile('캠핑', selectedInterests.contains('캠핑')),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0), // 간격을 넓히기 위한 SizedBox 추가
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    for (String interest in selectedInterests) {
                      print('$interest');
                    }

                    // 데이터베이스에 관심사 저장
                    saveInterestsToDatabase();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Region(
                          selectedInterests: selectedInterests,
                        ),
                      ),
                    );
                  },
                  child: Text('다음'),
                ),
              ),

              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInterestTile(String title, bool isActive) {
    return InkWell(
      onTap: () {
        toggleInterest(title);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isActive ? Colors.blue : Colors.grey.shade300,
            width: isActive ? 2.0 : 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          children: [
            Icon(
              isActive ? Icons.check_box : Icons.check_box_outline_blank,
              color: isActive ? Colors.blue : Colors.grey.shade500,
            ),
            SizedBox(width: 8.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                color: isActive ? Colors.blue : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}