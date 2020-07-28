import 'package:flutter/material.dart';
import 'package:loans/providers/session/loggin_provider.dart';
import 'package:loans/providers/session/session_provider.dart';
import 'package:loans/providers/session/signup_provider.dart';
import 'package:loans/screens/signup_screen/signup_form.dart';
import 'package:loans/utils/internationalization/app_localizations.dart';
import 'package:loans/utils/modals/custom_modals.dart';
import 'package:loans/utils/modals/info_modals.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  signupHandler(context) {
    var signupProvider = Provider.of<SignupProvider>(context, listen: false);
    if (signupProvider.allValid) {
      Provider.of<SessionProvider>(context, listen: false)
          .signUp(signupProvider.user);
    } else {
      Provider.of<SignupProvider>(context, listen: false).showErrors();
    }
  }

  head(context) {
    return Container(
        child: Center(
      child: Text(
        AppLocalizations.of(context).translate('createAccount'),
        style: TextStyle(
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[200]),
      ),
    ));
  }

  createAccountButton(context) {
    return Container(
      height: 40,
      width: 300,
      child: RaisedButton(
          onPressed: () {
            signupHandler(context);
          },
          elevation: 5,
          color: Colors.green,
          textColor: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate('createAccount'),
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Icon(
                Icons.person_add,
              ),
            ],
          )),
    );
  }

  backToLoginButton(context) {
    return MaterialButton(
      onPressed: () {
        Provider.of<SignupProvider>(context, listen: false).clear();
        Provider.of<LoginProvider>(context, listen: false).clear();
        Navigator.pushNamed(context, '/');
      },
      child: Text(
        AppLocalizations.of(context).translate('goToLogin'),
        style: TextStyle(
          fontSize: 14,
          color: Colors.blueGrey[600],
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  termsAndConditionButton(context) {
    return MaterialButton(
      onPressed: () {
        showTermAndCondition(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('termsConditions'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: Colors.blue[400],
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }

  content(context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        head(context),
        Container(
          height: 20,
        ),
        SignupForm(),
        Container(
          height: 40,
        ),
        createAccountButton(context),
        backToLoginButton(context),
        termsAndConditionButton(context)
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SessionProvider>(context);
    Future.delayed(Duration.zero, () {
      return provider.state == SessionState.ERROR_SIGNUP
          ? showSessionModal(context, provider.errorMessage, '/signup')
          : provider.state == SessionState.USER_CREATED
              ? showSessionModal(
                  context,
                  'Se ha creado la cuenta exitosamente. Debes iniciar session para continuar.',
                  '/')
              : null;
    });
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blueGrey[100],
                  Colors.white,
                  Colors.blueGrey[100],
                ]),
          ),
          child: Center(
              child: SingleChildScrollView(
            // child: loginForm(context),
            child: Stack(
              children: <Widget>[
                Opacity(
                  opacity: provider.state == SessionState.PROCCESSING ||
                          provider.state == SessionState.ERROR_SIGNUP
                      ? 0.5
                      : 1,
                  child: AbsorbPointer(
                    absorbing: provider.state == SessionState.PROCCESSING,
                    child: content(context),
                  ),
                ),
                Opacity(
                  opacity: provider.state == SessionState.PROCCESSING ? 1.0 : 0,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(100),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
            ),
          ))),
    );
  }
}
