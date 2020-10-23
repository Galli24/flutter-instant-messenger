import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/models/conversation_models.dart';
import 'package:flutter_instant_messenger/models/user.dart';
import 'package:flutter_instant_messenger/services/conversation_service.dart';
import 'package:flutter_instant_messenger/services/user_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class ConversationScreen extends StatefulWidget {
  final Map data;

  ConversationScreen(this.data);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String _conversationUid;
  UserModel _userModel;
  ScrollController _scrollController = new ScrollController();

  String _text;
  TextEditingController _textEditingController = new TextEditingController();
  UserState _userService;

  @override
  void initState() {
    _conversationUid = widget.data['conversationUid'];
    _userModel = widget.data['userModel'];
    _text = '';
    _userService = Provider.of<UserState>(context, listen: false);
    super.initState();
  }

  EdgeInsets getCardPadding(String sender) {
    var padding = MediaQuery.of(context).size.width * 0.10;

    return sender == _userService.currentUser().uid
        ? EdgeInsets.fromLTRB(padding, 0, 5, 0)
        : EdgeInsets.fromLTRB(5, 0, padding, 0);
  }

  Color getCardColor(String sender) => sender == _userService.currentUser().uid ? Color(0xFFA3F7BF) : Color(0xFFCFD7E4);

  @override
  Widget build(BuildContext context) {
    var convService = Provider.of<ConversationState>(context, listen: false);
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
                  stream: state.getMessagesForConversation(_conversationUid),
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
                        return Container(
                          child: Padding(
                            padding: getCardPadding(msg.sender),
                            child: Card(
                              color: getCardColor(msg.sender),
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
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autocorrect: true,
                      maxLines: null,
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        hintText: 'Enter message',
                      ),
                      onChanged: (text) {
                        setState(() {
                          _text = text;
                        });
                      },
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) {
                        convService.sendTextMessageToConversation(_conversationUid, _text);
                        _text = '';
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
