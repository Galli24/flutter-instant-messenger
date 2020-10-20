/*
**  Objects that will be filled with conversations data
*/

class Message {
  String senderId;
  DateTime time;
  String msgContent;

  DateTime get datetime => time;

  String get sender => senderId;

  String get content => msgContent;
}

class Conversation {
  List<String> participants;
  List<Message> messages;

  List<String> get participant => participants;

  List<Message> get messageList => messages;
}

class History {
  String userId;
  List<Conversation> conversations;

  String get user => userId;

  List<Conversation> get conversationList => conversations;
}
