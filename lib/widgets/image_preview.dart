import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/services/conversation_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImagePreview extends StatelessWidget {
  final String conversationId;
  final PickedFile pickedFile;

  ImagePreview({Key key, @required this.conversationId, @required this.pickedFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.white,
              child: SizedBox(
                width: 200,
                height: 200,
                child: Image.file(File(pickedFile.path)),
              ),
            ),
            ListTile(
                title: Text('Send'),
                onTap: () {
                  Provider.of<ConversationState>(context, listen: false).sendImageMessageToConversation(conversationId, pickedFile);
                  Navigator.of(context).pop();
                }),
            ListTile(
              title: Text('Cancel'),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
