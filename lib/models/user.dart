class UserModel {
  final String _id;
  final String _firstName;
  final String _lastName;
  String profileImageUrl;

  String get id => _id;
  String get lastName => _lastName;
  String get fullName => _firstName + ' ' + _lastName;
  @override
  String toString() =>
      "{\"id\": \"" +
      _id +
      "\", \"firstName\": \"" +
      _firstName +
      "\", \"lastName\": " +
      _lastName +
      "\", \"profileImageUrl\": " +
      profileImageUrl +
      "\"}";

  UserModel.fromDocument(document)
      : _id = document.id,
        _firstName = document['firstName'],
        _lastName = document['lastName'],
        profileImageUrl = document['profileImageUrl'];
}
