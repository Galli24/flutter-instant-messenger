/*
**  Objects that will be filled with conversations data
*/

import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  TEXT,
  IMAGE,
  LOCATION,
}

class Message {
  final String _sender;
  final DateTime _time;
  final MessageType _type;
  final String _content;

  String get sender => _sender;
  DateTime get datetime => _time;
  MessageType get type => _type;
  String get content => _content;

  @override
  String toString() =>
      "{\"sender\": \"" +
      _sender +
      "\", \"time\": " +
      _time.toLocal().toString() +
      ", \"type\": \"" +
      _type.toString() +
      "\", \"content\": \"" +
      _content +
      "\"}";

  Message(String sender, MessageType type, String content)
      : _sender = sender,
        _time = DateTime.now(),
        _type = type,
        _content = content;

  Message.fromMap(Map<dynamic, dynamic> data)
      : _sender = data['sender'],
        _time = (data['time'] as Timestamp).toDate(),
        _type = MessageType.values[data['type']],
        _content = data['content'];

  Map<String, dynamic> toMap() =>
      {'content': _content, 'sender': _sender, 'time': Timestamp.fromDate(_time), 'type': _type.index};
}

class Conversation {
  final String _id;
  final List<String> _participants;
  final List<Message> _messages;

  String get id => _id;
  List<String> get participants => _participants;
  List<Message> get messageList => _messages;

  @override
  String toString() {
    String result = 'id: ' + _id + '\nparticipants: ' + _participants.toString() + '\nmessages: ';
    for (Message message in messageList) result += '\n' + message.toString();
    return result;
  }

  Conversation.fromSnapshot(DocumentSnapshot snapshot)
      : _id = snapshot.id,
        _participants = List.from(snapshot['participants']),
        _messages = new List<Message>() {
    for (Map<dynamic, dynamic> message in snapshot['messages'] as List<dynamic>) {
      _messages.add(Message.fromMap(message));
    }
    _messages.sort((message1, message2) => message2.datetime.compareTo(message1.datetime));
  }
}

class History {
  final List<Conversation> _conversations;
  List<Conversation> get conversationList => _conversations;

  History() : _conversations = new List<Conversation>();

  @override
  String toString() {
    String result = 'big dick data ';
    for (Conversation conversation in _conversations) result += '\n' + conversation.toString();
    return result;
  }

  History.fromSnapshot(QuerySnapshot snapshot) : _conversations = new List<Conversation>() {
    for (QueryDocumentSnapshot documentSnapshot in snapshot.docs) {
      Conversation conv = Conversation.fromSnapshot(documentSnapshot);
      if (conv.messageList.isNotEmpty) _conversations.add(conv);
    }
    _conversations.sort((conversation1, conversation2) =>
        conversation2.messageList.last.datetime.compareTo(conversation1.messageList.last.datetime));
  }
}
