import 'package:flutter/material.dart';
import '../../db/likecon.dart';
import 'favorite_list_theme.dart';
import 'favorite_list_data.dart';
import 'favorite_list_view.dart';


class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key, this.animationController,required this.user_id}) : super(key: key);

  final String user_id;
  final AnimationController? animationController;
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<FavoriteListData> favoriteList = FavoriteListData.favoriteList;
  late FavoriteListData favoriteData;
  final ScrollController _scrollController = ScrollController();

  List<String> dropdownList = [
    '전체 지역',
    '서울', '부산', '대구', '인천', '광주', '대전', '울산',
    '경기', '강원', '충북', '충남', '전북', '전남', '경북', '경남',
    '제주',];
  String selectedLocation = '전체 지역';
  String selectedCategory = '카테고리';

  List<FavoriteListData> filteredList = [];

  void _removePlace(int index, userid, place_name) {
    deleteLikePlace(userId: userid, place: place_name);
    setState(() {
      favoriteList.removeAt(index);
    });

  }

  List<FavoriteListData> updateFilteredList(String selectedLocation) {
    List<FavoriteListData> filteredList = favoriteList
        .where((item) => selectedLocation == '전체 지역' || item.placeAdd.split(' ')[0] == selectedLocation)
        .toList();
    return filteredList;
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
    favoriteData = favoriteList.isNotEmpty ? favoriteList[0] : FavoriteListData();
    if (favoriteList.isEmpty) {
      FavoriteListData.fetch(user_id: widget.user_id).then((_) {
        // 데이터를 가져온 후에 UI 업데이트
        updateUI();
      });
    }
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
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      getAppBarUI(),
                      Filter(),
                      Container(
                        color: Color(0xFFFFFFFF),
                        child: ListView.builder(
                          itemCount: favoriteList.length,
                          padding: const EdgeInsets.only(top: 8),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            final int count =
                            favoriteList.length > 10 ? 10 : favoriteList.length;
                            final Animation<double> animation =
                            Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                parent: animationController!,
                                curve: Interval(
                                  (1 / count) * index,
                                  1.0,
                                  curve: Curves.fastOutSlowIn,
                                ),
                              ),
                            );
                            animationController?.forward();

                            return FavoriteListView(
                              callback: () {},
                              favoriteData: favoriteData,
                              animation: animation,
                              animationController: animationController!,
                              remove: () {
                                _removePlace(index, widget.user_id,
                                    favoriteList[index].placeName);
                              },
                            );

                          },
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


  Widget Filter(){
    return Padding(
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
                value: selectedLocation, // Replace with the selected value state
                onChanged: (String? newValue) {
                  // Handle dropdown value changes
                  setState(() {
                    selectedLocation = newValue!;
                    updateFilteredList(selectedLocation);
                  });
                },
                underline: Container(),
                itemHeight: 50,
                items: dropdownList.map<DropdownMenuItem<String>>((String value) {
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
