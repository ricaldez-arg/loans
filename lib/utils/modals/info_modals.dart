
import 'package:flutter/material.dart';

Future<void> showTermAndCondition(context) async {
  return showDialog<void>(
    context: context,
    // barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Terminos y condiciones'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Terminos: Uso de terminos'),
              Text('Condiciones: Usted acepta estas condiciones'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Aceptar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}