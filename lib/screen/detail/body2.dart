import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mysql1/mysql1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Map Example'),
        ),
        body: Body2(),
      ),
    );
  }
}

class Body2 extends StatefulWidget {
  @override
  _Body2State createState() => _Body2State();
}

class _Body2State extends State<Body2> {
  List<List<String>> places = [];
  Future<void> MainScreenData({required String user_id}) async {
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
      print(like_place_list);
      setState(() {
        places = like_place_list.map<List<String>>((resultRow) {
          return [
            resultRow['place_name'],
            resultRow['place_img_url'],
            resultRow['place_address'],
            resultRow['place_theme'],
            '37.582275',
            '126.975728',
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

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    MainScreenData(user_id: 'test');
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentPosition = position;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 7,
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: LatLng(
                currentPosition?.latitude ?? 37.5665,
                currentPosition?.longitude ?? 126.9780,
              ),
              zoom: 12.0,
              onPositionChanged: (MapPosition position, bool hasGesture) {},
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(
                markers: _buildMarkers(),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  children: [
                    Container(
                      width: 390,
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
                        onTap: (){},
                        child: Material(
                          borderRadius: BorderRadius.circular(8.0),
                          elevation: 0.0,
                          color: Colors.white, // 배경색을 흰색으로 설정
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
                                child: Text(
                                  place[0],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  place[2],
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.favorite),
                        color: Colors.red,
                        onPressed: () {
                          // Add your logic here
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
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
        width: 30.0,
        height: 30.0,
        point: LatLng(latitude, longitude),
        builder: (context) => Icon(
          i == selectedIndex ? Icons.location_on : Icons.location_on_outlined,
          color: i == selectedIndex ? Colors.red : Colors.blue,
        ),
      );
      markers.add(marker);
    }

    return markers;
  }
}
