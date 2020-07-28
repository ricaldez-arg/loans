import 'package:flutter/material.dart';
import 'package:loans/providers/session/session_provider.dart';
import 'package:provider/provider.dart';

Future<void> showSessionModal(context, message, next) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(next == '/' ? 'Operacion exitosa' : 'Algo salio mal'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Divider(color: Colors.blueGrey,),
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: FlatButton(
              child: Text('Aceptar'),
              onPressed: () {
                Provider.of<SessionProvider>(context, listen: false).state = SessionState.UNLOGGED;
                
                Navigator.pushNamed(context, next);
              },
            ),
          ),
        ],
      );
    },
  );
}