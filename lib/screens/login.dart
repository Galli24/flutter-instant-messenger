import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/services/user_service.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email;
  String _password;
  String _loginErrorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF6EE),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/aerogrow_logo.jpg'),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (text) {
                setState(() {
                  _email = text;
                });
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  //floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: "Enter your email",
                  labelText: "Email"),
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 50),
            FlatButton(
              color: Colors.transparent,
              textColor: Color(0xFF29A19C),
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text(
                "Sign Up",
              ),
            ),
            FlatButton(
              color: Color(0xFFA3F7B7),
              textColor: Color(0xFF393E46),
              onPressed: () async {
                var _state = Provider.of<UserState>(context, listen: false);
                if (_email.isNotEmpty && _password.isNotEmpty) {
                  var tmp = await _state.signInWithEmailAndPassword(_email, _password);
                  setState(() {
                    _loginErrorMessage = tmp;
                  });
                  if (_state.isLoggedIn()) Navigator.pushNamed(context, '/');
                }
              },
              child: Text(
                "Sign In",
              ),
            ),
            Text(
              _loginErrorMessage,
              style: kErrorTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
