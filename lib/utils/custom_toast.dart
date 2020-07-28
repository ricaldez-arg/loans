import 'package:flutter/material.dart';

class CustomToast extends StatelessWidget {
  final String message;
  CustomToast(this.message);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.red,
        ),
        child: Text(message, style: TextStyle(color: Colors.white),),
    );
  }

}