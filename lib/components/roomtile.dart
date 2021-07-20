import 'package:chatapp/components/chatrow.dart';
import 'package:chatapp/helper/database.dart';
import 'package:chatapp/screens/chat.dart';
import 'package:chatapp/screens/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RoomTile extends StatefulWidget {
  final String userPhone;
  final String chatRoomId;
  final String time;
  const RoomTile({Key key, this.userPhone, this.chatRoomId, this.time})
      : super(key: key);

  @override
  _RoomTileState createState() => _RoomTileState();
}

class _RoomTileState extends State<RoomTile> {
  final Database database = Database();
  QuerySnapshot querySnapshot;
  String userName = '';
  String aboutme = '';
  bool isloading = false;

  String photo = '';
  @override
  void initState() {
    getusername();
    super.initState();
  }

  getusername() async {
    setState(() {
      isloading = true;
    });
    querySnapshot = await database.getusernamewithphone(widget.userPhone);
    if (querySnapshot.docs.length > 0) {
      setState(() {
        userName = querySnapshot.docs[0].get("name");
        photo = querySnapshot.docs[0].get("photo");
        aboutme = querySnapshot.docs[0].get("about");

        isloading = false;
      });
    } else {
      setState(() {
        userName = '';
        photo = '';
        isloading = false;
      });
    }
  }

  showalertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text("Are you sure you want to delete this chat ?"),
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
            database.deletechatroom(widget.chatRoomId);
            setState(() {});
            Navigator.pop(context);

            ;
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
    if (isloading == true) {
      return ChatRow(
          userName: "Unknown", photo: '', time: DateTime.now().toString());
    } else {
      return InkWell(
        onLongPress: () {
          showalertDialog(context);
        },
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatRoom(
                      name: userName,
                      photo: photo,
                      id: widget.chatRoomId,
                      about: aboutme,
                      phone: widget.userPhone)));
        },
        child: ChatRow(userName: userName, photo: photo, time: widget.time),
      );
    }
  }
}