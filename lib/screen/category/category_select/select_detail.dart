import 'package:flutter/material.dart';
import 'select_list_data.dart';
import 'select_list_view.dart';
import 'package:travel_plus/style/main_frame_theme.dart';

class SelectDetail extends StatefulWidget {
  const SelectDetail({Key? key,
    this.animationController,
  }) : super(key: key);
  final AnimationController? animationController;

  @override
  _SelectDetailState createState() => _SelectDetailState();
}

class _SelectDetailState extends State<SelectDetail>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<CategorySelectList> selectData = CategorySelectList.selectData;
  late final CategorySelectList? selectListData;


  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    selectListData = CategorySelectList();
    CategorySelectList.fetch(selectListData!.placeTheme).then((_) {
      // 데이터를 가져온 후에 UI 업데이트
      updateUI();
    });
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  void updateUI() {
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              snap: true,
              floating: true,
              title: getAppBar(),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => buildBody(),
                childCount: 1,
              ),
            )
          ],
        )
    );
  }


  Widget getAppBar() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(
            "여행지 목록을 보여드릴게요!",
            style: TextStyle(
              fontFamily: 'Jeju',
              fontWeight: FontWeight.w700,
              fontSize: 22,
              letterSpacing: 1.2,
              color: main_frame_theme.darkerText,
            ),
          ),
        ],
      ),
    );
  }
  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: getPlaces(),
          ),
        ],
      ),
    );
  }

  int selectedIndex = 0;

  Widget getPlaces(){
    return
      ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: selectData.length,
        itemBuilder: (BuildContext context, int index) {
          final int count =
          selectData.length > 10 ? 10 : selectData.length;
          final Animation<double> animation =
          Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: animationController!,
                  curve: Interval((1 / count) * index, 1.0,
                      curve: Curves.fastOutSlowIn)));
          animationController?.forward();

          return SelectListView(
            callback: () {},
            selectListData: selectData[index],
            animation: animation,
            animationController: animationController!,
          );
        },
      );
  }

}