import 'package:flutter/material.dart';

Widget appbar(BuildContext context, String title) {
  return AppBar(
      title: Text(
    title,
    style: TextStyle(fontFamily: 'Raleway'),
  ));
}

InputDecoration inputDecoration(text) {
  return InputDecoration(
    labelText: text,
    filled: true,
    fillColor: Colors.white30,
    errorStyle: TextStyle(color: Colors.redAccent),
    border: OutlineInputBorder(),
    focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
  );
}

TextStyle textStyle() {
  return TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );
}

TextStyle textStyle2() {
  return TextStyle(color: Colors.white, fontSize: 14);
}
