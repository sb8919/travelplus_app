import 'package:flutter/material.dart';
import 'package:travel_plus/bottom_navigation_view/tabIcon_data.dart';
import 'package:travel_plus/screen/category/category_screen.dart';
import 'package:travel_plus/screen/history/history_screen.dart';
import 'package:travel_plus/screen/home/home_screen.dart';
import 'package:travel_plus/style/main_frame_theme.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'package:travel_plus/screen/profile/profile_screen.dart';
import 'package:travel_plus/screen/favorite/favorite_screen.dart';
import 'package:travel_plus/screen/custom/custom_screen.dart';

void main() {
  runApp(MaterialApp(home: MainPage(),debugShowCheckedModeBanner: false));
}

class MainPage extends StatefulWidget {
  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState();
}

class _FitnessAppHomeScreenState extends State<MainPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  WidgetBuilder tabBody = (BuildContext context) => Container(
    color: main_frame_theme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController =
        AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = (BuildContext context) => MediaQuery(
      data: MediaQuery.of(context).copyWith(),
      child: HomeScreen(),
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: main_frame_theme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody(context),
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = (BuildContext context) => MediaQuery(
                    data: MediaQuery.of(context).copyWith(),
                    child: HomeScreen(),
                  );
                });
              });
            } else if (index == 1) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = (BuildContext context) => MediaQuery(
                    data: MediaQuery.of(context).copyWith(),
                    child: CategoryScreen(animationController: animationController),
                  );
                });
              });
            }else if (index == 2) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = (BuildContext context) => MediaQuery(
                    data: MediaQuery.of(context).copyWith(),
                    child: FavoriteScreen(animationController: animationController),
                  );
                });
              });
            }else if (index == 3) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = (BuildContext context) => MediaQuery(
                    data: MediaQuery.of(context).copyWith(),
                    child: HistoryScreen(animationController: animationController),
                  );
                });
              });
            }
          },
        ),
      ],
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}