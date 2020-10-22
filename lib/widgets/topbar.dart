import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_instant_messenger/screens/profile.dart';

class TopBar extends AppBar {
  TopBar(BuildContext context)
      : super(
          backgroundColor: Color(0xFFA3F7BF),
          centerTitle: true,
          elevation: 1.0,
          title: SizedBox(height: 35.0, child: Image.asset("assets/images/topbar_title.png")),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
            ),
            IconButton(
                icon: Icon(Icons.account_circle_rounded),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                }),
            IconButton(
                icon: Icon(Icons.power_settings_new, color: Colors.green),
                onPressed: () => Provider.of<UserState>(context, listen: false).signOut(context)),
          ],
        );
}
