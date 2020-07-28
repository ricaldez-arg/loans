import 'package:loans/models/enums.dart';

class User {
  String id;
  String email;
  String password;
  String name;
  Gender gender;
  bool verified;

  User(
      {this.id,
      this.email,
      this.password,
      this.gender,
      this.name = '',
      this.verified = false});

  toJson() {
    return {
      'name': name,
      'email': email,
      'gender': gender.toString().split('.')[1][0],
      'verified': verified ?? false,
    };
  }
}
