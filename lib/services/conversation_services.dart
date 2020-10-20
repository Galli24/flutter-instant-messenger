/*
**  Objects that will be filled with conversations data
*/

class Message {
  int receiverId;
  int senderId;
  String msgContent;

  int get receiver => receiverId;

  int get sender => senderId;

  String get content => msgContent;
}

class Conversation {
  int firstPerson;
  int secondPerson;
  List<Message> messages;

  int get first => firstPerson;

  int get second => secondPerson;

  List<Message> get messageList => messages;
}

class History {
  int userId;
  List<Conversation> conversations;

  int get user => userId;

  List<Conversation> get conversationList => conversations;
}
