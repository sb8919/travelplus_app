import 'package:flutter/material.dart';

import '../../main.dart';


class CustomCategoryView extends StatefulWidget {
  const CustomCategoryView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  @override
  _CustomCategoryViewState createState() => _CustomCategoryViewState();
}

class _CustomCategoryViewState extends State<CustomCategoryView> with TickerProviderStateMixin {
  AnimationController? animationController;
  List<String> customCategoryData = <String>[
    'assets/category/bossam.jpg',
    'assets/category/cafe.jpg',
    'assets/category/hanok.jpg',
    'assets/category/rose.jpg',
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
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: customCategoryData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 216,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 16, left: 8, right: 8, bottom: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(customCategoryData[index]), // 이미지 요소 사용
                            fit: BoxFit.fill,
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              offset: const Offset(1.1, 4.0),
                              blurRadius: 8.0,
                            ),
                          ],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(18.0),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            ),
          ),
        );
      },
    );
  }
}
