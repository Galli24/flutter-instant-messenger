import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/services/user_service.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class LoginEmailFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Email can\'t be empty' : null;
  }
}

class LoginPasswordFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Password can\'t be empty' : null;
  }
}

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
    _loginErrorMessage = '';
    var _state = Provider.of<UserState>(context, listen: false);
    if (_email.isNotEmpty && _password.isNotEmpty) {
      var tmp = await _state.signInWithEmailAndPassword(context, _email, _password);

      if (mounted) setState(() => _loginErrorMessage = tmp);
      if (_state.isLoggedIn()) Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFEFF6EE),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 90,
                  backgroundImage: AssetImage('assets/images/aerogrow_logo.jpg'),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(height: 10),
                Text(
                  "AeroGrow",
                  style: TextStyle(fontFamily: "SourceSansPro", fontSize: 52),
                ),
                Text(
                  "Messaging App",
                  style: TextStyle(fontFamily: "SourceSansProItalic", fontSize: 18),
                ),
                SizedBox(height: 20),
                TextFormField(
                  key: Key("emailField"),
                  onChanged: (text) => setState(() => _email = text),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      //floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: "Enter your email",
                      labelText: "Email"),
                  validator: LoginEmailFieldValidator.validate,
                  textInputAction: TextInputAction.next,
                ),
                //SizedBox(height: 20),
                TextFormField(
                  key: Key("passwordField"),
                  onChanged: (text) => setState(() => _password = text),
                  obscureText: true,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      //floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: "Enter your password",
                      labelText: 'Password'),
                  textInputAction: TextInputAction.done,
                  validator: LoginPasswordFieldValidator.validate,
                  onFieldSubmitted: (_) => _signIn(),
                ),
                SizedBox(height: 20),
                TextButton(
                  key: Key("signupBtn"),
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: Text("Sign Up", style: TextStyle(color: Color(0xFF29A19C))),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200, minHeight: 60),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFFA3F7B7), Color(0xFF29A19C)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: InkWell(
                      key: Key("loginBtn"),
                      onTap: _signIn,
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            fontFamily: "SourceSansPro",
                            fontSize: 32,
                            color: Color(0xFFEFF6EE),
                          ),
                        ),
                      ),
                    ),
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
