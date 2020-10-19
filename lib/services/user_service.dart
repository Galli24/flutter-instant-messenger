import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_instant_messenger/utils/loader.dart';

class UserState with ChangeNotifier {
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

  Future<String> registerWithEmailAndPassword(
      BuildContext context, String email, String password, String firstName, String lastName) async {
    String result = '';

    try {
      Loader.showAlertDialog(context);
      final User user = (await _auth.createUserWithEmailAndPassword(email: email, password: password)).user;
      if (user != null) {
        CollectionReference users = FirebaseFirestore.instance.collection('users');

        try {
          await users.doc(user.uid).set({
            'firstName': firstName,
            'lastName': lastName,
          });
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        } catch (e) {
          result = 'Failed to add user: $e';
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        result = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        result = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        result = 'The email is invalid.';
      }
    } on Exception catch (e) {
      result = e.toString();
    }
    Navigator.pop(context);
    return result;
  }

  Future<String> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    String result = '';

    try {
      Loader.showAlertDialog(context);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-email') {
        result = 'Wrong email or password';
      }
    } on Exception catch (e) {
      result = e.toString();
    }
    Navigator.pop(context);
    return result;
  }

  void signOut(BuildContext context) async {
    Loader.showAlertDialog(context);
    await _auth.signOut();
    _isLoggedIn = false;
    notifyListeners();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
