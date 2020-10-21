class UserModel {
  final String _firstName;
  final String _lastName;

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get fullName => _firstName + ' ' + _lastName;

  UserModel.fromDocument(document)
      : _firstName = document['firstName'],
        _lastName = document['lastName'];
}
