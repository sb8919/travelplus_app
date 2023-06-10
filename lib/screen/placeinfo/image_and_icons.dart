import 'package:flutter/material.dart';
import 'package:travel_plus/screen/placeinfo/IconCard.dart';

class ImageAndicons extends StatelessWidget {
  const ImageAndicons({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 48,),
      child: SizedBox(
        height: size.height * 0.8,
        child: Row(
          children: [

          ],
        ),
      ),
    );
  }
}

