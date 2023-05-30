class CategoryListData {
  CategoryListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.subTxt = "",
  });

  String imagePath;
  String titleTxt;
  String subTxt;

  static List<CategoryListData> categoryList = <CategoryListData>[
    CategoryListData(
      imagePath: 'assets/recommend/pocheon.jpg',
      titleTxt: '카멜리아힐',
      subTxt: '제주시',
    ),
    CategoryListData(
      imagePath: 'assets/recommend/tongyeong.jpg',
      titleTxt: '속초 해수욕장',
      subTxt: '강원도 속초시',
    ),
    CategoryListData(
      imagePath: 'assets/recommend/busan.jpeg',
      titleTxt: '광안리',
      subTxt: '부산광역시',
    ),

  ];
}
