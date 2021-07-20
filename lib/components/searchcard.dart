import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/database.dart';
import 'package:chatapp/screens/conversation.dart';
import 'package:chatapp/screens/settings.dart';
import 'package:flutter/material.dart';

class SearchCard extends StatelessWidget {
  final String username;
  final String phone, about, photo;
  final String currentphone;
  SearchCard(
      {Key key,
      this.username,
      this.phone,
      this.currentphone,
      this.about,
      this.photo})
      : super(key: key);

  Widget build(BuildContext context) {
    getChatRoomId(String a, String b) {
      if (a.hashCode > b.hashCode) {
        return "$b\_$a";
      } else {
        return "$a\_$b";
      }
    }

    createroom({String userName, String phone}) async {
      if (phone != currentphone) {
        List<String> users = [Constants.phone, phone];
        String chatRoomId = getChatRoomId(Constants.phone, phone);
        Map<String, dynamic> chatRoom = {
          "users": users,
          "chatRoomId": chatRoomId,
          "time": DateTime.now().toString()
        };
        Database().chatroom(chatRoomId, chatRoom);

        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ChatRoom(
            id: chatRoomId,
            phone: phone,
            about: about,
            name: userName,
            photo: photo,
          );
        }));
      } else {}
    }

    return InkWell(
      onTap: () {
        currentphone == phone
            ? Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatSettings()))
            : createroom(userName: username, phone: phone);
      },
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 250),
                        child: Container(
                          child: Text(
                            username,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                // color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(29),
                    ),
                    width: 130,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(currentphone == phone ? "Edit" : "Message",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                ],
              )),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
          )
        ],
      ),
    );
  }
}