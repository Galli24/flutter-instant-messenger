import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/constants.dart';
import 'package:flutter_instant_messenger/services/user_service.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF6EE),
      body: SafeArea(
        child: Column(
          children: [
            FlatButton(
              onPressed: () async {
                Provider.of<UserState>(context, listen: false).signOut();
                Navigator.pushNamed(context, '/');
              },
              child: Text(
                'Log out',
                style: kTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
