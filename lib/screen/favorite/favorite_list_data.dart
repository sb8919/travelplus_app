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

  static List<FavoriteListData> favoriteList = <FavoriteListData>[
    FavoriteListData(
      imagePath: 'assets/recommend/jejucamel.jpg',
      titleTxt: '카멜리아힐',
      subTxt: '제주도',
      dist: 3.0,
      reviews: 62,
      rating: 4.0,
      perNight: 60,
    ),
    FavoriteListData(
      imagePath: 'assets/recommend/sokcho.jpg',
      titleTxt: '속초 해수욕장',
      subTxt: '강원도',
      dist: 2.0,
      reviews: 240,
      rating: 4.5,
      perNight: 200,
    ),
    FavoriteListData(
      imagePath: 'assets/recommend/busan.jpeg',
      titleTxt: '광안리',
      subTxt: '부산광역시',
      dist: 2.0,
      reviews: 80,
      rating: 4.4,
      perNight: 180,
    ),
    FavoriteListData(
      imagePath: 'assets/recommend/gyeonju.jpg',
      titleTxt: '월정교',
      subTxt: '경상북도',
      dist: 4.0,
      reviews: 74,
      rating: 4.5,
      perNight: 200,
    ),
    FavoriteListData(
      imagePath: 'assets/recommend/saryeony.jpg',
      titleTxt: '사려니 숲길',
      subTxt: '제주도',
      dist: 7.0,
      reviews: 90,
      rating: 4.4,
      perNight: 170,
    ),
  ];
}
