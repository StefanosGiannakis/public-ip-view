import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:public_ip_view/main.dart';

void main() {
  testWidgets('Public IP Viewer smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Public IP Viewer'), findsOneWidget);

    expect(find.text('Your current public IP address:'), findsOneWidget);

    expect(find.text('Update Widget'), findsOneWidget);

    expect(find.text('The home screen widget will update automatically every 30 minutes.'), findsOneWidget);
  });
}
