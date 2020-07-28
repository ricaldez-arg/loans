import 'package:firebase_auth/firebase_auth.dart';
import 'package:loans/models/user.dart';

abstract class BaseAuth {
  Future<FirebaseUser> signIn(String email, String password);

  Future<String> signUp(User user);

  Future<void> signOut();

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<bool> isEmailVerified();

}
