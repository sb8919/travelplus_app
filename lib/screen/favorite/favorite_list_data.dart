import 'package:mysql1/mysql1.dart';

class FavoriteListData {
  FavoriteListData({
    this.imagePath = '',
    this.placeName = '',
    this.placeAdd = "",
    this.placeTheme = '',
    this.cityName = '',
    this.dist = 1.8,
    this.reviews = 80,
    this.rating = 4.5,
    this.perNight = 180,
  });

  String imagePath;
  String placeName;
  String placeAdd;
  String placeTheme;
  String cityName;
  double dist;
  double rating;
  int reviews;
  int perNight;

  // placeName의 게터 추가
  String get getPlaceName => placeName;

  // cityName의 게터 추가
  String get getCityName => cityName;

  static List<FavoriteListData> favoriteList = <FavoriteListData>[];

  static Future<void> fetch({required user_id}) async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'orion.mokpo.ac.kr',
      port: 8381,
      user: 'root',
      password: 'ScE1234**',
      db: 'Travelplus',
    ));

    final results = (await conn.query(
        "SELECT * FROM Place WHERE place_name IN (SELECT like_place FROM User_Likes WHERE user_id = '$user_id');;"))
        .toList();
    for (var row in results) {
      final imagePath = row['place_img_url'];
      final placeName = row['place_name'];
      final placeAdd = row['place_address'];
      final placeTheme = row['place_theme'];
      final cityName = placeAdd.split(' ')[0];
      final dist = 4.5;
      final rating = 4.5;

      final favoriteData = FavoriteListData(
        imagePath: imagePath,
        placeName: placeName,
        placeAdd: placeAdd,
        cityName: cityName,
        dist: dist.toDouble(),
        rating: rating.toDouble(),
      );

      favoriteList.add(favoriteData);
    }

    await conn.close();
  }
}