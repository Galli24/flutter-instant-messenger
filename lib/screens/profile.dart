import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_instant_messenger/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../constants.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFEFF6EE),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color(0xFFA3F7BF),
        centerTitle: true,
        elevation: 1.0,
        title: SizedBox(height: 35.0, child: Image.asset("assets/images/topbar_title.png")),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
          ),
        ],
      ),
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
                    CachedNetworkImage(
                      imageUrl:
                          "https://firebasestorage.googleapis.com/v0/b/flutter-instant-messenger.appspot.com/o/images%2Fconversations%2F4bYmJMhu4FPK0pdrBS3UM6P98HJ2-qgbUPIK59rPInfDTQKKIykwC3ih2%2Fd4f0ed68-3e88-4580-abe9-9c95d8367d81.jpg?alt=media&token=2392bafe-e5e0-4d5f-864c-424fbe5233ae",
                      imageBuilder: (context, imageProvider) => Container(
                        width: 200.0,
                        height: 200.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
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
                      "Profile Name",
                      style: kBlackTitleTextStyle,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: FloatingActionButton(
                        onPressed: () {
                          showMaterialModalBottomSheet(
                            expand: true,
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (context, scrollController) => TextField(
                              obscureText: false,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  hintText: "Enter your profile name",
                                  labelText: 'Profile name'),
                              textInputAction: TextInputAction.done,
                            ),
                          );
                        },
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
                SizedBox(height: 35),
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
                SizedBox(height: 80),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 280, minHeight: 80),
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
