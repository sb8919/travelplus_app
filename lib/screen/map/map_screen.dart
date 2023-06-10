import 'package:flutter/material.dart';
import 'package:travel_plus/screen/map/PlaceListMap.dart';

import '../../mainPage.dart';
import '../home/body.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key,required this.user_id}) : super(key: key);

  final String user_id;
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainPage(id: user_id)),
            );
          },
        ),
      ),
      body:PlaceListMap(user_id:user_id),
    );
  }
}
