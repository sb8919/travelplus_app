import 'package:flutter/material.dart';
import 'favorite_list_theme.dart';
import 'favorite_list_data.dart';
import 'favorite_list_view.dart';
import 'package:mysql1/mysql1.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<FavoriteListData> favoriteList = FavoriteListData.favoriteList;
  late final FavoriteListData? favoriteData;
  final ScrollController _scrollController = ScrollController();
  String selectedLocation = '';
  String selectedCategory = '';
  List<FavoriteListData> filteredList = [];

  @override
  void initState() {
    animationController =
        AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  void filterLocation(String location) {
    filteredList =
        favoriteList.where((data) => data.subTxt == location).toList();
    updateUI();
  }

  void updateUI() {
    setState(() {});
  }

  Future<Map<String, dynamic>> favoriteScreenData(String user_id) async {
    try {
      final settings = ConnectionSettings(
        host: 'orion.mokpo.ac.kr',
        port: 8381,
        user: 'root',
        password: 'ScE1234**',
        db: 'Travelplus',
      );

      final conn = await MySqlConnection.connect(settings);

      final favoriteList = (await conn.query(
          "SELECT * FROM Place Place WHERE place_likes > 0 ORDER BY place_likes DESC;"))
          .toList();

      return {
        'favorite_pressed': favoriteList,
      };
    } catch (e) {
      print('Favorite Screen Error reading user data: $e');
      throw Exception('Favorite Screen Failed to fetch user data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: FavoriteListTheme.buildLightTheme(),
      child: Container(
        child: Scaffold(
          backgroundColor: Color(0xFFFFFFFF),
          body: Stack(
            children: <Widget>[
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      getAppBarUI(),
                      Filter(),
                      Container(
                        color: Color(0xFFFFFFFF),
                        child: ListView.builder(
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final Animation<double> animation = Tween<double>(
                              begin: 0.0,
                              end: 1.0,
                            ).animate(
                              CurvedAnimation(
                                parent: animationController!,
                                curve: Interval(
                                  (1 / filteredList.length) * index,
                                  1.0,
                                  curve: Curves.fastOutSlowIn,
                                ),
                              ),
                            );
                            animationController?.forward();

                            return FutureBuilder<Map<String, dynamic>>(
                              future: favoriteScreenData('test'), // 사용자 ID 전달
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  // 데이터 로딩 중에 표시할 위젯
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  // 에러가 발생한 경우에 표시할 위젯
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  // 데이터 로딩이 완료된 경우에 표시할 위젯
                                  final favoritePressed = snapshot.data!['favorite_pressed'];

                                  return FavoriteListView(
                                    callback: () {},
                                    favoriteData: favoritePressed,
                                    animation: animation,
                                    animationController: animationController!,
                                  );
                                }
                              },
                            );
                          },
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
            'assets/images/favorite_left.png',
            height: 50,
            width: 60,
          ),
          Text(
            '좋아요',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          Image.asset(
            'assets/images/favorite_right.png',
            height: 50,
            width: 60,
          ),
        ],
      ),
    );
  }

  Widget Filter() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: 0.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 16, top: 16, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '추천 장소',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 0.5,
                      color: Color(0xFF1D1D1D),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          '필터:',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 0.5,
                            color: Color(0xFF1D1D1D),
                          ),
                        ),
                        DropdownButton(
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1D1D1D),
                          ),
                          value: selectedLocation,
                          items: <DropdownMenuItem<String>>[
                            DropdownMenuItem<String>(
                              value: '',
                              child: Text('모든 위치'),
                            ),
                            DropdownMenuItem<String>(
                              value: '한국',
                              child: Text('한국'),
                            ),
                            DropdownMenuItem<String>(
                              value: '미국',
                              child: Text('미국'),
                            ),
                            DropdownMenuItem<String>(
                              value: '일본',
                              child: Text('일본'),
                            ),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              selectedLocation = value!;
                              filterLocation(selectedLocation);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
