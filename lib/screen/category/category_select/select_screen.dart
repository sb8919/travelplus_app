import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'data.dart';
import 'explore_item.dart';

class SelectScreen extends StatefulWidget {
  const SelectScreen({Key? key}) : super(key: key);

  @override
  _SelectScreenState createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  // late final SelectData? selectData;
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


  Widget getAppBar(){
    return
      Container(
          child:
            Expanded(child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text("여행지 목록", style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.w600),),
              ],
            )
            ),
      );
  }

  buildBody(){
    return
      SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: getPlaces(),
                ),
              ]
          )
      );
  }

  int selectedIndex = 0;

  getPlaces(){
    return
      StaggeredGridView.countBuilder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        itemCount: selectData.length,
        itemBuilder: (BuildContext context, int index) =>
            ExploreItem(data: selectData[index],
            ),
        staggeredTileBuilder: (int index) =>
        new StaggeredTile.count(2, index.isEven ? 3 : 2),
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      );
  }

}