import 'package:flutter/material.dart';
import 'package:loans/providers/debt/new_debt_provider.dart';
import 'package:loans/utils/internationalization/app_localizations.dart';
import 'package:provider/provider.dart';

class HeadOptions extends StatelessWidget {
  final activeColor = Colors.green[400];
  final textActiveColor = Colors.green[900];
  final unactiveColor = Colors.grey[700];

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    final newDebtProvider = Provider.of<NewDebtProvider>(context);
    final newDebtProviderNL =
        Provider.of<NewDebtProvider>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FlatButton.icon(
          onPressed: () {
            newDebtProviderNL.togleIsCreditor();
          },
          icon: Icon(
            Icons.check_circle,
            color: newDebtProvider.isCreditor ? activeColor : Colors.white,
            size: 18,
          ),
          label: Text(
            i18n.translate('owesMe'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:
                  newDebtProvider.isCreditor ? textActiveColor : unactiveColor,
            ),
          ),
        ),
        Container(width: 5),
        FlatButton.icon(
          onPressed: () {
            newDebtProviderNL.togleIsCreditor();
          },
          icon: Icon(
            Icons.check_circle,
            color: !newDebtProvider.isCreditor ? activeColor : Colors.white,
            size: 18,
          ),
          label: Text(
            i18n.translate('iOwes'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:
                  !newDebtProvider.isCreditor ? textActiveColor : unactiveColor,
            ),
          ),
        ),
      ],
    );
  }
}
