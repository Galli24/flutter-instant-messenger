import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_instant_messenger/models/conversation_models.dart';
import 'package:flutter_instant_messenger/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ConversationState with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  String _userUid = '';
  History _history = History();
  StreamSubscription<History> _historyTracking;

  set userUid(String uid) => _userUid = uid;
  History get history => _history;

  void trackMessageHistory() {
    if (_historyTracking == null) {
      _historyTracking = _getHistory().listen((data) {
        _history = data;
        notifyListeners();
      });
    }
  }

  void stopTrackingMessageHistory() {
    if (_historyTracking != null) _historyTracking.cancel();
  }

  Future<UserModel> getParticipant(Conversation conversation) async {
    String uidToSearch =
        conversation.participants[0] == _userUid ? conversation.participants[1] : conversation.participants[0];
    return UserModel.fromDocument(await _firestore.collection('users').doc(uidToSearch).get());
  }

  Stream<History> _getHistory() {
    return _firestore
        .collection('conversations')
        .where('participants', arrayContains: _userUid)
        .snapshots()
        .map((data) => History.fromSnapshot(data));
  }

  Stream<Conversation> getMessagesForConversation(String conversationId) {
    return _firestore.collection('conversations').doc(conversationId).snapshots().map((data) {
      Conversation conversation = Conversation.fromSnapshot(data);
      return conversation;
    });
  }

  Future<String> startConversation(String participantUid, Message message) async {
    try {
      CollectionReference convColRef = _firestore.collection('conversations');
      DocumentReference convRef = await convColRef.add({
        "messages": FieldValue.arrayUnion([message]),
        "participants": List.from([
          _userUid,
          participantUid,
        ]),
      });
      return convRef.id;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  Future<bool> sendTextMessageToConversation(String conversationId, String text) async {
    try {
      Message message = new Message(_userUid, MessageType.TEXT, text);
      DocumentReference conversationRef = _firestore.collection('conversations').doc(conversationId);
      conversationRef.update({
        'messages': FieldValue.arrayUnion([message.toMap()])
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> sendImageMessageToConversation(Conversation conversation, PickedFile pickedFile) async {
    try {
      String fileExt = pickedFile.path.substring(pickedFile.path.lastIndexOf('.') + 1);
      String ref = '/images/conversations/' + conversation.participants.join('-') + '/' + Uuid().v4() + '.' + fileExt;
      await _storage.ref(ref).putFile(File(pickedFile.path));
      Message message = new Message(_userUid, MessageType.IMAGE, ref);
      DocumentReference conversationRef = _firestore.collection('conversations').doc(conversation.id);
      conversationRef.update({
        'messages': FieldValue.arrayUnion([message.toMap()])
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<String> getImageUrl(String ref) async {
    try {
      return await _storage.ref(ref).getDownloadURL();
    } catch (e) {
      print(e.toString());
      return '';
    }
  }
}
