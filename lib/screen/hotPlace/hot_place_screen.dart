import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

import '../favorite/favorite_list_theme.dart';
import 'hot_place_list.dart';


class HotPlaceScreen extends StatelessWidget {
  HotPlaceScreen({Key? key,

    required this.placelist,
    required this.user_id,

  }) : super(key: key);



  final List placelist;
  final String user_id;
  final ScrollController _scrollController = ScrollController();


  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }



  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> place_list = placelist.map((place) {
      String placeName = place[0].toString();
      String placeTheme = place[2].toString();
      String placeLikes = place[3].toString();
      String placeImage = place[4].toString();

      return {
        'place_name': placeName,
        'place_theme': placeTheme,
        'place_likes': placeLikes,
        'place_img_url': placeImage,
      };
    }).toList();
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
                      Container(
                        color: Color(0xFFFFFFFF),
                        child: ListView.builder(
                          itemCount: place_list.length,
                          padding: const EdgeInsets.only(top: 8),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            final place = place_list[index];
                            final String placeName = place['place_name'];
                            final String placeTheme = place['place_theme'];
                            final String placeLikes = place['place_likes'];
                            final String placeImage = place['place_img_url'];

                            return HotPlaceList(
                              placeName: placeName,
                              placeTheme: placeTheme,
                              placeLikes: placeLikes,
                              placeImage: placeImage,
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
                      '인기있는 장소 목록',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 23

                      ),
                    ),
                    ]
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