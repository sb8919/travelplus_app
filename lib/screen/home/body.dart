import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'Header.dart';
import 'title_with_more_btn.dart';
import 'interest_place.dart';
import 'HotPlace.dart';
import 'like_place.dart';
import 'package:travel_plus/db/dbcon.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<List<dynamic>> responseData;

  @override
  void initState() {
    super.initState();
    responseData = fetchData();
  }

  Future<List<dynamic>> fetchData() async {
    final data = await MainScreenData('burustar');
    final name = data['userName'];
    final theme = data['interest_theme'];
    final interest_place_list = data['recommend_place'];
    final hot_place_list = data['hot_place_list'];
    final like_place_list = data['like_place_list'];
    return [
      name,
      theme,
      interest_place_list,
      hot_place_list,
      like_place_list
    ];

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: Column(
          children: <Widget>[
            FutureBuilder<List<dynamic>>(
              future: responseData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final List<dynamic> responseData = snapshot.data!;
                  final String? response_user_name =
                  responseData[0]; // name 변수로 저장
                  final interest_tag = responseData[1]; // place 변수로 저장
                  return Column(
                    children: [
                      Header(
                          username: response_user_name,
                          interest_tag: interest_tag),
                      TitlewithMoreBtn(
                        title: '$response_user_name님을 위한 추천 장소',
                        backgroundColor: Colors.yellow,
                        press: () {},
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InterestPlace(
                          placelist: responseData[2],
                        ),
                      ),
                      TitlewithMoreBtn(
                        title: '현재 인기 있는 장소',
                        backgroundColor: Colors.green,
                        press: () {},
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: HotPlace(
                          placelist: responseData[3],
                        ),
                      ),
                      TitlewithMoreBtn(
                        title: '내가 좋아요한 장소',
                        backgroundColor: Colors.red,
                        press: () {},
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: LikePlace(placelist: responseData[4]),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}