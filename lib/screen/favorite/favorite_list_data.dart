import 'package:mysql1/mysql1.dart';

class FavoriteListData {
  FavoriteListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.subTxt = "",
    this.dist = 1.8,
    this.reviews = 80,
    this.rating = 4.5,
    this.perNight = 180,
  });

  String imagePath;
  String titleTxt;
  String subTxt;
  double dist;
  double rating;
  int reviews;
  int perNight;

  static List<FavoriteListData> favoriteList = <FavoriteListData>[];

  static Future<void> fetch() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'orion.mokpo.ac.kr',
      port: 8381,
      user: 'root',
      password: 'ScE1234**',
      db: 'Travelplus',
    ));

    final results = (await conn.query(
        "SELECT * FROM Place Place WHERE place_likes > 0 ORDER BY place_likes DESC;"))
        .toList();
    for (var row in results) {
      final imagePath = row['place_img_url'];
      final titleTxt = row['place_name'];
      final subTxt = row['place_address'];
      final dist = 4.5;
      final rating = 4.5;

      final favoriteData = FavoriteListData(
        imagePath: imagePath,
        titleTxt: titleTxt,
        subTxt: subTxt,
        dist: dist.toDouble(),
        rating: rating.toDouble(),
      );

      favoriteList.add(favoriteData);
    }

    await conn.close();
  }
}
