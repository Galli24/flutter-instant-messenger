import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_instant_messenger/models/conversation_models.dart';
import 'package:flutter_instant_messenger/models/user.dart';
import 'package:flutter_instant_messenger/services/conversation_service.dart';
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

  @override
  void initState() {
    _conversationUid = widget.data['conversationUid'];
    _userModel = widget.data['userModel'];
    super.initState();
  }

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
                    if (!snapshot.hasData || snapshot.hasError)
                       return Center(child: CircularProgressIndicator());
                    var conv = (snapshot.data as Conversation);
                    return ListView.builder(
                      reverse: true,
                      scrollDirection: Axis.vertical,
                      controller: _scrollController,
                      itemCount: conv.messageList.length,
                      itemBuilder: (context, index) => Container(
                        child: Card(
                          color: Color(0xFF393E46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                conv.messageList[index].content,
                                                style: TextStyle(
                                                  fontFamily: "SourceSansPro",
                                                  fontSize: 24,
                                                  color: Color(0xFFEFF6EE),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: Text(
                                                  DateFormat('H:mm').format(conv.messageList[index].datetime.toLocal()),
                                                  style: TextStyle(
                                                    fontFamily: "SourceSansPro",
                                                    fontSize: 16,
                                                    color: Color(0xFFEFF6EE),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                      decoration: InputDecoration(
                        hintText: 'Enter message',
                      ),
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
