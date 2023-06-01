import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysql1/mysql1.dart';
import 'package:travel_plus/main.dart';


void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // MySQL 데이터베이스 연결 설정
    final settings = ConnectionSettings(
      host: 'orion.mokpo.ac.kr',
      port: 8281,
      user: 'root',
      password: 'ScE1234**',
      db: 'Users',
    );

    // 데이터베이스 연결
    final conn = await MySqlConnection.connect(settings);

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(conn: conn));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}