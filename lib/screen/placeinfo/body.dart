import 'package:flutter/material.dart';
import 'package:travel_plus/screen/placeinfo/IconCard.dart';
import 'package:travel_plus/screen/placeinfo/image_and_icons.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        ImageAndicons(size: size),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "속초\n",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                      ),
                    ),
                    TextSpan(
                      text: "가족여행",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w300,
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Column(
                children: [
                  IconButton(icon: Icon(Icons.favorite_border_outlined,color: Colors.red, size: 30,),onPressed: (){},),
                  Text('16',style: TextStyle(fontWeight: FontWeight.bold,))
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
