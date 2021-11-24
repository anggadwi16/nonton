import 'package:ditonton/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('show page tv series', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    final drawer = find.byIcon(Icons.menu);
    await tester.tap(drawer);
    await tester.pumpAndSettle();
    final tvSeriesMenu = find.byIcon(Icons.live_tv);
    await tester.tap(tvSeriesMenu);
    await tester.pumpAndSettle(Duration(seconds: 2));
    expect(find.text('TV Series'), findsOneWidget);
  });
}
