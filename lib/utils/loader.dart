import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/constants.dart';

void showAlertDialog(BuildContext context) {
  WillPopScope alert = WillPopScope(
    onWillPop: () async => false,
    child: AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text("Loading", style: kTextStyle),
          )
        ],
      ),
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return alert;
    },
  );
}
