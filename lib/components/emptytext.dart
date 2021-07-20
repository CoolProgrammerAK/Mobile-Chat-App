import 'package:flutter/material.dart';

class Emptytext extends StatelessWidget {
  const Emptytext({
    Key key,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 195,
      width: MediaQuery.of(context).size.width,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Search for your favourite one and start chatting ",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black.withOpacity(.6),
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w500,
                fontSize: 22),
          ),
          SizedBox(
            height: 7,
          ),
        ],
      )),
    );
  }
}