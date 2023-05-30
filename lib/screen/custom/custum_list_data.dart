class CustumListData {
  CustumListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.meals,
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String>? meals;

  static List<CustumListData> tabIconsList = <CustumListData>[
    CustumListData(
      imagePath: 'assets/recommend/busan.jpeg',
      titleTxt: 'Breakfast',
      meals: <String>['Bread,', 'Peanut butter,', 'Apple'],
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    CustumListData(
      imagePath: 'assets/recommend/gyeonju.jpg',
      titleTxt: 'Lunch',
      meals: <String>['Salmon,', 'Mixed veggies,', 'Avocado'],
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    CustumListData(
      imagePath: 'assets/recommend/sokcho.jpg',
      titleTxt: 'Snack',
      meals: <String>['Recommend:', '800 kcal'],
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    CustumListData(
      imagePath: 'assets/recommend/wooncheon.jpg',
      titleTxt: 'Dinner',
      meals: <String>['Recommend:', '703 kcal'],
      startColor: '#6F72CA',
      endColor: '#1E1466',
    ),
  ];
}
