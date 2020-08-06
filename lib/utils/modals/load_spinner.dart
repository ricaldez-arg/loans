import 'package:flutter/material.dart';

showLoadSpinner(context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    child: AlertDialog(
      content: CircularProgressIndicator(),
    ),
  );
}

hideLoadSpinner(context) {
  Navigator.pop(context);
}
