import 'package:flutter/material.dart';
import 'package:travel_plus/style/main_frame_theme.dart';
import 'package:travel_plus/screen/profile/profile_screen.dart';
import 'category_list.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  List<Widget> listViews = <Widget>[];
  double topBarOpacity = 0.0;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();
    super.initState();
  }

  void addAllListData() {
    const int count = 9;

    listViews.add(
      CategoryList(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 5, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController!,
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: main_frame_theme.background,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 55, left: 25, right: 30, bottom: 0),
                    child: Image.asset(
                      'assets/logo/travel.png',
                      width: 45,
                      height: 45,
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).padding.top,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 16,
                      top: 10,
                      bottom: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 15, right: 0, bottom: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '반가워요!',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: 'Jeju',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25,
                                    letterSpacing: 1.2,
                                    color: main_frame_theme.darkerText,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 0, right: 0, bottom: 15),
                                  child: Text(
                                    '어떤 여행을 하고 싶은가요?',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: 'Jeju',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 25,
                                      letterSpacing: 1.2,
                                      color: main_frame_theme.darkerText,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              getMainListViewUI(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: listViews.length,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }
}