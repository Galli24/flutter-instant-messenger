import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/constants.dart';
import 'package:flutter_instant_messenger/screens/home.dart';
import 'package:flutter_instant_messenger/screens/login.dart';
import 'package:flutter_instant_messenger/screens/register.dart';
import 'package:flutter_instant_messenger/services/user_service.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserState())],
      child: FirebaseInit(),
    ),
  );
}

class FirebaseInit extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            color: Color(0xFFEFF6EE),
            child: Center(
              child: SizedBox(
                child: Text(
                  "An error occured: ${snapshot.error}",
                  style: kTextStyle.copyWith(
                    color: Colors.red,
                  ),
                  textDirection: TextDirection.ltr,
                ),
                height: 200,
                width: 200,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return App();
        }

        return Container(
          color: Color(0xFFEFF6EE),
          child: Center(
            child: SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 10,
              ),
              height: 200,
              width: 200,
            ),
          ),
        );
      },
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Instant Messaging',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          canvasColor: Colors.transparent),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) {
          var state = Provider.of<UserState>(context);
          state.trackUserState();

          if (state.isLoggedIn())
            return HomeScreen();
          else
            return LoginScreen();
        },
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
