import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/services/conversation_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImagePreview extends StatelessWidget {
  final PickedFile pickedFile;

  ImagePreview({Key key, @required this.pickedFile}) : super(key: key);

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
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  iconSize: 35.0,
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Provider.of<ConversationState>(context, listen: false).sendImageMessageToConversation(pickedFile);
                    Navigator.of(context).pop();
                  },
                  iconSize: 35.0,
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
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
