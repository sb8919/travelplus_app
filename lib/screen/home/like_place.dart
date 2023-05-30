import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../detail/detail_screen.dart';

class LikePlace extends StatelessWidget {
  const LikePlace({
    Key? key,
    required this.placelist,
  }) : super(key: key);

  final List placelist;

  @override
  Widget build(BuildContext context) {
    if (placelist.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top:30,bottom:30),
        child: Center(
          child: Text('좋아요 누른 장소가 없습니다.'),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 16,
        ),
        child: Wrap(
          alignment: WrapAlignment.start,
          children: placelist.map<Widget>((place) {
            String image = place[4].toString();
            String place_name = place[0].toString();
            String place_theme = place[2].toString();

            return LikePlaceItem(
              image: image,
              place_name: place_name,
              place_theme: place_theme,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class LikePlaceItem extends StatelessWidget {
  const LikePlaceItem({
    Key? key,
    required this.image,
    required this.place_name,
    required this.place_theme,
    required this.press,
  }) : super(key: key);

  final String image, place_name, place_theme;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        left: 16,
        top: 8,
        bottom: 20,
      ),
      width: size.width * 0.4,
      child: Column(
        children: [
          GestureDetector(
            onTap: press,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              height:120,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: CachedNetworkImage(imageUrl: image,fit: BoxFit.cover),
              ),
            ),
          ),
          GestureDetector(
            onTap: press,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.13),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "$place_name\n",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        TextSpan(
                          text: "$place_theme",
                          style: TextStyle(
                            color: Colors.grey.withOpacity(0.9),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
