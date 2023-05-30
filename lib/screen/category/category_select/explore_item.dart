import 'package:flutter/material.dart';

class ExploreItem extends StatelessWidget {
  ExploreItem({ Key? key, required this.data, this.radius = 10 }) : super(key: key);
  final data;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final double size = (MediaQuery.of(context).size.width*0.5);

    return Container(
      width: size,
      height: size,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          children: [
            Container(
              child:  Image(
                image: AssetImage(data["image"]),
                fit: BoxFit.cover,
                alignment: Alignment.center,
                width: size,
                height: size,
              ),
            ),
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(.5),
                        Colors.white.withOpacity(.01),
                      ]
                  )
              ),
            ),
            Positioned(
              bottom: 12,
              left: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data["name"],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
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
