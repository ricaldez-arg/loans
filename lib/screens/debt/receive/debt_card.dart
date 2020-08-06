import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loans/models/debt/debt.dart';
import 'package:loans/models/enums.dart';
import 'package:loans/providers/debt/receive_debt_provider.dart';
import 'package:loans/utils/internationalization/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:loans/widgets/change_amount.dart';
import 'package:provider/provider.dart';

class DebtCard extends StatelessWidget {
  final Debt debt;
  final Coin currency;
  final NumberFormat formater = NumberFormat.currency(symbol: '');
  DebtCard(this.debt) : this.currency = debt.amount.currency;

  handleAcept(context, amount) {
    Navigator.pop(context, amount);
  }

  Future<dynamic> showAddPaymentDialog(context) async {    
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: ChangeAmount(debt, handleAcept),
        );
      },
    );
  }

  addPayment(context) async {
    final amount = await showAddPaymentDialog(context);
    if (amount != null) {
      print(amount);

      Provider.of<ReceiveDebtProvider>(context, listen: false)
      .addPayment(context, debt, amount);
    }
  }

  userName(context) {
    return Text(
      debt.creditor,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }

  debtDate(context) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.calendar_today,
          color: Colors.blueGrey,
          size: 10,
        ),
        Text(
          ' ${DateFormat('dd/MM/yyyy').format(debt.createdAt)}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        VerticalDivider(
          width: 10,
        ),
        Icon(
          Icons.access_time,
          color: Colors.blueGrey,
          size: 10,
        ),
        Text(
          ' ${DateFormat('HH:mm').format(debt.createdAt)}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  debtAmountsResume(context) {
    final i18n = AppLocalizations.of(context);
    // final NumberFormat formater =
    //     NumberFormat.currency(symbol: i18n.translate(describeEnum(currency)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text('${i18n.translate('amount')}:'),
            Text(
              '${formater.format(debt.amount.originalAmount)}',
              softWrap: false,
              overflow: TextOverflow.fade,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text('${i18n.translate('interestAmount')}:'),
            Text(formater.format(debt.calculateEarnedInterest())),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text('${i18n.translate('onAccount')}:'),
            Text(formater.format(debt.calculateAmountPaid())),
          ],
        ),
      ],
    );
  }

  collectButton(context) {
    final i18n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () {
        addPayment(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.monetization_on,
            color: Colors.green,
            size: 18,
          ),
          Text(
            '${i18n.translate('collect').toUpperCase()} ',
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  toPay(context) {
    final i18n = AppLocalizations.of(context);
    return Column(
      children: <Widget>[
        Text(
          '${i18n.translate('toPay')} ${i18n.translate(describeEnum(currency))}',
          style: TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'Monospace',
          ),
        ),
        Text(
          formater.format(debt.calculateAmountToPay()),
          style: TextStyle(
            color: Colors.red,
            fontSize: 20,
          ),
        ),
        collectButton(context),
      ],
    );
  }

  debtAmounts(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: debtAmountsResume(context),
        ),
        VerticalDivider(
          width: 10,
        ),
        toPay(context),
      ],
    );
  }

  details(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        userName(context),
        debt.reason == null
            ? Container()
            : Text(
                debt.reason,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[800]),
              ),
        debtDate(context),
        debtAmounts(context),
      ],
    );
  }

  userPhoto(context) {
    return Container(
      child: Icon(
        Icons.account_box,
        size: 60,
        color: Colors.deepPurple[200],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.fromLTRB(2, 5, 5, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                userPhoto(context),
                Expanded(
                  child: details(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
