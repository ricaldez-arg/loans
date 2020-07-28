import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:loans/models/user.dart';
import 'package:loans/services/session_service/enums.dart';
import 'package:loans/services/session_service/session_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:loans/services/user_service/user_service.dart';

enum SessionState {
  UNDEFINED,
  LOGGED,
  UNLOGGED,
  PROCCESSING,
  USER_CREATED,
  ERROR_LOGGIN,
  ERROR_SIGNUP,
}

class SessionProvider with ChangeNotifier {
  SessionState _state = SessionState.UNDEFINED;
  User _user;
  SessionService _service = SessionService();
  UserService _userService;
  String _errorMessage = '';
  FirebaseApp _app;

  SessionProvider(FirebaseApp app) {
    _app = app;
    _userService = UserService(app);
  }

  FirebaseApp get app => _app;

  SessionState get state => _state;

  User get user => _user;

  String get errorMessage => _errorMessage;

  set state(SessionState state) {
    _state = state;
    notifyListeners();
  }

  Future<void> signOut() async {
    _state = SessionState.PROCCESSING;
    notifyListeners();
    await _service.signOut();
    _user = null;
    _state = SessionState.UNLOGGED;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    _state = SessionState.PROCCESSING;
    notifyListeners();
    // await Future.delayed(const Duration(seconds: 2), (){});
    await _service.signIn(email, password).then((FirebaseUser user) {
      _user = User(
          id: user.uid,
          email: user.email,
          name: user.displayName,
          verified: user.isEmailVerified);
      _state = SessionState.LOGGED;
    }).catchError((error) {
      print("Error in session provider");
      _handleError(error);
      _state = SessionState.ERROR_LOGGIN;
    });
    notifyListeners();
  }

  Future<void> signUp(User user) async {
    _state = SessionState.PROCCESSING;
    notifyListeners();
    await _service.signUp(user).then((userId) {
      user.id = userId;
      print('usuario creado exitosamente con uid:' + userId);
      return _userService.createUser(user);
    }).then((resolve) {
      _state = SessionState.USER_CREATED;
      print('usuario creado exitosamente en ls DB');
    }).catchError((error) {
      print('algun error en sesion provider');
      _state = SessionState.ERROR_SIGNUP;
      _handleError(error);
    });
    notifyListeners();
  }

  _handleError(dynamic error) {
    switch (error) {
      case AuthError.userNotFound:
        _errorMessage =
            '''No se ha podido encontrar el usuario con el correo proporcionado. Verifique los datos e intentelo otra vez''';
        break;
      case AuthError.wrongPassword:
        _errorMessage = 'La contrasenia introducida es incorrecta.';
        break;
      case AuthError.emailAlreadyInUse:
        _errorMessage =
            'El correo introducido ya esta en uso. Intente con otro.';
        break;
      default:
        _errorMessage =
            'Ocurrio un error inesperado. Verifique que el dispositivo este conectado a internet.';
    }
  }
}
