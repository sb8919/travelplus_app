import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../db/likecon.dart';
import '../map/map_screen.dart';
import 'body.dart';

class LikePlace extends StatelessWidget {
  const LikePlace({
    Key? key,
    required this.placelist,
  }) : super(key: key);

  final List placelist;

  @override
  Widget build(BuildContext context) {
    if (placelist.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 30),
        child: Center(
          child: Text('좋아요 누른 장소가 없습니다.'),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 16,
        ),
        child: Wrap(
          alignment: WrapAlignment.start,
          children: placelist.map<Widget>((place) {
            String image = place[4].toString();
            String place_name = place[0].toString();
            String place_theme = place[2].toString();

            return LikePlaceItem(
              image: image,
              place_name: place_name,
              place_theme: place_theme,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class LikePlaceItem extends StatefulWidget {
  const LikePlaceItem({
    Key? key,
    required this.image,
    required this.place_name,
    required this.place_theme,
    required this.press,
  }) : super(key: key);

  final String image, place_name, place_theme;
  final VoidCallback press;

  @override
  _LikePlaceItemState createState() => _LikePlaceItemState();
}

class _LikePlaceItemState extends State<LikePlaceItem> {
  bool isFavorite = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: widget.press,
      child: Container(
        margin: EdgeInsets.only(
          left: 16,
          top: 8,
          bottom: 20,
        ),
        width: size.width * 0.4,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: widget.press,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${widget.place_name}\n",
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                TextSpan(
                                  text: "${widget.place_theme}",
                                  style: TextStyle(
                                    color: Colors.grey.withOpacity(0.9),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: -5,
              right: -5,
              child: IconButton(
                onPressed: () {
                  toggleFavorite();
                  deleteLikePlace(userId: 'test', place: '목포자연사박물관');
                },
                icon: Icon(
                  Icons.favorite,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
