import 'package:flutter/material.dart';
import 'package:loans/models/enums.dart';
import 'package:loans/providers/debt/new_debt_provider.dart';
import 'package:loans/screens/util_functions.dart';
import 'package:loans/utils/internationalization/app_localizations.dart';
import 'package:provider/provider.dart';

class AmountInterest extends StatelessWidget {
  validateAmount(context, text) {
    final i18n = AppLocalizations.of(context);
    try {
      return text == null || int.parse(text) >= 0
          ? null
          : i18n.translate('invalidValue');
    } on Exception {
      return i18n.translate('invalidValue');
    }
  }

  @override
  Widget build(context) {
    final i18n = AppLocalizations.of(context);
    final newDebtProvider = Provider.of<NewDebtProvider>(context);
    final newDebtProviderNL =
        Provider.of<NewDebtProvider>(context, listen: false);
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              errorText: validateAmount(context, newDebtProvider.amount),
              filled: false,
              labelText: i18n.translate('amount'),
              hintText: "0",
              suffix: dropDown(context, Coin.values,
                  newDebtProvider.selectedCoin, newDebtProviderNL.changeCoin),
            ),
            onChanged: (value) {
              newDebtProviderNL.changeAmount(value);
            },
            initialValue: newDebtProvider.amount,
          ),
          flex: 2,
        ),
        VerticalDivider(),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                errorText: validateAmount(context, newDebtProvider.interest),
                labelText: AppLocalizations.of(context).translate('interest'),
                hintText: 'Ej. 10',
                suffix: dropDown(
                    context,
                    Periodicity.values,
                    newDebtProvider.periodicity,
                    newDebtProviderNL.changePeriodicity)),
            onChanged: (value) {
              newDebtProviderNL.changeInterest(value);
            },
            initialValue: newDebtProvider.interest,
          ),
          flex: 2,
        ),
      ],
    );
  }
}
