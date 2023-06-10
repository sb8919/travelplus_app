import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  List<Map<String, dynamic>> barData = [
    {'text': '가볼만한곳', 'percent': 30},
    {'text': '추천장소', 'percent': 50},
    {'text': '인기관광지', 'percent': 20},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.network(
            'https://cdn.psnews.co.kr/news/photo/202305/2023991_69620_1848.jpg',
            fit: BoxFit.cover,
            height: 300,
          ),
          Expanded(
            child: DraggableScrollableSheet(
              initialChildSize: 0.75, // 초기 크기 설정 (전체 화면 높이 기준 비율)
              minChildSize: 0.75, // 최소 크기 설정 (전체 화면 높이 기준 비율)
              maxChildSize: 0.75, // 최대 크기 설정 (전체 화면 높이 기준 비율)
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text('평화광장',
                              style: TextStyle(
                                fontSize: 30,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 20),
                          child: Text('목포시 평화로13',
                              style: TextStyle(
                                color: Colors.black54,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6, bottom: 8),
                          child: Text(
                            '테마',
                            style:TextStyle(fontSize:17,),
                          ),
                        ),
                        SizedBox(height: 50.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 6, bottom: 2),
                          child: Text(
                            '딥러닝 예측률',
                            style:TextStyle(fontSize:17,),
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
                                  FractionallySizedBox(
                                    widthFactor: barData[index]['percent'] / 100,
                                    child: Container(
                                      height: 16.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                        color: Colors.blue,
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
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // 왼쪽 버튼을 눌렀을 때 수행할 동작
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: BorderSide(color: Colors.blue),
                                    ),
                                  ),
                                  icon: Icon(Icons.favorite_border_outlined, color: Colors.blue), // 왼쪽 아이콘
                                  label:Text(''),
                                ),
                              ),
                              SizedBox(width: 16.0),
                              Expanded(
                                flex: 6,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // 오른쪽 버튼을 눌렀을 때 수행할 동작
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: BorderSide(color: Colors.blue),
                                    ),
                                  ),
                                  icon: Icon(Icons.location_on, color: Colors.blue), // 왼쪽 아이콘
                                  label: Text(
                                    '위치 확인하기',
                                    style: TextStyle(color: Colors.blue),
                                  ), // 오른쪽 텍스트
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
          ),
        ],
      ),
    );
  }
}
