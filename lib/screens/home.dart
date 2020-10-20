import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/constants.dart';
import 'package:flutter_instant_messenger/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'

import '../constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _signOut() {
    Provider.of<UserState>(context, listen: false).signOut(context);
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF6EE),
      body: SafeArea(
        child: Column(
          children: [
            FlatButton(
              onPressed: _signOut,
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
