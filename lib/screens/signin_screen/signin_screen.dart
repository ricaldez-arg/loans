import 'package:flutter/material.dart';
import 'package:loans/providers/session/loggin_provider.dart';
import 'package:loans/providers/session/session_provider.dart';
import 'package:loans/screens/signin_screen/signin_form.dart';
import 'package:loans/utils/custom_toast.dart';
import 'package:loans/utils/internationalization/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SigninScreen extends StatelessWidget {
  loginHandler(context) {
    var logginProvider = Provider.of<LoginProvider>(context, listen: false);
    if (logginProvider.allValid) {
      Provider.of<SessionProvider>(context, listen: false)
          .signIn(logginProvider.email, logginProvider.password);
    } else {
      Provider.of<LoginProvider>(context, listen: false).showErrors();
    }
  }

  head(context) {
    return Container(
        child: Center(
      child: Text(
        AppLocalizations.of(context).translate('welcome'),
        style: TextStyle(
            fontSize: 48.0,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[200]),
      ),
    ));
  }

  loginbutton(context) {
    bool allValid = Provider.of<LoginProvider>(context).allValid;
    Color buttonColor = allValid ? Colors.blueGrey[600] : Colors.blueGrey[400];

    return Container(
      width: 300,
      child: RaisedButton(
          onPressed: () {
            loginHandler(context);
          },
          elevation: 5,
          color: Colors.green,
          textColor: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate('login'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Icon(
                Icons.forward,
              ),
            ],
          )),
    );
  }

  createAccountButton(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(AppLocalizations.of(context).translate('noAccount')),
        MaterialButton(
          onPressed: () {
            Provider.of<LoginProvider>(context, listen: false).clear();
            Navigator.pushNamed(context, '/signup');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate('signup'),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blue[400],
                    decoration: TextDecoration.underline),
              ),
            ],
          ),
        )
      ],
    );
  }

  forgotPassword(context) {
    return MaterialButton(
      onPressed: () {},
      child: Text(
        'Olvide mi password',
        style: TextStyle(
          fontSize: 13,
          color: Colors.blueGrey[800],
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  loginForm(context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        head(context),
        Container(
          height: 20,
        ),
        SigninForm(),
        Container(height: 40),
        loginbutton(context),
        // forgotPassword(context),
        Container(
          height: 12,
        ),
        createAccountButton(context),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final flutterToast = FlutterToast(context);
    var provider = Provider.of<SessionProvider>(context);
    if (provider.state == SessionState.ERROR_LOGGIN) {
      Future.delayed(Duration.zero, () {
        flutterToast.showToast(
          child: CustomToast(provider.errorMessage),
          toastDuration: Duration(seconds: 4),
        );
        Provider.of<SessionProvider>(context, listen: false).state =
            SessionState.UNLOGGED;
      });
    }

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
            child: Stack(
              children: <Widget>[
                Opacity(
                  opacity: provider.state == SessionState.PROCCESSING ? 0.5 : 1,
                  child: AbsorbPointer(
                    absorbing: provider.state == SessionState.PROCCESSING,
                    child: loginForm(context),
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

  // Future<void> _showDialog(context, message) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Algo salio mal'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Divider(color: Colors.blueGrey,),
  //               Text(message),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           Padding(
  //             padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
  //             child: FlatButton(
  //               child: Text('Aceptar'),
  //               onPressed: () {
  //                 Provider.of<SessionProvider>(context, listen: false).state = SessionState.UNLOGGED;
  //                 // Navigator.of(context).pop();
  //                 Navigator.pushNamed(context, '/');
  //               },
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

}
