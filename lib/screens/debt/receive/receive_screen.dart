import 'package:flutter/material.dart';
import 'package:loans/models/debt/debt.dart';
import 'package:loans/providers/debt/receive_debt_provider.dart';
import 'package:loans/screens/debt/receive/debt_card.dart';
import 'package:provider/provider.dart';

class ReceiveScreen extends StatelessWidget {

  debtList(context) {
    final receiveProvider = Provider.of<ReceiveDebtProvider>(context);
    final List<Debt> debts = receiveProvider.debts;
    return ListView(
      padding: EdgeInsets.all(10),
      children: debts.map<Widget>((debt) {
        return DebtCard(debt);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: debtList(context),
    );
  }
}
