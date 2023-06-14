import 'package:mysql1/mysql1.dart';

class IntrestData {
  IntrestData({
    this.user_id = '',
    this.like_place = '',
    this.place_theme = "",
  });

  String user_id;
  String like_place;
  String place_theme;

  static List<IntrestData> IntrestDataList = <IntrestData>[];

  static Future<void> fetch() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'orion.mokpo.ac.kr',
      port: 8381,
      user: 'root',
      password: 'ScE1234**',
      db: 'Travelplus',
    ));

    final results = (await conn.query("SELECT * FROM User_Likes;")).toList();
    for (var row in results) {
      final user_id = row['user_id'];
      final like_place = row['like_place'];
      final place_theme = row['place_theme'];

      final IntrestDataset = IntrestData(
        user_id: user_id,
        like_place: like_place,
        place_theme: place_theme,
      );

      IntrestDataList.add(IntrestDataset);
    }

    await conn.close();
  }
}

class User {
  String id; // 사용자 ID
  List<List<dynamic>> likedPlaces; // 좋아요한 장소 목록 [장소, 카테고리]

  User(this.id, this.likedPlaces);
}

class Recommender {
  List<User> users = []; // 사용자 목록

  Recommender(List<IntrestData> intrestDataList) {
    users = [];

    // IntrestDataList를 이용하여 User 객체 생성 및 users에 추가
    for (IntrestData intrestData in intrestDataList) {
      String userId = intrestData.user_id;
      String place = intrestData.like_place;
      String category = intrestData.place_theme;

      // User 객체 생성
      User user = users.firstWhere((user) => user.id == userId, orElse: () {
        List<List<dynamic>> likedPlaces = [];
        User newUser = User(userId, likedPlaces);
        users.add(newUser);
        return newUser;
      });

      // 좋아요한 장소 정보 추가
      List<dynamic> likedPlace = [place, category];
      user.likedPlaces.add(likedPlace);
    }

  }

  List<String> recommendPlaces(String userId, int topN) {
    // 해당 사용자에게 장소 추천을 제공하는 함수
    // userId: 추천을 받을 사용자의 ID
    // topN: 상위 N개의 추천 장소

    // ID를 기반으로 사용자 찾기
    User user = users.firstWhere((user) => user.id == userId, orElse: () => User("", []));
    if (user == null) {
      return [];
    }

    // 다른 사용자와의 유사도 점수 계산
    Map<User, double> similarityScores = {};
    for (User otherUser in users) {
      if (otherUser.id != user.id) {
        double score = calculateSimilarity(user, otherUser);
        similarityScores[otherUser] = score;
      }
    }

    // 유사도 점수를 기준으로 사용자 정렬
    List<User> similarUsers = similarityScores.keys.toList();
    similarUsers.sort((a, b) {
      double scoreA = similarityScores[a] ?? 0.0;
      double scoreB = similarityScores[b] ?? 0.0;
      return scoreB.compareTo(scoreA);
    });

    // 유사한 사용자로부터 장소 추천 수집
    Set<String> recommendedPlaces = {};
    for (User similarUser in similarUsers) {
      for (List<dynamic> likedPlace in similarUser.likedPlaces) {
        String place = likedPlace[0]; // 장소
        String category = likedPlace[1]; // 카테고리

        bool isPlaceLiked = user.likedPlaces.any((likedPlace) => likedPlace[0] == place);
        if (!isPlaceLiked) {
          recommendedPlaces.add(place);
        }

        if (recommendedPlaces.length >= topN) {
          break;
        }
      }

      if (recommendedPlaces.length >= topN) {
        break;
      }
    }

    return recommendedPlaces.toList();
  }

  double calculateSimilarity(User user1, User user2) {

    Set user1LikedSet = user1.likedPlaces.map((place) => place[0]).toSet();
    Set user2LikedSet = user2.likedPlaces.map((place) => place[0]).toSet();

    Set intersection = user1LikedSet.intersection(user2LikedSet);
    Set union = user1LikedSet.union(user2LikedSet);

    double similarity = intersection.length / union.length;
    return similarity;
  }
}
//
// void main() async {
//   await IntrestData.fetch();
//
//   List<IntrestData> intrestDataList = IntrestData.IntrestDataList;
//
//   Recommender recommender = Recommender(intrestDataList);
//   List<String> recommendations = recommender.recommendPlaces('test', 3);
//   // 사용자1에게 상위 3개의 추천 장소 얻기
//
//   for (User user in recommender.users) {
//     print("사용자 ID: ${user.id}");
//     print("좋아요한 장소 목록:");
//     for (List<dynamic> likedPlace in user.likedPlaces) {
//       String place = likedPlace[0];
//       String category = likedPlace[1];
//       print("장소: $place, 카테고리: $category");
//
//     }
//     List<String> recommendations = recommender.recommendPlaces(user.id, 3);
//     print("사용자1에게 추천하는 장소: $recommendations");
//     print("-----------------------------");
//   }
// }