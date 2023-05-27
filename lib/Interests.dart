import 'package:flutter/material.dart';
import 'package:travel_login2/region.dart';

class InterestsPage extends StatefulWidget {
  final String name;

  InterestsPage({required this.name});

  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  List<String> selectedInterests = [];

  void toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('관심사를 선택해주세요.'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CheckboxListTile(
              title: Text('가볼만한곳'),
              value: selectedInterests.contains('가볼만한곳'),
              onChanged: (bool? value) {
                toggleInterest('가볼만한곳');
              },
            ),
            CheckboxListTile(
              title: Text('가족여행'),
              value: selectedInterests.contains('가족여행'),
              onChanged: (bool? value) {
                toggleInterest('가족여행');
              },
            ),
            CheckboxListTile(
              title: Text('관람'),
              value: selectedInterests.contains('관람'),
              onChanged: (bool? value) {
                toggleInterest('관람');
              },
            ),
            CheckboxListTile(
              title: Text('맛집'),
              value: selectedInterests.contains('맛집'),
              onChanged: (bool? value) {
                toggleInterest('맛집');
              },
            ),
            CheckboxListTile(
              title: Text('우정여행'),
              value: selectedInterests.contains('우정여행'),
              onChanged: (bool? value) {
                toggleInterest('우정여행');
              },
            ),
            CheckboxListTile(
              title: Text('전통'),
              value: selectedInterests.contains('전통'),
              onChanged: (bool? value) {
                toggleInterest('전통');
              },
            ),
            CheckboxListTile(
              title: Text('체험'),
              value: selectedInterests.contains('체험'),
              onChanged: (bool? value) {
                toggleInterest('체험');
              },
            ),
            CheckboxListTile(
              title: Text('카페'),
              value: selectedInterests.contains('카페'),
              onChanged: (bool? value) {
                toggleInterest('카페');
              },
            ),
            CheckboxListTile(
              title: Text('캠핑'),
              value: selectedInterests.contains('캠핑'),
              onChanged: (bool? value) {
                toggleInterest('캠핑');
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print('Selected Interests: $selectedInterests'); // 선택된 관심사 출력

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Region(name: widget.name),
                  ),
                );
              },
              child: Text('다음'),
            ),
          ],
        ),
      ),
    );
  }
}