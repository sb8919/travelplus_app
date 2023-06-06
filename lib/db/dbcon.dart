import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

Future<Map<String, dynamic>> MainScreenData(String user_id) async {
  try {
    final settings = ConnectionSettings(
      host: 'orion.mokpo.ac.kr',
      port: 8381,
      user: 'root',
      password: 'ScE1234**',
      db: 'Travelplus',
    );

    final conn = await MySqlConnection.connect(settings);
    final user_info = await conn.query("SELECT * FROM User WHERE user_id = '$user_id'");
    final userName = user_info
        .map((row) => row['user_name'] as String)
        .toList()[0];
    final interest_theme = user_info
        .map((row) => row['interest_theme'] as String)
        .toList()[0].split(", ");
    final user_like_place = user_info
        .map((row) => row['like_place'] as String)
        .toList()[0].split(", ");
    final recomend_place = (await conn.query("SELECT * FROM Place WHERE place_theme IN ('${interest_theme.join("', '")}')")).toList();
    final hot_place_list = (await conn.query("SELECT * FROM Place Place WHERE place_likes > 0 ORDER BY place_likes DESC;")).toList();
    final like_place_list = (await conn.query("SELECT * FROM Place WHERE place_name IN ('${user_like_place.join("', '")}')")).toList();

    return {
      'recomend_place': recomend_place,
      'hot_place_list': hot_place_list,
      'like_place_list': like_place_list,
      'userName': userName,
    };
  } catch (e) {
    print('Error reading user data: $e');
    throw Exception('Failed to fetch user data.');
  }
}

