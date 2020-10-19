import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/screens/home.dart';
import 'package:flutter_instant_messenger/screens/login.dart';
import 'package:flutter_instant_messenger/services/login_service.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => LoginState())],
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
          return Error();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return App();
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(),
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
            var state = Provider.of<LoginState>(context);
            state.trackUserState();

            if (state.isLoggedIn())
              return HomeScreen();
            else
              return LoginScreen();
          }
        });
  }
}
