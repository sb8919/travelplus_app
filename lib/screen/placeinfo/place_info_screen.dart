import 'package:flutter/material.dart';
import 'package:travel_plus/screen/placeinfo/body.dart';

class PlaceInfoScreen extends StatelessWidget {
  final String placeName;
  final String user_id;

  const PlaceInfoScreen({Key? key, required this.placeName, required this.user_id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '추천장소',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Body(placeName: placeName,user_id: user_id,),
    );
  }
}
