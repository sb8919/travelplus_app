import 'package:flutter/material.dart';

import 'category_data.dart';
import 'category_select/select_screen.dart';



class CategoryList extends StatefulWidget {
  const CategoryList(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation, this.categoryList})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final CategoryListData? categoryList;
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> with TickerProviderStateMixin {
  AnimationController? animationController;
  List<String> themeListData = <String>[
    'assets/category/가볼만한곳.png',
    'assets/category/가족여행.png',
    'assets/category/우정여행.png',
    'assets/category/전통.png',
    'assets/category/체험.png',
    'assets/category/캠핑.png',
    'assets/category/관람.png',
    'assets/category/맛집.png',
    'assets/category/카페.png'

  ];

  List<String> themeName = <String>[
    '가볼만한곳',
    '가족여행',
    '우정여행',
    '전통',
    '체험',
    '캠핑',
    '관람',
    '맛집',
    '카페'
  ];

  @override
  void initState() {
    animationController =
        AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: SingleChildScrollView( // 스크롤 가능한 영역
              child: AspectRatio(
                aspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),

                  itemCount: themeListData.length,
                  shrinkWrap: false, // GridView가 ScrollView 내에서 크기를 조정하도록 설정
                  physics: NeverScrollableScrollPhysics(), // GridView 내 스크롤 금지
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectScreen(),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 216,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, left: 10, right: 10, bottom: 10),
                                child: Container(
                                  height: 140,
                                  width: 170,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                      image: AssetImage(themeListData[index]),
                                      fit: BoxFit.cover,
                                    ),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.6),
                                        offset: const Offset(1.1, 4.0),
                                        blurRadius: 8.0,
                                      ),
                                    ],
                                    // gradient: LinearGradient(
                                    //   colors: <HexColor>[
                                    //     HexColor('#FA7D82'),
                                    //     HexColor('#FFB295'),
                                    //   ],
                                    //   begin: Alignment.topLeft,
                                    //   end: Alignment.bottomRight,
                                    // ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 0, right: 0, bottom: 10),
                              child: Text(
                                themeName[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
