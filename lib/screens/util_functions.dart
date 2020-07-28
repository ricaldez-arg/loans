import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loans/utils/internationalization/app_localizations.dart';

dropDown(context, items, selectedItem, handleChange,
    {upperCase = false, expanded = false, hint}) {
  final i18n = AppLocalizations.of(context);
  return DropdownButton<dynamic>(
    isExpanded: expanded,
    isDense: true,
    value: selectedItem,
    style: TextStyle(color: Colors.blueGrey[800], fontSize: 14),
    underline: Container(
      height: 0,
    ),
    onChanged: (selected) {
      handleChange(selected);
    },
    hint: hint,
    items: items.map<DropdownMenuItem<dynamic>>((value) {
      return DropdownMenuItem<dynamic>(
        value: value,
        child: Text(
          upperCase
              ? i18n.translate(describeEnum(value)).toUpperCase()
              : i18n.translate(describeEnum(value)),
        ),
      );
    }).toList(),
  );
}
