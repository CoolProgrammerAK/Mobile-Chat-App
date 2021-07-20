import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:timeago/timeago.dart' as timeago;
class ChatRow extends StatelessWidget {
  const ChatRow({
    Key key,
    @required this.userName,
    @required this.photo,
    this.time,
  }) : super(key: key);

  final String userName;
  final String photo;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          photo == ''
              ? Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: Text(userName.substring(0, 1).toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w300)),
                  ),
                )
              : Material(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                      ),
                      width: 30.0,
                      height: 30.0,
                      padding: EdgeInsets.all(20.0),
                    ),
                    imageUrl: photo,
                    width: 60.0,
                    height: 60.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  clipBehavior: Clip.hardEdge,
                ),
          SizedBox(
            width: 17,
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "${userName.substring(0, 1).toUpperCase()}${userName.substring(
                          1,
                        )}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    Text(timeago.format(DateTime.parse(time)),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                            fontWeight: FontWeight.w300)),
                  ],
                ),
                SizedBox(
                  height: 7,
                ),
                Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
