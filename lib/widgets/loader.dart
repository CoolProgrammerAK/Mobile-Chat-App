import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final text;
  const Loader({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black.withOpacity(0.3),
        child: Center(
            child: Container(
          padding: EdgeInsets.all(10),
          width: 190,
          height: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent)),
              Text(
                text,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w100),
              )
            ],
          ),
        )));
  }
}
