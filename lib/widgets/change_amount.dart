import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loans/models/debt/debt.dart';
import 'package:loans/utils/internationalization/app_localizations.dart';

class ChangeAmount extends StatefulWidget {
  final Debt debt;
  final Function(BuildContext, num) handleAcept;
  ChangeAmount(this.debt, this.handleAcept);

  @override
  State<StatefulWidget> createState() {
    return _ChangeAmount(debt, handleAcept);
  }
}

class _ChangeAmount extends State<ChangeAmount> {
  final validator =
      RegExp(r'(?=.*?\d)^\$?(([1-9]\d{0,2}(,\d{3})*)|\d+)?(\.\d{1,2})?$');
  String _value;
  final Debt debt;
  final Function(BuildContext, num) handleAcept;
  _ChangeAmount(this.debt, this.handleAcept);

  handleSubmit([text]) {
    if (_value != null && validator.hasMatch(_value)) {
      final amount = _value.replaceAll(',', '');

      handleAcept(context, num.parse(amount));
    }
  }

  Widget _amountInput(context) {
    final i18n = AppLocalizations.of(context);
        return TextFormField(
          keyboardType: TextInputType.number,
          onFieldSubmitted: handleSubmit,
          autovalidate: true,
          decoration: InputDecoration(
            icon: Icon(
              Icons.monetization_on,
              color: Colors.blueGrey,
            ),
            hintText: '${i18n.translate('amountHint')}',
            labelText: '${i18n.translate('amount')} *',
      ),
      onChanged: (text) {
        setState(() {
          _value = text;
        });
      },
      validator: (value) {
        return value != null && value.isNotEmpty && validator.hasMatch(value)
            ? null
            : '${i18n.translate('invalidAmount')}';
      },
    );
  }

  Widget _sendButton(label) {
    return ButtonTheme(
      height: 40,
      minWidth: 80,
      child: FlatButton(
        onPressed: handleSubmit,
        textColor: Colors.green[700],
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  remainingAmount(context) {}

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    final currencyKey = describeEnum(debt.amount.currency);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${i18n.translate('remainingAmount')}:',
              style: TextStyle(
                color: Colors.blueGrey,
              ),
            ),
          ),
          Text(
            '${debt.calculateAmountToPay()} ${i18n.translate(currencyKey)}',
            style: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          _amountInput(context),
        ],
      ),
      actionsOverflowButtonSpacing: 100,
      actions: <Widget>[
        FlatButton(
          textColor: Colors.blueGrey[400],
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            i18n.translate('cancel'),
            style: TextStyle(fontSize: 16),
          ),
        ),
        _sendButton(i18n.translate('save')),
      ],
    );
  }
}
