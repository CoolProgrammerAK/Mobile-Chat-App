import 'dart:io';
import 'package:chatapp/components/roomtile.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/database.dart';
import 'package:chatapp/helper/shared.dart';
import 'package:chatapp/modal/Choice.dart';
import 'package:chatapp/screens/phone.dart';
import 'package:chatapp/screens/search.dart';
import 'package:chatapp/screens/settings.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/widgets/loader.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  Chat({Key key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Stream rooms;
  Helper helper = Helper();
  @override
  void initState() {
    super.initState();
    getuserInfo();
   
  }

  getuserInfo() async {
    Constants.name = await Helper.getname();
    Constants.phone = await Helper.getphone();
    rooms = await database.getRooms(Constants.phone);

    setState(() {});
  }

  final AuthService authService = AuthService();
  final Database database = Database();
  bool isloading = false;
  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Log out') {
      Helper.clear();
      authService.signOut();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return Phone();
      }));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ChatSettings()));
    }
  }

  Widget roomlist() {
    return StreamBuilder(
      stream: rooms,
      builder: (BuildContext context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return RoomTile(
                    userPhone: snapshot.data.docs[index]
                        .data()["chatRoomId"]
                        .replaceAll("_", "")
                        .replaceAll(Constants.phone, ""),
                    chatRoomId: snapshot.data.docs[index].data()["chatRoomId"],
                    time: snapshot.data.docs[index].data()["time"],
                  );
                },
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(0, 100, 0, 1),
          child: Icon(Icons.search),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return Search();
            }));
          },
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Image.asset(
            "assets/images/logo.png",
            height: 50,
          ),
          actions: [
            PopupMenuButton(
              onSelected: onItemMenuPress,
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                      value: choice,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            choice.icon,
                            color: Colors.black,
                          ),
                          Container(
                            width: 10.0,
                          ),
                          Text(
                            choice.title,
                          ),
                        ],
                      ));
                }).toList();
              },
            )
          ],
        ),
        body: WillPopScope(
          onWillPop: backpress,
          child: Stack(children: [
            Positioned(
              child: isloading
                  ? Loader(
                      text: "Loading",
                    )
                  : Container(),
            ),
            roomlist()
          ]),
        ));
  }

  Future<bool> backpress() {
    openDialog();
    return Future.value(false);
  }

  Future<Null> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding:
                EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
            children: <Widget>[
              Container(
                color: Colors.green,
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                height: 150.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30.0,
                        color: Colors.black,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      'Exit app',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Are you sure to exit app?',
                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                      ),
                      margin: EdgeInsets.only(right: 10.0, bottom: 5),
                    ),
                    Text(
                      'CANCEL',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'YES',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
        break;
    }
  }
}



