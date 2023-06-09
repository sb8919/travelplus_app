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
    final recomend_place = (await conn.query("SELECT * FROM Place WHERE place_theme IN ('${interest_theme.join("', '")}')")).toList();
    final hot_place_list = (await conn.query("SELECT * FROM Place Place WHERE place_likes > 0 ORDER BY place_likes DESC;")).toList();
    final like_place_list = (await conn.query("SELECT * FROM Place WHERE place_name IN (SELECT like_place FROM User_Likes WHERE user_id='$user_id')")).toList();

    return {
      'recomend_place': recomend_place,
      'interest_theme': interest_theme.toString().replaceAll('[', '').replaceAll(']', ''),
      'hot_place_list': hot_place_list,
      'like_place_list': like_place_list,
      'userName': userName,
    };
  } catch (e) {
    print('Error reading user data: $e');
    throw Exception('Failed to fetch user data.');
  }
}