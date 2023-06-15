import 'package:mysql1/mysql1.dart';

class CategorySelectList {
  CategorySelectList({
    this.imagePath = '',
    this.placeName = '',
    this.placeAdd = '',
    this.placeTheme = '',



  });

  String imagePath;
  String placeName;
  String placeAdd;
  String placeTheme;


  static List<CategorySelectList> selectData = <CategorySelectList>[];

  static Future<void> fetch(String place_theme) async {
    final settings = ConnectionSettings(
      host: 'orion.mokpo.ac.kr',
      port: 8381,
      user: 'root',
      password: 'ScE1234**',
      db: 'Travelplus',
    );
    final conn = await MySqlConnection.connect(settings);
    final selected_theme_place = (await conn.query(
        "SELECT * FROM Place WHERE place_theme = '$place_theme'"))
        .toList();
    print(selected_theme_place);

    for (var row in selected_theme_place) {
      final imagePath = row['place_img_url'];
      final placeName = row['place_name'];
      final placeAdd = row['place_address'];
      final placeTheme = row['place_theme'];


      final selectListData =  CategorySelectList(
        imagePath: imagePath,
        placeName: placeName,
        placeAdd: placeAdd,
        placeTheme: placeTheme,

      );

      selectData.add(selectListData);
      print(selectData);
      print(selectListData);

    }


    await conn.close();
  }
}
List selectData = [
  {
    "image": 'assets/category_image/chumsung.png',
    "name": "경주시",
    "location": "sokcho",
    "rate": 5,
    "id": "pro010",
  },
  {
    "image": 'assets/category_image/mokpo.png',
    "name": "목포시",
    "location": "mokpo",
    "rate": 4,
    "id": "pro010",
  },
  {
    "image": 'assets/category_image/geoje.png',
    "name": "광주광역시",
    "location": "gwangju",
    "rate": 4,
    "id": "pro010",
  },
  {
    "image": 'assets/category_image/namsan.png',
    "name": "서울특별시",
    "location": "sokcho",
    "rate": 4,
    "id": "pro010",
  },
  {
    "image": 'assets/category_image/sooncheon.png',
    "name": "순천시",
    "location": "busan",
    "rate": 4,
    "id": "pro010",
  },
  {
    "image": 'assets/category_image/thehyundai.png',
    "name": "서울특별시",
    "location": "gwangju",
    "rate": 4,
    "id": "pro010",
  },
];
