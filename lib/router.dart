import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loans/providers/session/session_provider.dart';
import 'package:loans/screens/debt/new_debt/new_debt_screen.dart';
import 'package:loans/screens/home_screen/home.dart';
import 'package:loans/screens/signin_screen/signin_screen.dart';
import 'package:loans/screens/signup_screen/signup_screen.dart';
import 'package:loans/utils/constants.dart';
import 'package:loans/utils/internationalization/app_localizations.dart';
import 'package:provider/provider.dart';

class Router extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loans',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: initialRoute,
      routes: {
        initialRoute: (context) =>
            Provider.of<SessionProvider>(context).state != SessionState.LOGGED
                ? SigninScreen()
                : Home(),
        signUpRoute: (context) => SignupScreen(),
        newDebtRoute: (context) => NewDebtScreen(),
      },
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('es'),
      ],
    );
  }
}
