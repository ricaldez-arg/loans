import 'package:flutter/material.dart';
import 'package:loans/providers/session/loggin_provider.dart';
import 'package:loans/utils/internationalization/app_localizations.dart';
import 'package:provider/provider.dart';

class SigninForm extends StatelessWidget {
  emailPasswordFields(context) {
    final i18n = AppLocalizations.of(context);
    var loginProvider = Provider.of<LoginProvider>(context);
    var loginProviderNL = Provider.of<LoginProvider>(context, listen: false);
    return Container(
      width: 300,
      child: Form(
        child: Column(
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              maxLength: 50,
              decoration: InputDecoration(
                errorText:
                    loginProvider.emailValid == null || loginProvider.emailValid
                        ? null
                        : i18n.translate('emailErrorMessage'),
                hintText: i18n.translate('emailExample'),
                labelText: i18n.translate('email'),
                icon: Icon(Icons.email, size: 32.0, color: Colors.blueGrey),
              ),
              initialValue: loginProvider.email,
              onChanged: (text) {
                loginProviderNL.changeEmail(text);
              },
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              maxLength: 20,
              decoration: InputDecoration(
                  errorText: loginProvider.passwordValid == null ||
                          loginProvider.passwordValid
                      ? null
                      : i18n.translate('passwordErrorMessage'),
                  hintText: i18n.translate('passwordExample'),
                  labelText: i18n.translate('password'),
                  icon: Icon(Icons.lock, size: 32.0, color: Colors.blueGrey),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      loginProviderNL.togleVisibility();
                    },
                    child: Icon(!loginProvider.visibility
                        ? Icons.visibility
                        : Icons.visibility_off),
                  )),
              obscureText: !loginProvider.visibility,
              validator: (value) =>
                  value.isEmpty ? 'Password can\'t be empty' : null,
              initialValue: loginProvider.password,
              onChanged: (text) {
                loginProviderNL.changePassword(text);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return emailPasswordFields(context);
  }
}
