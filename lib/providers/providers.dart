import 'package:loans/providers/debt/new_debt_provider.dart';
import 'package:loans/providers/session/loggin_provider.dart';
import 'package:loans/providers/session/session_provider.dart';
import 'package:loans/providers/session/signup_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/single_child_widget.dart';

getProviders(FirebaseApp app) {
  List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => SessionProvider(app)),
    ChangeNotifierProvider(create: (_) => LoginProvider()),
    ChangeNotifierProvider(create: (_) => SignupProvider()),
    ChangeNotifierProvider(create: (_) => NewDebtProvider(app)),
  ];
  return providers;
}
