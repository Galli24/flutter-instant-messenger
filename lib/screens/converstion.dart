
import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/models/user.dart';
import 'package:flutter_instant_messenger/services/conversation_service.dart';
import 'package:provider/provider.dart';

class ConversationScreen extends StatefulWidget {

  final String conversationUuid;
  final UserModel userModel;

  ConversationScreen(this.conversationUuid, this.userModel);


  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var convService = Provider.of<ConversationState>(context, listen: false);

    return SafeArea(
      child: Container(
        color: Colors.red[200],
      ),
    );
  }
}
