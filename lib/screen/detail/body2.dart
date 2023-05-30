import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

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
  final List<List<String>> places = [
    ['국립중앙박물관', 'https://mblogthumb-phinf.pstatic.net/MjAxNzA0MTlfMjQz/MDAxNDkyNTYzODEyMjM1.asJemRHPvGeTufk03cAV1xVHt49B9bZf1FVaVv9PEJwg.N86ae6g8rEOF0Bziblm-BOiy4HwbNVW_hRo72CCNH2Yg.JPEG.kotfa198643/IMG_0750-01.jpg?type=w800', '서울특별시 종로구 삼청로 37', '문화/역사', '37.582275', '126.975728'],
    ['서울타워', 'https://media.triple.guide/triple-cms/c_limit,f_auto,h_1024,w_1024/aa5a2b0c-6c55-4353-8837-7fbc84e377bd.jpeg', '서울특별시 용산구 남산공원길 105', '명소/전망대', '37.551510', '126.988018'],
    ['경복궁', 'https://a.cdn-hotels.com/gdcs/production60/d893/3172bd6f-726c-4561-810f-deec13d17a6e.jpg?impolicy=fcrop&w=800&h=533&q=medium', '서울특별시 종로구 사직로 161', '문화/역사', '37.579621', '126.977011'],
    // 추가적인 기관들을 원하는 만큼 리스트에 추가할 수 있습니다.
  ];

  final MapController mapController = MapController();
  int selectedIndex = -1;
  Position? currentPosition; // 현재 위치를 저장할 변수

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];
              return ListTile(
                title: Text(place[0]),
                leading: Image.network(
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
                ),
                subtitle: Text(place[2]),
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  final double latitude = double.parse(place[4]);
                  final double longitude = double.parse(place[5]);
                  mapController.move(
                    LatLng(latitude, longitude),
                    16.0,
                  );
                },
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
