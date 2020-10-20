import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_instant_messenger/models/conversation_models.dart';

class ConversationState with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  String _userUid = '';

  set userUid(String uid) => _userUid = uid;

  Stream<History> getHistory() {
    return _firestore
        .collection('conversations')
        .where('participants', arrayContains: _userUid)
        .snapshots()
        .map((data) => History.fromSnapshot(data));
  }

  Stream<Conversation> getMessagesForConversation(String conversationId) {
    return _firestore.collection('conversations').doc(conversationId).snapshots().map((data) {
      Conversation conversation = Conversation.fromSnapshot(data);
      conversation.messageList.sort((message1, message2) => message1.datetime.compareTo(message2.datetime));
      return conversation;
    });
  }

  Future<bool> sendMessageToConversation(String conversationId, Message message) async {
    try {
      DocumentReference conversationRef = _firestore.collection('conversations').doc(conversationId);
      conversationRef.update({
        "messages": FieldValue.arrayUnion([message])
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
