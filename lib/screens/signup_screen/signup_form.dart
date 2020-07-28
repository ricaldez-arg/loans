import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loans/models/enums.dart';
import 'package:loans/providers/session/signup_provider.dart';
import 'package:loans/utils/internationalization/app_localizations.dart';
import 'package:provider/provider.dart';

class SignupForm extends StatelessWidget {
  nameField(context) {
    final i18n = AppLocalizations.of(context);
    var nameValid = Provider.of<SignupProvider>(context).validName;
    return TextFormField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      decoration: InputDecoration(
        errorText: nameValid == null || nameValid
            ? null
            : i18n.translate('nameErrorMessage'),
        hintText: i18n.translate('nameExample'),
        labelText: i18n.translate('name'),
        icon: Icon(Icons.account_circle, size: 32.0, color: Colors.blueGrey),
      ),
      onChanged: (text) {
        Provider.of<SignupProvider>(context, listen: false).changeName(text);
      },
    );
  }

  emailField(context) {
    final i18n = AppLocalizations.of(context);
    var validEmail = Provider.of<SignupProvider>(context).validEmail;
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      maxLength: 50,
      decoration: InputDecoration(
        errorText: validEmail == null || validEmail
            ? null
            : i18n.translate('emailErrorMessage'),
        hintText: i18n.translate('emailExample'),
        labelText: i18n.translate('email'),
        icon: Icon(Icons.email, size: 32.0, color: Colors.blueGrey),
      ),
      onChanged: (text) {
        Provider.of<SignupProvider>(context, listen: false).changeEmail(text);
      },
    );
  }

  passwordField(context) {
    final i18n = AppLocalizations.of(context);
    var signupProvider = Provider.of<SignupProvider>(context);
    return TextFormField(
      keyboardType: TextInputType.text,
      maxLength: 20,
      decoration: InputDecoration(
        errorText:
            signupProvider.validPassword == null || signupProvider.validPassword
                ? null
                : i18n.translate('passwordErrorMessage'),
        hintText: i18n.translate('passwordExample'),
        labelText: i18n.translate('password'),
        icon: Icon(Icons.lock, size: 32.0, color: Colors.blueGrey),
        suffixIcon: GestureDetector(
          onTap: () {
            Provider.of<SignupProvider>(context, listen: false)
                .togleVisibility();
          },
          child: Icon(!signupProvider.visibility
              ? Icons.visibility
              : Icons.visibility_off),
        ),
      ),
      obscureText: !signupProvider.visibility,
      onChanged: (text) {
        Provider.of<SignupProvider>(context, listen: false)
            .changePassword(text);
      },
    );
  }

  genderField(context) {
    final i18n = AppLocalizations.of(context);
    return Row(
      children: <Widget>[
        Icon(Icons.edit, size: 32.0, color: Colors.blueGrey),
        Container(
          width: 15,
        ),
        Container(
          width: 253,
          child: DropdownButton<String>(
            items: Gender.values.map((Gender value) {
              return DropdownMenuItem<String>(
                value: describeEnum(value),
                child: Text(i18n.translate('${describeEnum(value)}')),
              );
            }).toList(),
            onChanged: (value) {
              Provider.of<SignupProvider>(context, listen: false)
                  .changeGender(value);
            },
            value: Provider.of<SignupProvider>(context).gender,
            hint: Text(
              i18n.translate('gender'),
              style: TextStyle(
                color: Colors.blueGrey,
              ),
            ),
            isExpanded: true,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: Form(
        child: Column(
          children: <Widget>[
            nameField(context),
            emailField(context),
            passwordField(context),
            genderField(context),
          ],
        ),
      ),
    );
  }
}
