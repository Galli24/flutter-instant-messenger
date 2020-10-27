import 'dart:async';
import 'dart:io';

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
  String _participantUid = '';
  Conversation currentConversation;

  History _history = History();
  StreamSubscription<History> _historyTracking;

  set userUid(String uid) => _userUid = uid;
  set participantUid(String uid) => _participantUid = uid;
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
    if (_historyTracking != null) {
      _historyTracking.cancel();
      _historyTracking = null;
      _history = History();
    }
  }

  Future<List<UserModel>> getContacts() async {
    List<UserModel> _contacts = new List<UserModel>();
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    for (DocumentSnapshot doc in snapshot.docs) if (doc.id != _userUid) _contacts.add(UserModel.fromDocument(doc));
    return _contacts;
  }

  Future<Conversation> getConversationWithUser(String otherUserId) async {
    var conversationsDocs =
        (await _firestore.collection('conversations').where('participants', arrayContains: _userUid).get()).docs;

    for (var snapshot in conversationsDocs)
      if (List.from(snapshot['participants']).contains(otherUserId)) return Conversation.fromSnapshot(snapshot);
    return null;
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

  Future<bool> startConversation() async {
    try {
      if (_participantUid.isEmpty) return false;

      CollectionReference convColRef = _firestore.collection('conversations');
      DocumentReference convRef = await convColRef.add({
        'messages': List.from([]),
        'participants': List.from([
          _userUid,
          _participantUid,
        ]),
      });
      currentConversation = Conversation.fromSnapshot(await convRef.get());
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> sendTextMessageToConversation(String text) async {
    try {
      if (currentConversation == null) if (!await startConversation()) return false;

      Message message = new Message(_userUid, MessageType.TEXT, text);
      DocumentReference conversationRef = _firestore.collection('conversations').doc(currentConversation.id);
      conversationRef.update({
        'messages': FieldValue.arrayUnion([message.toMap()])
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> sendImageMessageToConversation(PickedFile pickedFile) async {
    try {
      if (currentConversation == null) if (!await startConversation()) return false;

      String fileExt = pickedFile.path.substring(pickedFile.path.lastIndexOf('.') + 1);
      Reference ref = _storage.ref(
          '/images/conversations/' + currentConversation.participants.join('-') + '/' + Uuid().v4() + '.' + fileExt);
      await ref.putFile(File(pickedFile.path));
      String url = await ref.getDownloadURL();

      Message message = new Message(_userUid, MessageType.IMAGE, url);
      DocumentReference conversationRef = _firestore.collection('conversations').doc(currentConversation.id);
      conversationRef.update({
        'messages': FieldValue.arrayUnion([message.toMap()])
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
