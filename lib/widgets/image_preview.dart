import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePreview extends StatelessWidget {
  final PickedFile pickedFile;
  final Function onPressedAction;

  ImagePreview({Key key, @required this.pickedFile, @required this.onPressedAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Image.file(File(pickedFile.path)),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
                  child: Container(
                    color: Colors.black26,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      iconSize: 35.0,
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                  child: Container(
                    color: Colors.black26,
                    child: IconButton(
                      onPressed: () {
                        onPressedAction();

                        Navigator.of(context).pop();
                      },
                      iconSize: 35.0,
                      icon: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
