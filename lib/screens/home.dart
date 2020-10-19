import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/constants.dart';

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
        child: Text("TODO", style: kTextStyle),
      ),
    );
  }
}
