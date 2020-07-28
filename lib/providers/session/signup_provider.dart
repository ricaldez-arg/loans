import 'package:flutter/widgets.dart';
import 'package:loans/models/enums.dart';
import 'package:loans/models/user.dart';

class SignupProvider with ChangeNotifier {
  final RegExp _validationEmail =
      RegExp(r'^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$');
  final RegExp _validationPassword = RegExp(r'^([1-zA-Z0-1@.\s]{1,255})$');
  final RegExp _onlyLetters = RegExp(r'[A-Za-z]');

  String _email = '';
  String _password = '';
  String _name = '';
  String _gender;
  bool _validName;
  bool _validEmail;
  bool _validPassword;
  bool _validGender;
  bool _visibility = false;

  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get gender => _gender;

  bool get validName => _validName;
  bool get validEmail => _validEmail;
  bool get validPassword => _validPassword;
  bool get validGender => _validGender;

  bool get allValid {
    return (_validName ?? false) &&
        (_validEmail ?? false) &&
        (_validPassword ?? false) &&
        (_validGender ?? false);
  }

  User get user {
    return User(
        name: _name, email: _email, password: _password, gender: _genderType());
  }

  bool get visibility => _visibility;

  togleVisibility() {
    _visibility = !_visibility;
    notifyListeners();
  }

  changeName(String name) {
    _name = name;
    _validName = _valid(text: name, reg: _onlyLetters, min: 2, max: 20);
    notifyListeners();
  }

  changeEmail(String email) {
    _email = email;
    _validEmail = _valid(text: email, reg: _validationEmail, min: 6, max: 50);
    notifyListeners();
  }

  changePassword(String password) {
    _password = password;
    _validPassword =
        _valid(text: password, reg: _validationPassword, min: 8, max: 20);
    notifyListeners();
  }

  changeGender(String gender) {
    _gender = gender;
    _validGender = gender.length > 0;
    notifyListeners();
  }

  showErrors() {
    _validName = _validName ?? false;
    _validEmail = _validEmail ?? false;
    _validPassword = _validPassword ?? false;
    _validGender = _validGender ?? false;
    notifyListeners();
  }

  clear() {
    _email = '';
    _password = '';
    _name = '';
    _gender = null;
    _validName = null;
    _validEmail = null;
    _validPassword = null;
    _validGender = null;
    // notifyListeners();
  }

  _valid({String text, RegExp reg, int min = 0, int max = 20}) {
    if (text != null) {
      if (reg.hasMatch(text) && (text.length >= min && text.length <= max)) {
        return true;
      }
    }
    return false;
  }

  _genderType() {
    switch (_gender) {
      case 'Masculino':
        return Gender.male;
      case 'Femenino':
        return Gender.female;
      default:
        return Gender.other;
    }
  }
}
