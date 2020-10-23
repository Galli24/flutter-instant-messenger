import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/widgets/topbar.dart';
import 'package:flutter_instant_messenger/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_instant_messenger/constants.dart';

import '../constants.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFEFF6EE),
      appBar: TopBar(context),
      body: SafeArea(
        child: Center(
            child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(
                          "https://cdn3.f-cdn.com/contestentries/1376995/30494909/5b566bc71d308_thumb900.jpg"),
                      backgroundColor: Colors.transparent,
                    ),
                    Expanded(
                      child: FloatingActionButton(
                        onPressed: null,
                        heroTag: "ChangePhoto",
                        child: Icon(Icons.photo_camera, color: Color(0xFFEFF6EE)),
                        backgroundColor: Color(0xFFA3F7BF),
                        mini: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Text(
                      "Peepoo Do",
                      style: kBlackTitleTextStyle,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: FloatingActionButton(
                        onPressed: null,
                        heroTag: "EditName",
                        child: Icon(Icons.edit, color: Colors.black),
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.transparent,
                        elevation: 0,
                        splashColor: Color(0xFFA3F7BF),
                        mini: true,
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.black.withOpacity(0.3)),
                SizedBox(height: 15),
                Text(
                  "Email: ",
                  style: kBlackTitleTextStyle,
                ),
                SizedBox(height: 5),
                Text(
                  "bastien.cantiteau@gmail.com",
                  style: kBlackTextStyle,
                ),
                SizedBox(height: 15),
                Text(
                  "Change password: ",
                  style: kBlackTitleTextStyle,
                ),
                TextField(
                  onChanged: null,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      //floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: "Enter your password",
                      labelText: 'Old password'),
                  textInputAction: TextInputAction.done,
                  onSubmitted: null,
                ),
                TextField(
                  onChanged: null,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      //floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: "Enter your password",
                      labelText: 'New password'),
                  textInputAction: TextInputAction.done,
                  onSubmitted: null,
                ),
                SizedBox(height: 30),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200, minHeight: 60),
                  child: Ink(
                    width: 200,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFFA3F7B7), Color(0xFF29A19C)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: InkWell(
                      onTap: () => Provider.of<UserState>(context, listen: false).signOut(context),
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Sign Out",
                          style: TextStyle(
                            fontFamily: "SourceSansPro",
                            fontSize: 32,
                            color: Color(0xFFEFF6EE),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
