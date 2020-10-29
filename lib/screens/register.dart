import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/services/user_service.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

/*
  Testing classes
*/
class RegisterEmailFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Email can\'t be empty' : null;
  }
}

class RegisterPasswordFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Password can\'t be empty' : null;
  }
}

class RegisterFirstNameFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'First name can\'t be empty' : null;
  }
}

class RegisterLastNameFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Last name can\'t be empty' : null;
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _email;
  String _password;
  String _firstName;
  String _lastName;
  String _registerResult;

  @override
  void initState() {
    super.initState();
    _email = '';
    _password = '';
    _firstName = '';
    _lastName = '';
    _registerResult = '';
  }

  void _register() async {
    var _state = Provider.of<UserState>(context, listen: false);
    if (_email.isNotEmpty && _password.isNotEmpty && _firstName.isNotEmpty && _lastName.isNotEmpty) {
      var tmp = await _state.registerWithEmailAndPassword(context, _email, _password, _firstName, _lastName);
      if (mounted) {
        setState(() {
          _registerResult = tmp;
        });
      }
      if (_state.isLoggedIn()) Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color(0xFFA3F7B7),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text('Register', style: kBlackTextStyle),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  TextFormField(
                    onChanged: (text) => setState(() => _email = text),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        //floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: "Enter your e-mail",
                        labelText: 'Email'),
                    validator: RegisterEmailFieldValidator.validate,
                    textInputAction: TextInputAction.next,
                  ),
                  TextFormField(
                    onChanged: (text) => setState(() => _password = text),
                    obscureText: true,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        //floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: "Enter your password",
                        labelText: 'Password'),
                    validator: RegisterPasswordFieldValidator.validate,
                    textInputAction: TextInputAction.next,
                  ),
                  TextFormField(
                    onChanged: (text) => setState(() => _firstName = text),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        //floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: "Enter your first name",
                        labelText: 'First name'),
                    validator: RegisterFirstNameFieldValidator.validate,
                    textInputAction: TextInputAction.next,
                  ),
                  TextFormField(
                    onChanged: (text) => setState(() => _lastName = text),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        //floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: "Enter your last name",
                        labelText: 'Last name'),
                    validator: RegisterLastNameFieldValidator.validate,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _register(),
                  ),
                  Text(
                    _registerResult,
                    style: kErrorTextStyle,
                  ),
                  FlatButton(
                      onPressed: _register,
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0xFFA3F7B7), Color(0xFF29A19C)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter),
                            borderRadius: BorderRadius.circular(30)),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 200, minHeight: 60),
                          alignment: Alignment.center,
                          child: Text(
                            "Register",
                            style: TextStyle(
                              fontFamily: "SourceSansPro",
                              fontSize: 28,
                              color: Color(0xFFEFF6EE),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
