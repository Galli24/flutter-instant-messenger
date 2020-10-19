import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

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

  Future<String> registerWithEmailAndPassword(String email, String password, String firstName, String lastName) async {
    try {
      final User user = (await _auth.createUserWithEmailAndPassword(email: email, password: password)).user;
      if (user != null) {
        CollectionReference users = FirebaseFirestore.instance.collection('users');

        try {
          await users.doc(user.uid).set({
            'firstName': firstName,
            'lastName': lastName,
          });
        } catch (e) {
          return "Failed to add user: $e";
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        return 'The email is invalid.';
      }
    } catch (e) {
      return e;
    }
    return '';
  }

  Future<String> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        return 'Wrong email or password';
      }
    } catch (e) {
      return e;
    }
    return '';
  }

  void signOut() async {
    await _auth.signOut();
    _isLoggedIn = false;
    notifyListeners();
  }
}
