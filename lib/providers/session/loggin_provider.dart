import 'package:flutter/widgets.dart';

class LoginProvider with ChangeNotifier {
  final RegExp _validationEmail =
      RegExp(r'^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$');
  final RegExp _validationPassword = RegExp(r'^([1-zA-Z0-1@.\s]{1,255})$');

  String _email = '';
  String _password = '';
  bool _visibility = false;
  bool _validEmail;
  bool _validPassword;

  String get email => _email;

  String get password => _password;

  bool get emailValid => _validEmail;

  bool get passwordValid => _validPassword;

  bool get allValid {
    return _validEmail != null &&
        _validPassword != null &&
        _validPassword &&
        _validEmail;
  }

  bool get visibility => _visibility;

  togleVisibility() {
    _visibility = !_visibility;
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

  void showErrors() {
    _validEmail = _validEmail ?? false;
    _validPassword = _validPassword ?? false;
    notifyListeners();
  }

  clear() {
    _email = '';
    _password = '';
    _validEmail = null;
    _validPassword = null;
    notifyListeners();
  }

  _valid({String text, RegExp reg, int min = 0, int max = 20}) {
    if (text != null) {
      if (reg.hasMatch(text) && (text.length >= min && text.length <= max)) {
        return true;
      }
    }
    return false;
  }
}
