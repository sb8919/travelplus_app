import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../db/likecon.dart';
import '../placeinfo/place_info_screen.dart';

class LikePlace extends StatefulWidget {
  const LikePlace({
    Key? key,
    required this.placelist,
    required this.user_id,
  }) : super(key: key);

  final List placelist;
  final String user_id;

  @override
  _LikePlaceState createState() => _LikePlaceState();
}

class _LikePlaceState extends State<LikePlace> {
  void _removePlace(int index, userid, place_name) {
    deleteLikePlace(userId: userid, place: place_name);
    setState(() {
      widget.placelist.removeAt(index);
    });

  }
  void _addPlaceToList(int index, userid, place_name) {
    setState(() {
      widget.placelist.add(place_name);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.placelist.isEmpty) {
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
          children: List.generate(widget.placelist.length, (index) {
            var place = widget.placelist[index];
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
                    builder: (context) => PlaceInfoScreen(user_id: widget.user_id, placeName:place_name),
                  ),
                );
              },
              remove: () {
                _removePlace(index,widget.user_id,place_name);
              },
            );
          }),
        ),
      ),
    );
  }
}

class LikePlaceItem extends StatelessWidget {
  const LikePlaceItem({
    Key? key,
    required this.image,
    required this.place_name,
    required this.place_theme,
    required this.press,
    required this.remove,
  }) : super(key: key);

  final String image, place_name, place_theme;
  final VoidCallback press;
  final VoidCallback remove;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: press,
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
                      imageUrl: image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: press,
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
                                  text: "${place_name}\n",
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                TextSpan(
                                  text: "${place_theme}",
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
                onPressed: remove,
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
