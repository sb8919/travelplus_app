import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../db/likecon.dart';

class MyApp extends StatelessWidget {
  final String placeName;
  final String user_id;

  const MyApp({Key? key, required this.placeName, required this.user_id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Place App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: Text('Place App')),
        body: Body(placeName: placeName, user_id: user_id),
      ),
    );
  }
}

class Body extends StatefulWidget {
  final String placeName;
  final String user_id;

  const Body({Key? key, required this.placeName, required this.user_id})
      : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Map<String, dynamic>> placeData = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromDatabase();
  }

  Future<void> fetchDataFromDatabase() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'orion.mokpo.ac.kr',
      port: 8381,
      user: 'root',
      password: 'ScE1234**',
      db: 'Travelplus',
    ));

    final results = await conn
        .query("SELECT * FROM Place WHERE place_name = ?", [widget.placeName]);

    for (var row in results) {
      final item = {
        'place_name': row['place_name'],
        'place_address': row['place_address'],
        'place_theme': row['place_theme'],
        'place_likes': row['place_likes'],
        'place_img_url': row['place_img_url'],
        'latitude': row['latitude'],
        'longitude': row['longitude'],
        'theme1': row['theme1'].split(' '),
        'theme2': row['theme2'].split(' '),
        'theme3': row['theme3'].split(' '),
      };
      placeData.add(item);
    }

    await conn.close();

    setState(() {
      placeData = placeData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          placeData.isNotEmpty
              ? Image.network(
                  placeData[0]['place_img_url'],
                  fit: BoxFit.cover,
                  height: 300,
                )
              : Container(),
          DraggableScrollableSheet(
            initialChildSize: 0.75,
            minChildSize: 0.75,
            maxChildSize: 0.75,
            builder: (BuildContext context, ScrollController scrollController) {
              if (placeData.isEmpty) {
                return Container();
              }
              List<Map<String, dynamic>> barData = [
                {
                  'text': '${placeData[0]['theme1'][0]}',
                  'percent': int.parse(placeData[0]['theme1'][1])
                },
                {
                  'text': '${placeData[0]['theme2'][0]}',
                  'percent': int.parse(placeData[0]['theme2'][1])
                },
                {
                  'text': '${placeData[0]['theme3'][0]}',
                  'percent': int.parse(placeData[0]['theme3'][1])
                },
              ];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 1, bottom: 30),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 5,
                            width: 55,
                            color: Colors.black12,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              placeData.isNotEmpty
                                  ? placeData[0]['place_name']
                                  : '',
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  placeData.isNotEmpty
                                      ? placeData[0]['place_theme']
                                      : '',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white, // 텍스트 색상을 흰색으로 지정
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2, bottom: 20),
                        child: Text(
                          placeData.isNotEmpty
                              ? placeData[0]['place_address']
                              : '',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6, bottom: 2),
                        child: Text(
                          '딥러닝 예측률',
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(barData.length, (index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  barData[index]['text'],
                                  style: TextStyle(fontSize: 10),
                                ),
                                SizedBox(height: 2.0),
                                Container(
                                  height: 16.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 4.0,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue,
                                        Colors.lightBlue,
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      stops: [0.0, 1.0],
                                    ),
                                    border: Border.all(
                                      color: Colors.blue,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: FractionallySizedBox(
                                    widthFactor:
                                        barData[index]['percent'] / 100,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          '${barData[index]['percent']}%',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.0),
                              ],
                            );
                          }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 37,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 1.0,
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    var likePlaceCount = await ifLikePlace(
                                      userId: widget.user_id,
                                      place: widget.placeName,
                                    );
                                    if (likePlaceCount == 0) {
                                      addLikePlace(
                                        userId: widget.user_id,
                                        place: widget.placeName,
                                      );
                                      setState(() {
                                        likePlaceCount = 1; // 좋아요 수 갱신
                                      });
                                    } else {
                                      // 좋아요 제거
                                      await deleteLikePlace(
                                        userId: widget.user_id,
                                        place: widget.placeName,
                                      );
                                      setState(() {
                                        likePlaceCount = 0; // 좋아요 수 갱신
                                      });
                                    }
                                    setState(() {
                                      // 상태 업데이트
                                    });
                                  },
                                  icon: FutureBuilder<int>(
                                    future: ifLikePlace(
                                      userId: widget.user_id,
                                      place: widget.placeName,
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        var likePlaceCount = snapshot.data!;
                                        final icon = likePlaceCount == 0
                                            ? Icons.favorite_border
                                            : Icons.favorite;
                                        return Icon(icon, color: Colors.red);
                                      } else {
                                        return Icon(Icons
                                            .favorite_border); // 데이터가 아직 로딩 중인 경우 기본 아이콘 표시
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              flex: 6,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  launchUrl(
                                    Uri.parse(
                                        'https://map.naver.com/v5/search/${placeData[0]['place_address']}'),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: BorderSide(color: Colors.blue),
                                  ),
                                ),
                                icon: Icon(Icons.map, color: Colors.blue),
                                label: Text(
                                  '위치 확인하기',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 200.0),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
