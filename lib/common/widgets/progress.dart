import 'package:flutter/material.dart';

Widget progress() {
  return AlertDialog(
    contentPadding: EdgeInsets.all(15),
    content: Row(
      children: <Widget>[
        CircularProgressIndicator(),
        SizedBox(width: 20),
        Text('Just a moment ...'),
      ],
    ),
  );
}