import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/services/user_service.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _mail;
  String _password;
  String _firstName;
  String _lastName;

  String _registerResult = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          child: Column(
            children: [
              TextField(
                onChanged: (text) {
                  setState(() {
                    _mail = text;
                  });
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    //floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Enter your e-mail",
                    labelText: 'Mail'),
              ),
              TextField(
                onChanged: (text) {
                  setState(() {
                    _password = text;
                  });
                },
                obscureText: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    //floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Enter your password",
                    labelText: 'Password'),
              ),
              TextField(
                onChanged: (text) {
                  setState(() {
                    _firstName = text;
                  });
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    //floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Enter your first name",
                    labelText: 'First name'),
              ),
              TextField(
                onChanged: (text) {
                  setState(() {
                    _lastName = text;
                  });
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    //floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Enter your last name",
                    labelText: 'Last name'),
              ),
              Text(
                _registerResult,
                style: kErrorTextStyle,
              ),
              FlatButton(
                color: Color(0xFFA3F7B7),
                textColor: Color(0xFF393E46),
                onPressed: () async {
                  var _state = Provider.of<UserState>(context, listen: false);
                  if (_mail.isNotEmpty && _password.isNotEmpty && _firstName.isNotEmpty && _lastName.isNotEmpty) {
                    var tmp = await _state.registerWithEmailAndPassword(_mail, _password, _firstName, _lastName);
                    setState(() {
                      _registerResult = tmp;
                    });
                    if (_state.isLoggedIn()) Navigator.pushNamed(context, '/');
                  }
                },
                child: Text('Register'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
