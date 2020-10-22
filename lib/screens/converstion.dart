import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/models/user.dart';
import 'package:flutter_instant_messenger/services/conversation_service.dart';
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
        child: Text('Test'),
      ),
    );
  }
}
