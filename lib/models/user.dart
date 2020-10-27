class UserModel {
  final String _id;
  final String _firstName;
  final String _lastName;
  final String _profileImageUrl;

  String get id => _id;
  String get lastName => _lastName;
  String get fullName => _firstName + ' ' + _lastName;
  String get profileImageUrl => _profileImageUrl;

  @override
  String toString() =>
      "{\"id\": \"" +
      _id +
      "\", \"firstName\": \"" +
      _firstName +
      "\", \"lastName\": " +
      _lastName +
      "\", \"profileImageUrl\": " +
      _profileImageUrl +
      "\"}";

  UserModel.fromDocument(document)
      : _id = document.id,
        _firstName = document['firstName'],
        _lastName = document['lastName'],
        _profileImageUrl = document['profileImageUrl'];
}
