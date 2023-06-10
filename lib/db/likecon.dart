import 'package:mysql1/mysql1.dart';

Future<void> addLikePlace({required String userId, required String place}) async {
  final settings = ConnectionSettings(
    host: 'orion.mokpo.ac.kr',
    port: 8381,
    user: 'root',
    password: 'ScE1234**',
    db: 'Travelplus',
  );

  final conn = await MySqlConnection.connect(settings);
  try {
    final subqueryResult = await conn.query("SELECT place_theme FROM Place WHERE place_name = '$place'");
    final placeTheme = subqueryResult.first[0] as String;
    await conn.query("INSERT INTO User_Likes (user_id, like_place, place_theme) VALUES (?, ?, ?)", [userId, place, placeTheme]);
    print('Data inserted successfully');
  } catch (e) {
    print('Failed to insert data: $e');
    throw Exception('Failed to insert data.');
  } finally {
    await conn.close();
  }
}

Future<void> deleteLikePlace({required String userId, required String place}) async {
  final settings = ConnectionSettings(
    host: 'orion.mokpo.ac.kr',
    port: 8381,
    user: 'root',
    password: 'ScE1234**',
    db: 'Travelplus',
  );

  final conn = await MySqlConnection.connect(settings);
  try {
    final subqueryResult = await conn.query("SELECT place_theme FROM Place WHERE place_name = ?", [place]);
    final placeTheme = subqueryResult.first[0] as String;
    await conn.query("DELETE FROM User_Likes WHERE user_id = ? AND like_place = ? AND place_theme = ?", [userId, place, placeTheme]);
    print('Data deleted successfully');
  } catch (e) {
    print('Failed to delete data: $e');
    throw Exception('Failed to delete data.');
  } finally {
    await conn.close();
  }
}

Future<int> ifLikePlace({required String userId, required String place}) async {
  final settings = ConnectionSettings(
    host: 'orion.mokpo.ac.kr',
    port: 8381,
    user: 'root',
    password: 'ScE1234**',
    db: 'Travelplus',
  );

  final conn = await MySqlConnection.connect(settings);
  try {
    final PlaceNull = await conn.query("SELECT COUNT(*) FROM User_Likes WHERE user_id =? and like_place =?;", [userId, place]);
    return PlaceNull.first.fields['COUNT(*)'] as int;
  } catch (e) {
    print('Failed to check data: $e');
    throw Exception('Failed to check data.');
  } finally {
    await conn.close();
  }
}
