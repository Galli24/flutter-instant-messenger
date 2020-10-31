import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/services/user_service.dart';
import 'package:flutter_instant_messenger/widgets/image_preview.dart';
import 'package:provider/provider.dart';
import 'package:flutter_instant_messenger/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../constants.dart';

class UsernameFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Username can\'t be empty' : null;
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final picker = ImagePicker();
  UserState userService;

  bool _nameEditing = false;

  @override
  void initState() {
    userService = Provider.of<UserState>(context, listen: false);
    super.initState();
  }

  Future<dynamic> _retrieveLostImageData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return null;
    }
    if (response.file != null) {
      return response.file;
    } else {
      return response.exception.code;
    }
  }

  void _getImage(Function onPressedAction) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      showMaterialModalBottomSheet(
        expand: false,
        context: context,
        backgroundColor: Colors.white,
        builder: (context, scrollController) => ImagePreview(
          pickedFile: pickedFile,
          onPressedAction: () => onPressedAction(pickedFile),
        ),
      );
    } else {
      if (Platform.isAndroid) {
        var lostData = await _retrieveLostImageData();
        if (lostData is PickedFile) {
          showMaterialModalBottomSheet(
            expand: false,
            context: context,
            backgroundColor: Colors.white,
            builder: (context, scrollController) => ImagePreview(
              pickedFile: lostData,
              onPressedAction: () => onPressedAction(pickedFile),
            ),
          );
        }
      }
    }
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
        child: Consumer<UserInfo>(
          builder: (context, state, child) {
            return Center(
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
                          state.currentUserInfo().profileImageUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: state.currentUserInfo().profileImageUrl,
                                  imageBuilder: (context, imageProvider) => Container(
                                    width: 200.0,
                                    height: 200.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                    ),
                                  ),
                                  placeholder: (context, url) => Icon(
                                    Icons.account_circle_rounded,
                                    size: 200,
                                    color: Color(0xFF29A19C),
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.account_circle_rounded,
                                    size: 200,
                                    color: Color(0xFF29A19C),
                                  ),
                                )
                              : Icon(
                                  Icons.account_circle_rounded,
                                  size: 200,
                                  color: Color(0xFF29A19C),
                                ),
                          Expanded(
                            key: Key("changePhotoBtn"),
                            child: FloatingActionButton(
                              onPressed: () => _getImage(state.uploadProfileImage),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 48),
                          !_nameEditing
                              ? Expanded(
                                  child: Text(
                                    state.currentUserInfo().fullName,
                                    textAlign: TextAlign.center,
                                    style: kBlackTitleTextStyle,
                                  ),
                                )
                              : Expanded(
                                  child: TextFormField(
                                    autofocus: true,
                                    style: kBlackTitleTextStyle,
                                    onFieldSubmitted: (text) => setState(() {
                                      state.updateUserName(text);
                                      _nameEditing = false;
                                    }),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: state.currentUserInfo().fullName,
                                    ),
                                    validator: UsernameFieldValidator.validate,
                                    textInputAction: TextInputAction.done,
                                  ),
                                ),
                          FloatingActionButton(
                            key: Key("changeUsernameBtn"),
                            onPressed: () => setState(() => _nameEditing = true),
                            heroTag: "EditName",
                            child: Icon(Icons.edit, color: Colors.black),
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.transparent,
                            elevation: 0,
                            splashColor: Color(0xFFA3F7BF),
                            mini: true,
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
                        userService.currentUser().email,
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
                            key: Key("signoutBtn"),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
