import 'package:flutter_instant_messenger/screens/conversation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_instant_messenger/screens/login.dart';
import 'package:flutter_instant_messenger/screens/register.dart';
import 'package:flutter_instant_messenger/screens/profile.dart';

void main() {
  /*
    Login tests
  */

  test('empty login email return error', () {
    var result = LoginEmailFieldValidator.validate('');
    expect(result, 'Email can\'t be empty');
  });

  test('filled login email returns null', () {
    var result = LoginEmailFieldValidator.validate('email@email.com');
    expect(result, null);
  });

  test('empty login password return error', () {
    var result = LoginPasswordFieldValidator.validate('');
    expect(result, 'Password can\'t be empty');
  });

  test('filled login password returns null', () {
    var result = LoginPasswordFieldValidator.validate('password');
    expect(result, null);
  });

  /*
    Register tests
  */

  test('empty register email return error', () {
    var result = RegisterEmailFieldValidator.validate('');
    expect(result, 'Email can\'t be empty');
  });

  test('filled register email returns null', () {
    var result = RegisterEmailFieldValidator.validate('email@email.com');
    expect(result, null);
  });

  test('empty register password return error', () {
    var result = RegisterPasswordFieldValidator.validate('');
    expect(result, 'Password can\'t be empty');
  });

  test('filled register password returns null', () {
    var result = RegisterPasswordFieldValidator.validate('password');
    expect(result, null);
  });

  test('empty register first name return error', () {
    var result = RegisterFirstNameFieldValidator.validate('');
    expect(result, 'First name can\'t be empty');
  });

  test('filled register first name returns null', () {
    var result = RegisterFirstNameFieldValidator.validate('Roger');
    expect(result, null);
  });

  test('empty register last name return error', () {
    var result = RegisterLastNameFieldValidator.validate('');
    expect(result, 'Last name can\'t be empty');
  });

  test('filled register last name returns null', () {
    var result = RegisterLastNameFieldValidator.validate('Federer');
    expect(result, null);
  });

  /*
    Message field test
  */

  test('empty message return error', () {
    var result = MessageFieldValidator.validate('');
    expect(result, 'Message can\'t be empty');
  });

  test('filled message returns null', () {
    var result = MessageFieldValidator.validate('Federer');
    expect(result, null);
  });

  /*
    Edit Username test
  */

  test('empty message return error', () {
    var result = UsernameFieldValidator.validate('');
    expect(result, 'Username can\'t be empty');
  });

  test('filled message returns null', () {
    var result = UsernameFieldValidator.validate('Jacki33');
    expect(result, null);
  });
}
