import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_instant_messenger/models/conversation_models.dart';

class ConversationState with ChangeNotifier {
  String _userUid = '';

  set userUid(String uid) => _userUid = uid;

  Future<History> getHistory() async {
    QuerySnapshot userConversations = await FirebaseFirestore.instance
        .collection('conversations')
        .where('participants', arrayContains: _userUid)
        .get();

    // DEBUG
    History history = History.fromSnapshot(userConversations);
    for (Conversation conv in history.conversationList) {
      print(conv);
    }
    // END DEBUG

    return History.fromSnapshot(userConversations);
  }
}
