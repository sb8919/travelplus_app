import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mysql1/mysql1.dart';

import '../../db/likecon.dart';


class PlaceListMap extends StatefulWidget {
  final String user_id;

  const PlaceListMap({Key? key, required this.user_id}) : super(key: key);


  @override
  _PlaceListMapState createState() => _PlaceListMapState();
}

class _PlaceListMapState extends State<PlaceListMap> {
  List<List<String>> places = [];
  Future<void> MainScreenData() async {
    try {
      final settings = ConnectionSettings(
        host: 'orion.mokpo.ac.kr',
        port: 8381,
        user: 'root',
        password: 'ScE1234**',
        db: 'Travelplus',
      );

      final conn = await MySqlConnection.connect(settings);
      final like_place_list = await conn.query("SELECT * FROM Place");
      setState(() {
        places = like_place_list.map<List<String>>((resultRow) {
          return [
            resultRow['place_name'],
            resultRow['place_img_url'],
            resultRow['place_address'],
            resultRow['place_theme'],
            resultRow['latitude'].toString(),
            resultRow['longitude'].toString(),
          ];
        }).toList();
      });
    } catch (e) {
      print('Error reading user data: $e');
      throw Exception('Failed to fetch user data.');
    }
  }

  final MapController mapController = MapController();
  int selectedIndex = -1;
  Position? currentPosition;
  PageController pageController = PageController(viewportFraction: 0.8);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    MainScreenData();
  }
  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentPosition = position;
        // 현재 위치로 지도 이동
        mapController.move(
          LatLng(
            currentPosition?.latitude ?? 34.7903335,
            currentPosition?.longitude ?? 126.3847547,
          ),
          15.0,
        );
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: LatLng(
              currentPosition?.latitude ?? 34.7903335,
              currentPosition?.longitude ?? 126.3847547,
            ),
            zoom: 15.0,
            onPositionChanged: (MapPosition position, bool hasGesture) {},
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayerOptions(
              markers: _buildMarkers(),
              rotate: false,
            ),
            CircleLayerOptions(
              circles: _buildCircles(),
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 250,
            width: MediaQuery.of(context).size.width - 20,
            child: PageView.builder(
              controller: pageController,
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                          mapController.move(
                            LatLng(
                              double.parse(place[4]),
                              double.parse(place[5]),
                            ),
                            15.0,
                          );
                        });
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(8.0),
                        elevation: 0.0,
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(8.0),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(8.0),
                                ),
                                child: Image.network(
                                  place[1],
                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                          : null,
                                    );
                                  },
                                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                    return Icon(Icons.error);
                                  },
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        place[0],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          height: 2,
                                        ),
                                      ),
                                      Text(
                                        place[2],
                                        style: TextStyle(fontSize: 14.0, height: 1.3),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(selectedIndex == places.indexOf(place) ? Icons.favorite : Icons.favorite_border),
                                    color: Colors.red,
                                    onPressed: () async {
                                      final likePlaceCount = await ifLikePlace(userId: widget.user_id, place: place[0]);

                                      if (likePlaceCount == 0) {
                                        addLikePlace(userId: widget.user_id, place: place[0]);
                                      } else {
                                        deleteLikePlace(userId: widget.user_id, place: place[0]);
                                      }

                                      setState(() {
                                        selectedIndex = likePlaceCount == 0 ? places.indexOf(place) : -1;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 255.0,
          right: 16.0,
          child: FloatingActionButton(
            backgroundColor: Colors.white70,
            onPressed: () {
              mapController.move(
                LatLng(
                  currentPosition?.latitude ?? 34.7903335,
                  currentPosition?.longitude ?? 126.3847547,
                ),
                15.0,
              );
            },
            child: Icon(Icons.my_location, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  List<Marker> _buildMarkers() {
    List<Marker> markers = [];

    for (int i = 0; i < places.length; i++) {
      final place = places[i];
      final double latitude = double.parse(place[4]);
      final double longitude = double.parse(place[5]);
      final marker = Marker(
        width: 60.0,
        height: 60.0,
        point: LatLng(latitude, longitude),
        builder: (context) => Icon(
          i == selectedIndex ? Icons.location_on : Icons.location_on_outlined,
          color: i == selectedIndex ? Colors.red : Colors.red,
        ),
      );
      markers.add(marker);
    }

    return markers;
  }

  List<CircleMarker> _buildCircles() {
    List<CircleMarker> circles = [];

    if (currentPosition != null) {
      final circle = CircleMarker(
        point: LatLng(
          currentPosition!.latitude,
          currentPosition!.longitude,
        ),
        color: Colors.blue.withOpacity(0.8),
        useRadiusInMeter: true,
        radius: 50, // 원의 반지름 (미터)
      );
      circles.add(circle);
    }

    return circles;
  }
}
