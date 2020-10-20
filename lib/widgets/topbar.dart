import 'package:flutter/material.dart';

class TopBar extends AppBar {
  TopBar()
      : super(
          backgroundColor: Color(0xFFA3F7BF),
          centerTitle: true,
          elevation: 1.0,
          title: SizedBox(height: 35.0, child: Image.asset("assets/images/topbar_title.png")),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
            ),
            IconButton(icon: Icon(Icons.account_circle_rounded), onPressed: null)
          ],
        );
}
