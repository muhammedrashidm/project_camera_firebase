import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../models/user_modal.dart';

class AuthService extends ChangeNotifier{
  bool _isLoading =false;
  bool get isLoading => _isLoading;
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  User? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return User(user.uid, user.email);
  }

  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    setIsLoading(true);
    final credential;
    try {
      credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      setIsLoading(false);
      return _userFromFirebase(credential.user);

    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setIsLoading(false);
        return null;
      } else if (e.code == 'wrong-password') {
        setIsLoading(false);
        return null;
      }
    } catch (e) {
      print(e);
    }
  }
  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    setIsLoading(true);
    final credential;
    try {
      credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      setIsLoading(false);
      return _userFromFirebase(credential.user);
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setIsLoading(false);
        return null;
      } else if (e.code == 'wrong-password') {
        setIsLoading(false);
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  void setIsLoading(bool status){
    _isLoading =status;
    notifyListeners();
  }
}
