import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class LoginState with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _user;
  bool _isLoggedIn = false;

  bool isLoggedIn() => _isLoggedIn;
  User currentUser() => _user;

  void trackUserState() {
    _auth.authStateChanges().listen((User user) {
      if (user == null) {
        _isLoggedIn = false;
        notifyListeners();
      } else {
        _user = user;
        _isLoggedIn = true;
        notifyListeners();
      }
    });
  }

  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }
  }

  void signOut() async {
    await _auth.signOut();
    _isLoggedIn = false;
    notifyListeners();
  }
}
