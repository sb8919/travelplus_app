import 'package:flutter/material.dart';
import 'favorite_list_theme.dart';
import 'favorite_list_view.dart';
import 'package:travel_plus/db/dbcon.dart';


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
  late FavoriteListData? favoriteData;
  final ScrollController _scrollController = ScrollController();
  String selectedLocation = '';
  String selectedCategory = '';

  late Future<List<dynamic>> responseData;


  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  Future<List<dynamic>> fetchData() async {
    final data = await FavoriteScreenData('burustar');
    final favoriteList = data['favorite_pressed'];
    final favoriteAdd =  favoriteList[0][1];
    final cityName = favoriteAdd.split(' ');
    print(cityName);
    return [data];
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


  void updateUI() {
    setState(() {});
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
                child: Column(
                  children: <Widget>[
                    getAppBarUI(),
                    Padding(
                      padding: const EdgeInsets.only(top:16, left:25 , right:5, bottom:8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity, // 너비를 확장하여 부모 위젯에 맞게 설정
                              height: 40.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20), // Set the border radius here
                                color: Color(0xFFF2F2F2), // Set the background color here
                              ),
                              child: DropdownButton<String>(
                                value: '전체 지역', // Replace with the selected value state
                                onChanged: (String? newValue) {
                                  // Handle dropdown value changes
                                  setState(() {
                                    selectedLocation = newValue!;
                                    // filterLocation(selectedLocation);
                                  });
                                },
                                underline: Container(),
                                itemHeight: 50,
                                items: <String>[
                                  '전체 지역',
                                  '서울특별시',
                                  '부산광역시',
                                  '대구광역시',
                                  '인천광역시',
                                  '광주광역시',
                                  '대전광역시',
                                  '울산광역시',
                                  '경기도',
                                  '강원도',
                                  '충청북도',
                                  '충청남도',
                                  '전라북도',
                                  '전라남도',
                                  '경상북도',
                                  '경상남도',
                                  '제주도',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return
                                    DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        height: 30.0, // 항목의 높이 조정
                                        child: Text(value),
                                      ),
                                    );
                                }).toList(),
                              ),

                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity, // 너비를 확장하여 부모 위젯에 맞게 설정
                              height: 40.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20), // Set the border radius here
                                color: Color(0xFFF2F2F2), // Set the background color here
                              ),
                              child: DropdownButton<String>(
                                value: '카테고리', // Replace with the selected value state
                                onChanged: (String? newValue) {
                                  // Handle dropdown value changes
                                  setState(() {
                                    selectedCategory = newValue!;

                                  });
                                },
                                underline: Container(),
                                items: <String>[
                                  '카테고리',
                                  '가볼만한곳',
                                  '가족여행',
                                  '우정여행',
                                  '전통',
                                  '체험',
                                  '캠핑',
                                  '관람',
                                  '맛집',
                                  '카페'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 35.0),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity, // 너비를 확장하여 부모 위젯에 맞게 설정
                              height: 40.0,
                              child: DropdownButton<String>(
                                value: '등록순', // Replace with the selected value state
                                onChanged: (String? newValue) {
                                  // Handle dropdown value changes
                                  setState(() {
                                    // Update the selected value state
                                  });
                                },
                                underline: Container(),
                                items: <String>[
                                  '등록순',
                                  '오래된순',
                                  '가나다순',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: NestedScrollView(
                        controller: _scrollController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                          ];
                        },
                        body: Container(
                          color:
                          Color(0xFFFFFFFF),
                          child: ListView.builder(
                            itemCount: favoriteList.length,
                            padding: const EdgeInsets.only(top: 8),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              final int count =
                              favoriteList.length > 10 ? 10 : favoriteList.length;
                              final Animation<double> animation =
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                      parent: animationController!,

                                      curve: Interval(
                                          (1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn)));
                              animationController?.forward();
                              return FavoriteListView(
                                callback: () {},
                                favoriteData: favoriteList[index],
                                animation: animation,
                                animationController: animationController!,
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 40 ,
            bottom: 0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                    children:[ Text(
                      '좋아요 목록',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 28

                      ),
                    ),
                      Text('관심있어 하신 여행지에요!',
                        textAlign: TextAlign.left,)]
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
      this.searchUI,
      );
  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
class FavoriteListData {
  FavoriteListData({
    this.placeName = '',
    this.placeAddress = '',
    this.placeTheme = '',
    this.placeLikes = false,
    this.imagePath = ''
  });

  String placeName;
  String placeAddress;
  String placeTheme;
  bool placeLikes;
  String imagePath;


  static List<FavoriteListData> favoriteList = _initializeFavoriteList();

  static List<FavoriteListData> _initializeFavoriteList() {
    List<FavoriteListData> list = [];
    // 데이터를 추가하는 부분에서 favoriteList를 참조하지 않고 직접 데이터를 추가합니다.
    list.add(FavoriteListData(
      placeName: '',// 이미지 경로
      placeAddress: '', // 제목
      placeTheme: '',
      placeLikes: false,// 서브 텍스트
      imagePath: '',
    ));
    // 다른 데이터도 필요에 따라 추가합니다.
    list.add(FavoriteListData(
      placeName: favoriteList[0].toString(),
      placeAddress: favoriteList[1].toString(),
      placeTheme: favoriteList[2].toString(),
      placeLikes: favoriteList[4] as bool,
      imagePath: favoriteList[4].toString(),

    ));
    // 추가적인 데이터를 계속해서 추가할 수 있습니다.
    // ...
    return list;
  }
}