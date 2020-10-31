import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_instant_messenger/screens/login.dart';

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(buildTestableWidget(LoginScreen()));
    await tester.pumpAndSettle();

    final titleFinder = find.text('AeroGrow');
    final subtitleFinder = find.text('Messaging App');

    expect(titleFinder, findsOneWidget);
    expect(subtitleFinder, findsOneWidget);

    //expect(find.text('AeroGrow'), findsOneWidget);
    //expect(find.text('Messaging App'), findsOneWidget);

    //var textFormField = find.byType(TextFormField);
    //expect(TextFormField, findsWidgets);
    //await tester.enterText(textFormField, 'Hello');
    //expect(find.text('Hello'), findsOneWidget);

    /* 
    //Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    //Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
    */
  });
}
