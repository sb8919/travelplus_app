import 'package:flutter/material.dart' as place_info;
import 'package:travel_plus/screen/placeinfo/body.dart';

class PlaceInfoScreen extends place_info.StatelessWidget {
  const PlaceInfoScreen({place_info.Key? key}) : super(key: key);

  @override
  place_info.Widget build(place_info.BuildContext context) {
    return place_info.Scaffold(
      appBar: place_info.AppBar(
        backgroundColor: place_info.Colors.white,
        title: place_info.Text(
          '추천장소',
          style: place_info.TextStyle(
            color: place_info.Colors.black,
          ),
        ),
        leading: place_info.IconButton(
          icon: place_info.Icon(
            place_info.Icons.arrow_back_ios,
            color: place_info.Colors.black,
          ),
          onPressed: () {
            place_info.Navigator.pop(context);
          },
        ),
      ),
      body:Body(),
    );
  }
}
