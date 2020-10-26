import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/models/conversation_models.dart';
import 'package:flutter_instant_messenger/models/user.dart';
import 'package:flutter_instant_messenger/services/conversation_service.dart';
import 'package:flutter_instant_messenger/services/user_service.dart';
import 'package:flutter_instant_messenger/widgets/image_preview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class ConversationScreen extends StatefulWidget {
  final Map data;

  ConversationScreen(this.data);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  Conversation _conversation;
  UserModel _userModel;
  ScrollController _scrollController = new ScrollController();

  TextEditingController _textEditingController = new TextEditingController();
  UserState _userService;
  ConversationState _convService;
  ImagePicker _imagePicker = new ImagePicker();

  @override
  void initState() {
    _conversation = widget.data['conversation'];
    _userModel = widget.data['userModel'];
    _userService = Provider.of<UserState>(context, listen: false);
    _convService = Provider.of<ConversationState>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  EdgeInsets _getCardPadding(String sender) {
    var padding = MediaQuery.of(context).size.width * 0.10;

    return sender == _userService.currentUser().uid
        ? EdgeInsets.fromLTRB(padding, 0, 5, 0)
        : EdgeInsets.fromLTRB(5, 0, padding, 0);
  }

  Color _getCardColor(String sender) =>
      sender == _userService.currentUser().uid ? Color(0xFFA3F7BF) : Color(0xFFCFD7E4);

  Future<dynamic> _retrieveLostImageData() async {
    final LostData response = await _imagePicker.getLostData();
    if (response.isEmpty) {
      return null;
    }
    if (response.file != null) {
      return response.file;
    } else {
      return response.exception.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF6EE),
      appBar: AppBar(
        backgroundColor: Color(0xFFA3F7BF),
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(_userModel.fullName, style: kBlackTextStyle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Consumer<ConversationState>(
              builder: (context, state, child) => Expanded(
                child: StreamBuilder(
                  stream: state.getMessagesForConversation(_conversation.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.hasError) return Center(child: CircularProgressIndicator());
                    var conv = (snapshot.data as Conversation);
                    return ListView.builder(
                      reverse: true,
                      scrollDirection: Axis.vertical,
                      controller: _scrollController,
                      itemCount: conv.messageList.length,
                      itemBuilder: (context, index) {
                        var msg = conv.messageList[index];
                        switch (msg.type) {
                          case MessageType.TEXT:
                            return Container(
                              child: Padding(
                                padding: _getCardPadding(msg.sender),
                                child: Card(
                                  color: _getCardColor(msg.sender),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              msg.content,
                                              style: kConversationMessage,
                                            ),
                                            Text(
                                              DateFormat('d MMM - H:mm').format(msg.datetime.toLocal()),
                                              style: kConversationDate,
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          case MessageType.IMAGE:
                            return FutureBuilder(
                              future: _convService.getImageUrl(msg.content),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container(
                                    child: Padding(
                                      padding: _getCardPadding(msg.sender),
                                      child: Card(
                                        color: _getCardColor(msg.sender),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Container(
                                  child: Padding(
                                    padding: _getCardPadding(msg.sender),
                                    child: Card(
                                      color: _getCardColor(msg.sender),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                Image.network(snapshot.data),
                                                Text(
                                                  DateFormat('d MMM - H:mm').format(msg.datetime.toLocal()),
                                                  style: kConversationDate,
                                                  textAlign: TextAlign.right,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          default:
                            return Container(
                              child: Padding(
                                padding: _getCardPadding(msg.sender),
                                child: Card(
                                  color: _getCardColor(msg.sender),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              'Message type not handled',
                                              style: kConversationMessage,
                                            ),
                                            Text(
                                              DateFormat('d MMM - H:mm').format(msg.datetime.toLocal()),
                                              style: kConversationDate,
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              child: Row(
                children: [
                  RaisedButton(
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      PickedFile pickedFile = await _imagePicker.getImage(source: ImageSource.camera);
                      if (pickedFile != null) {
                        showMaterialModalBottomSheet(
                            expand: false,
                            context: context,
                            backgroundColor: Colors.white,
                            builder: (context, scrollController) =>
                                ImagePreview(conversation: _conversation, pickedFile: pickedFile));
                      } else {
                        var lostData = await _retrieveLostImageData();
                        if (lostData is PickedFile) {
                          showMaterialModalBottomSheet(
                              expand: false,
                              context: context,
                              backgroundColor: Colors.white,
                              builder: (context, scrollController) =>
                                  ImagePreview(conversation: _conversation, pickedFile: lostData));
                        }
                      }
                    },
                    child: Icon(Icons.photo_camera),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      PickedFile pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        showMaterialModalBottomSheet(
                            expand: false,
                            context: context,
                            backgroundColor: Colors.white,
                            builder: (context, scrollController) =>
                                ImagePreview(conversation: _conversation, pickedFile: pickedFile));
                      } else {
                        var lostData = await _retrieveLostImageData();
                        if (lostData is PickedFile) {
                          showMaterialModalBottomSheet(
                              expand: false,
                              context: context,
                              backgroundColor: Colors.white,
                              builder: (context, scrollController) =>
                                  ImagePreview(conversation: _conversation, pickedFile: lostData));
                        }
                      }
                    },
                    child: Icon(Icons.photo),
                  ),
                  Expanded(
                    child: TextField(
                      autocorrect: true,
                      maxLines: 5,
                      minLines: 1,
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        hintText: 'Enter message',
                      ),
                      textInputAction: TextInputAction.send,
                      onEditingComplete: () {
                        if (_textEditingController.text.isEmpty) return;
                        _convService.sendTextMessageToConversation(_conversation.id, _textEditingController.text);
                        _textEditingController.clear();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
