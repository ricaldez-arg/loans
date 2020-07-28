import 'package:flutter/material.dart';
import 'package:loans/providers/debt/new_debt_provider.dart';
import 'package:loans/screens/debt/new_debt/amount_interest.dart';
import 'package:loans/screens/debt/new_debt/head_options.dart';
import 'package:loans/screens/debt/new_debt/period_section.dart';
import 'package:loans/utils/internationalization/app_localizations.dart';
import 'package:provider/provider.dart';

class NewDebtScreen extends StatelessWidget {
  appBarSection(context) {
    final i18n = AppLocalizations.of(context);
    final provider = Provider.of<NewDebtProvider>(context, listen: false);
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            provider.clear();
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          i18n.translate('newDebt'),
          style: TextStyle(fontSize: 18),
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              provider.save(context);
            },
            child: Text(i18n.translate('save')),
          )
        ],
      ),
    );
  }

  reason(context) {
    final i18n = AppLocalizations.of(context);
    return TextFormField(
      maxLines: 2,
      decoration: InputDecoration(
        labelText: i18n.translate('debtReason'),
        hintText: i18n.translate('debtReasonHint'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(),
        ),
      ),
    );
  }

  withPadding(context, child, [double top = 10]) {
    return Padding(
      padding: EdgeInsets.only(top: top, bottom: 10),
      child: child is Function ? child(context) : child,
    );
  }

  validateName(context, String text) {
    if (text == null) {
      return null;
    }
    if (text.isEmpty) {
      return AppLocalizations.of(context).translate('fieldEmptyError');
    }
    if (text.length < 2) {
      return AppLocalizations.of(context).translate('invalidValue');
    }
    return null;
  }

  formSection(context) {
    final i18n = AppLocalizations.of(context);
    return Form(
      child: Column(
        children: <Widget>[
          HeadOptions(),
          withPadding(
              context,
              TextFormField(
                initialValue: Provider.of<NewDebtProvider>(context).name,
                decoration: InputDecoration(
                  labelText: i18n.translate('personName'),
                  errorText: validateName(
                      context, Provider.of<NewDebtProvider>(context).name),
                ),
                onChanged: (text) {
                  Provider.of<NewDebtProvider>(context, listen: false)
                      .changeName(text);
                },
              ),
              0),
          withPadding(context, AmountInterest()),
          withPadding(context, reason),
          withPadding(
            context,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                i18n.translate('paymentPeriod'),
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),
          withPadding(context, PeriodicPaymentSection(), 0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final newDebtProviderNL =
        Provider.of<NewDebtProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        return Future(() {
          newDebtProviderNL.clear();
          return true;
        });
      },
      child: Scaffold(
          appBar: appBarSection(context),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: formSection(context),
            ),
          )),
    );
  }
}
