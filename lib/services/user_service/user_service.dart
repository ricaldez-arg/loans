import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:loans/models/user.dart';


class UserService {

  DatabaseReference _userRef;

  UserService(FirebaseApp app) {
    _userRef = FirebaseDatabase.instance.reference().child('users');
  }

  Future<void> createUser(User user) {
    return _userRef.child(user.id).set(user.toJson());
  }

}
