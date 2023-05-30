import 'package:flutter/material.dart';


class TitlewithMoreBtn extends StatelessWidget {
  const TitlewithMoreBtn({
    Key? key,
    required this.title,
    required this.press, required this.backgroundColor,
  }) : super(key: key);

  final String title;
  final Color backgroundColor;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          TitleWidthCustom(text: title,backgroundColor: backgroundColor,),
          Spacer(),
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.grey,
            onPressed: press,
          ),
        ],
      ),
    );
  }
}




class TitleWidthCustom extends StatelessWidget {
  const TitleWidthCustom({
    super.key,
    required this.text, required this.backgroundColor,
  });

  final String text;
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 24,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                text,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.only(left: 1),
                height: 10,
                color: backgroundColor.withOpacity(0.2),
              ),
            ),
          ],
        ));
  }
}
