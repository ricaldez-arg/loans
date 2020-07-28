import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:loans/models/user.dart';
import 'package:loans/services/session_service/base_auth.dart';
import 'package:loans/services/session_service/enums.dart';

class SessionService implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<FirebaseUser> signIn(String email, String password) async {
      try {
        AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
        return result.user;
      } on PlatformException catch (e) {
        if(Platform.isAndroid) {
          AuthError error = AuthError.unknowError;
          switch (e.code) {
            case 'ERROR_INVALID_EMAIL':
              error = AuthError.invalidEmail;
              break;
            case 'ERROR_WRONG_PASSWORD':
              error = AuthError.wrongPassword;
              break;
            case 'ERROR_USER_NOT_FOUND':
              error = AuthError.userNotFound;
              break;
            case 'ERROR_USER_DISABLED':
              error = AuthError.userDisabled;
              break;
            case 'ERROR_TOO_MANY_REQUESTS':
              error = AuthError.tooManyRequests;
              break;
            case 'ERROR_OPERATION_NOT_ALLOWED':
              error = AuthError.operationNotAllowed;
              break;
            default:
              error = AuthError.unknowError;
          }
          return Future.error(error);
        }
      }
  }

  Future<String> signUp(User newUser) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
                          email: newUser.email, password: newUser.password);
      return result.user.uid;

    } on PlatformException catch (e) {
      if (Platform.isAndroid) {
        AuthError error = AuthError.unknowError;
        switch (e.code) {
          case 'ERROR_WEAK_PASSWORD':
            error = AuthError.weakPassword;
            break;
          case 'ERROR_INVALID_EMAIL':
            error = AuthError.invalidEmail;
            break;
          case 'ERROR_EMAIL_ALREADY_IN_USE':
            error = AuthError.emailAlreadyInUse;
            break;
          default:
            error = AuthError.unknowError;
        }
        return Future.error(error);
      }
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    try {
      FirebaseUser user = await _firebaseAuth.currentUser();
      return user;
    } catch (error) {
      print(error);
    }
    return null;
    
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}
