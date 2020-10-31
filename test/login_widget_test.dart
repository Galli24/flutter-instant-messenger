import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/screens/profile.dart';
import 'package:flutter_instant_messenger/screens/register.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_instant_messenger/screens/login.dart';

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}

void main() {
// Test Login widgets

  testWidgets('Testing login widgets', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(LoginScreen()));
    await tester.pumpAndSettle();

    final titleFinder = find.text('AeroGrow');
    final subtitleFinder = find.text('Messaging App');

    expect(titleFinder, findsOneWidget);
    expect(subtitleFinder, findsOneWidget);

    var mailFormField = find.byKey(Key("emailField"));
    expect(mailFormField, findsWidgets);
    await tester.enterText(mailFormField, "bastien.cantiteau@epitech.eu");
    expect(find.text("bastien.cantiteau@epitech.eu"), findsOneWidget);

    var pswdFormField = find.byKey(Key("passwordField"));
    expect(pswdFormField, findsWidgets);
    await tester.enterText(pswdFormField, "Bastien23");
    expect(find.text("Bastien23"), findsOneWidget);

    var signupButton = find.byKey(Key("signupBtn"));
    expect(signupButton, findsOneWidget);

    var loginButton = find.byKey(Key("loginBtn"));
    expect(loginButton, findsOneWidget);
  });

// Test Register widgets

  testWidgets('Testing register widgets', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(RegisterScreen()));
    await tester.pumpAndSettle();

    var mailFormField = find.byKey(Key("emailField"));
    expect(mailFormField, findsWidgets);
    await tester.enterText(mailFormField, "bastien.cantiteau@epitech.eu");
    expect(find.text("bastien.cantiteau@epitech.eu"), findsOneWidget);

    var pswdFormField = find.byKey(Key("passwordField"));
    expect(pswdFormField, findsWidgets);
    await tester.enterText(pswdFormField, "Bastien23");
    expect(find.text("Bastien23"), findsOneWidget);

    var firstFormField = find.byKey(Key("firstNameField"));
    expect(firstFormField, findsWidgets);
    await tester.enterText(firstFormField, "Bastien");
    expect(find.text("Bastien"), findsOneWidget);

    var lastFormField = find.byKey(Key("lastNameField"));
    expect(lastFormField, findsWidgets);
    await tester.enterText(lastFormField, "Cantiteau");
    expect(find.text("Cantiteau"), findsOneWidget);

    var signupButton = find.byKey(Key("signupBtn"));
    expect(signupButton, findsOneWidget);
  });

// Test profile view widgets

  testWidgets('Testing profile widgets', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(ProfileScreen()));
    await tester.pumpAndSettle();

    final emailFinder = find.text('Email: ');
    expect(emailFinder, findsOneWidget);

    //var changePhotoButton = find.byKey(Key("changePhotoBtn"));
    //expect(changePhotoButton, findsOneWidget);

    //var changeUsernameButton = find.byKey(Key("changeUsernameBtn"));
    //expect(changeUsernameButton, findsOneWidget);

    //var signoutButton = find.byKey(Key("signoutButton"));
    //expect(signoutButton, findsOneWidget);
  });
}
