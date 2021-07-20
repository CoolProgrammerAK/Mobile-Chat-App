import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/helper/database.dart';
import 'package:chatapp/screens/photo.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final String time, day, id, documentId;
  final int type;
  MessageTile(
      {@required this.message,
      @required this.sendByMe,
      this.documentId,
      this.time,
      this.day,
      this.id,
      this.type});
  showalertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text("Are you sure you want to delete this message ?"),
      actions: [
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            Database().deletemessage(id, documentId);
            Navigator.pop(context);
          },
        )
      ],
    );
    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        showalertDialog(context);
      },
      child: Container(
        padding: EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: sendByMe ? 0 : 24,
            right: sendByMe ? 24 : 0),
        alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Stack(
          children: [
            type == 0
                ? Container(
                    margin: sendByMe
                        ? EdgeInsets.only(left: 30)
                        : EdgeInsets.only(right: 30),
                    padding: EdgeInsets.only(
                        top: 24, bottom: 24, left: 30, right: 30),
                    decoration: BoxDecoration(
                        borderRadius: sendByMe
                            ? BorderRadius.only(
                                topLeft: Radius.circular(23),
                                topRight: Radius.circular(23),
                                bottomLeft: Radius.circular(23))
                            : BorderRadius.only(
                                topLeft: Radius.circular(23),
                                topRight: Radius.circular(23),
                                bottomRight: Radius.circular(23)),
                        gradient: LinearGradient(
                          colors: sendByMe
                              ? [
                                  const Color(0xff007EF4),
                                  const Color(0xff2A75BC)
                                ]
                              : [
                                  const Color(0xfff0f0f0),
                                  const Color(0xffe5e5e5)
                                ],
                        )),
                    child: Text(message,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: sendByMe ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w300)),
                  )
                : type == 1
                    ? Container(
                        child: GestureDetector(
                          child: Hero(
                            tag: message,
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.redAccent),
                                ),
                                width: 50.0,
                                height: 50.0,
                                padding: EdgeInsets.all(70.0),
                                decoration: BoxDecoration(
                                  // color: greyColor2,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Material(
                                child: Image.asset(
                                  'images/img_not_available.jpeg',
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                              imageUrl: message,
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FullPhoto(url: message)));
                          },
                        ),
                        margin: EdgeInsets.only(left: 10.0),
                        padding: EdgeInsets.only(bottom: 15.0),
                      )
                    : Container(
                        child: Image.asset(
                          'assets/images/${message}.gif',
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                        ),
                        margin: sendByMe
                            ? EdgeInsets.only(left: 30, bottom: 15)
                            : EdgeInsets.only(right: 30, bottom: 15),
                      ),
            Positioned(
              bottom: type == 1
                  ? 0
                  : sendByMe
                      ? 2
                      : 4,
              right: sendByMe ? 2 : 41,
              child: Text(time,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: type == 0
                        ? sendByMe
                            ? Colors.white70
                            : Colors.black54
                        : Colors.black54,
                    fontSize: 9,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
