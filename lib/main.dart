import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'logo/logo.dart';

void main() async {
  // MySQL 데이터베이스 연결 설정
  final settings = ConnectionSettings(
    host: 'orion.mokpo.ac.kr',
    port: 8381,
    user: 'root',
    password: 'ScE1234**',
    db: 'Travelplus',
  );

  // 데이터베이스 연결
  final conn = await MySqlConnection.connect(settings);

  // 앱 실행
  runApp(MyApp(conn: conn));
}

class MyApp extends StatelessWidget {
  final MySqlConnection conn;

  const MyApp({required this.conn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'JejuGothic',
      ),
      home: Logo(conn: conn),
    );
  }
}