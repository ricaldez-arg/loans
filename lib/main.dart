import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loans/providers/providers.dart';
import 'package:loans/providers/session/loggin_provider.dart';
import 'package:loans/providers/session/session_provider.dart';
import 'package:loans/providers/session/signup_provider.dart';
import 'package:loans/router.dart';
import 'package:loans/screens/debt/new_debt/new_debt_screen.dart';
import 'package:loans/screens/home_screen/home.dart';
import 'package:loans/screens/signin_screen/signin_screen.dart';
import 'package:loans/screens/signup_screen/signup_screen.dart';
import 'package:loans/utils/constants.dart';
import 'package:loans/utils/internationalization/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db2',
    // options: Platform.isIOS
    //     ? const FirebaseOptions(
    //         googleAppID: '1:297855924061:ios:c6de2b69b03a5be8',
    //         gcmSenderID: '297855924061',
    //         databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
    //       )
    //     : const FirebaseOptions(
    //         googleAppID: '1:297855924061:android:669871c998cc21bd',
    //         apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
    //         databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
    //       ),
    options: const FirebaseOptions(
      googleAppID: '1:669069041561:android:82138c8f0566c79b4b3d08',
      apiKey: 'v8K7zlOTuMy1dveur17tyKdbT7UOfLQv5sob0v2O',
      databaseURL: "https://loans-566de.firebaseio.com",
    ),
  );
  runApp(MultiProvider(
    providers: getProviders(app),
    child: Router(),
  ));
}
