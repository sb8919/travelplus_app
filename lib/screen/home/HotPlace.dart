import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../detail/detail_screen.dart';

class HotPlace extends StatelessWidget {
  const HotPlace({
    super.key,
    required this.placelist,
  });

  final List placelist;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 16,
        ),
        child: Row(
          children: placelist.map<Widget>((place) {
            String image = place[4].toString();
            String place_name = place[0].toString();
            String place_theme = place[2].toString();
            String like_counting = place[3].toString();
            return HotPlaceElement(
              image: image,
              place_name: place_name,
              place_theme: place_theme,
              like_counting: like_counting,
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

class HotPlaceElement extends StatelessWidget {
  const HotPlaceElement({
    Key? key,
    required this.image,
    required this.press,
    required this.place_name,
    required this.place_theme,
    required this.like_counting,
  }) : super(key: key);

  final String image;
  final VoidCallback press;
  final String place_name;
  final String place_theme;
  final String like_counting;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: EdgeInsets.only(
          left: 16,
          top: 8,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 10,
              color: Colors.black.withOpacity(0.13),
            ),
          ],
        ),
        width: size.width * 0.8,
        height: 185,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(imageUrl: image,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 25,
              left: 16,
              child: Text(
                place_name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 11,
              left: 16,
              child: Text(
                place_theme,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
            Positioned(
              bottom: 11,
              right: 20,
              child: Row(
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: Text(
                      like_counting,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
