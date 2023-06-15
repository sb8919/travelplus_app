
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../favorite/favorite_list_theme.dart';


class HotPlaceList extends StatelessWidget {
  const HotPlaceList(
      {Key? key,
        required this.placeName,
        required this.placeTheme,
        required this.placeLikes,
        required this.placeImage,
        this.callback, })
      : super(key: key);

  final VoidCallback? callback;
  final String placeName;
  final String placeTheme;
  final String placeLikes;
  final String placeImage;


  @override
  Widget build(BuildContext context) {
    return
      Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: callback,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(4, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 2,
                              child: CachedNetworkImage(
                                imageUrl: placeImage, // Replace with your image URL property
                                fit: BoxFit.cover,
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                            Container(
                              color: FavoriteListTheme.buildLightTheme()
                                  .backgroundColor,
                              child:
                                   Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 12, bottom: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              placeName,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 22,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 7),
                                              child: Text(
                                                placeTheme,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey
                                                        .withOpacity(0.8)),
                                              ),
                                            ),
                                     ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: <Widget>[

                                          Padding(
                                            padding: const EdgeInsets.only(right:5),
                                            child: Icon(
                                                  Icons.favorite,
                                                  size: 20,
                                                  color: Colors.black
                                                 ),
                                          ),
                                          Text(
                                            placeLikes,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black
                                                    .withOpacity(0.8)),
                                          ),
                                               ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ),
                                ],
                            ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(32.0),
                              ),
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                        )
                          ],
                        ),

                    ),
                  ),
                ),
              );
  }
}