import 'package:flutter/material.dart';
import 'logo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'JejuGothic',
      ),
      home: Logo(),
    );
  }
}