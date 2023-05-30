import 'package:flutter/material.dart';
import 'Header.dart';
import 'title_with_more_btn.dart';
import 'interest_place.dart';
import 'HotPlace.dart';
import 'like_place.dart';
import 'package:dio/dio.dart';

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
    final response = await Dio().get('http://orion.mokpo.ac.kr:8481/user_info');
    if (response.statusCode == 200) {
      final data = response.data as List<dynamic>;
      final name = data[2];
      final theme = data[4];
      final response_interest_place = await Dio()
          .get('http://orion.mokpo.ac.kr:8481/place_info?place_theme=$theme');
      final response_hot_place =
          await Dio().get('http://orion.mokpo.ac.kr:8481/hot_place');
      final response_like_place = await Dio()
          .get('http://orion.mokpo.ac.kr:8481/like_place?user_name=$name');
      final List<dynamic> interest_place_list =
          response_interest_place.data.toList();
      final List<dynamic> hot_place_list = response_hot_place.data.toList();
      final List<dynamic> like_place_list = response_like_place.data.toList();
      return [
        name,
        theme,
        interest_place_list,
        hot_place_list,
        like_place_list
      ];
    } else {
      throw Exception(
          'HTTP request failed with status: ${response.statusCode}');
    }
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
