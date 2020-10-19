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
  String _loginErrorMessage;

  @override
  void initState() {
    super.initState();
    _email = '';
    _password = '';
    _loginErrorMessage = '';
  }

  void _signIn() async {
    var _state = Provider.of<UserState>(context, listen: false);
    if (_email.isNotEmpty && _password.isNotEmpty) {
      var tmp = await _state.signInWithEmailAndPassword(context, _email, _password);
      if (mounted) {
        setState(() {
          _loginErrorMessage = tmp;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF6EE),
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            SizedBox(height: 80),
            Column(
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
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
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
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      FocusScope.of(context).unfocus();
                      _signIn();
                    }),
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
                  onPressed: _signIn,
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
          ],
        ),
      ),
    );
  }
}
