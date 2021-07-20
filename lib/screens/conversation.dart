import 'dart:ui';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/components/mesagetile.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/database.dart';
import 'package:chatapp/modal/Choice.dart';
import 'package:chatapp/screens/profile.dart';
import 'package:chatapp/widgets/loader.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/screens/photo.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom({Key key, this.id, this.about, this.phone, this.photo, this.name})
      : super(key: key);
  final String id, about, phone, photo, name;

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController textEditingController = TextEditingController();
  Database database = Database();
  Stream messages;
  final ScrollController _scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  File imageFile;
  bool isLoading = false;
  bool isShowSticker = false;
  bool isvisible = false;
  String imageUrl;
  List<Choice> choices = const <Choice>[
    const Choice(title: 'View Profile', icon: Icons.account_circle_outlined),
  ];

  sendmsg(String content, int type) async {
    if (content.trim() != '') {
      Map<String, dynamic> message = {
        "message": content,
        "sendby": Constants.phone,
        "time": DateFormat.jm().format(DateTime.now()),
        "day": DateFormat.yMMMMd().format(DateTime.now()),
        "time2": DateTime.now().microsecondsSinceEpoch,
        "type": type
      };
      
      database.sendmessage(widget.id, message);
      database.updatetime(widget.id, DateTime.now().toString());
    }
    textEditingController.text = "";
    animateto();
  }

  animateto() {
    _scrollController.animateTo(0.0,
        duration: Duration(milliseconds: 1000), curve: Curves.easeInOut);
  }

  @override
  void initState() {
    super.initState();
 
    focusNode.addListener(onFocusChange);
    database.getmessages(widget.id).then((v) {
      setState(() {
        messages = v;
      });
    });
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void getSticker() {
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;
    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);
    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile);
    await uploadTask.whenComplete(() => {
          reference.getDownloadURL().then((downloadUrl) {
            imageUrl = downloadUrl;
            setState(() {
              isLoading = false;
              sendmsg(imageUrl, 1);
            });
          })
        });
  }

  Widget msgList() {
    return StreamBuilder(
      stream: messages,
      builder: (BuildContext context, snapshot) {
        return snapshot.hasData && snapshot.data.docs.length > 0
            ? Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: GroupedListView(
                    controller: _scrollController,
                    elements: snapshot.data.docs,
                    groupBy: (element) => element.data()["day"] !=
                            DateFormat.yMMMMd().format(DateTime.now())
                        ? element.data()["day"]
                        : "Today",
                    groupComparator: (v1, v2) => v2.compareTo(v1),
                    groupSeparatorBuilder: (value) => Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 80, vertical: 6),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Color.fromRGBO(179, 247, 242, .7),
                          ),
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  value,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ]),
                        ),
                    itemBuilder: (context, element) => MessageTile(
                        message: element["message"],
                        documentId: element.id,
                        time: element["time"],
                        day: element["day"],
                        id: widget.id,
                        type: element["type"],
                        sendByMe: element["sendby"] == Constants.phone
                            ? true
                            : false)),
              )
            : Container();
      },
    );
  }

  void onItemMenuPress(Choice choice) {
    if (choice.title == 'View Profile') {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return Profile(
            name: widget.name,
            phone: widget.phone,
            photo: widget.photo,
            about: widget.about);
      }));
    }
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => sendmsg('mimi1', 2),
                child: Image.asset(
                  'assets/images/mimi1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => sendmsg('mimi2', 2),
                child: Image.asset(
                  'assets/images/mimi2.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => sendmsg('mimi3', 2),
                child: Image.asset(
                  'assets/images/mimi3.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => sendmsg('mimi4', 2),
                child: Image.asset(
                  'assets/images/mimi4.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => sendmsg('mimi5', 2),
                child: Image.asset(
                  'assets/images/mimi5.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => sendmsg('mimi6', 2),
                child: Image.asset(
                  'assets/images/mimi6.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => sendmsg('mimi7', 2),
                child: Image.asset(
                  'assets/images/mimi7.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => sendmsg('mimi8', 2),
                child: Image.asset(
                  'assets/images/mimi8.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => sendmsg('mimi9', 2),
                child: Image.asset(
                  'assets/images/mimi9.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 0.5)), color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (isShowSticker) {
          setState(() {
            isShowSticker = false;
          });
        } else {
          Navigator.of(context).popAndPushNamed("/");
        }
      },
      child: Scaffold(
        appBar: AppBar(
            actions: [
              PopupMenuButton(
                onSelected: onItemMenuPress,
                itemBuilder: (BuildContext context) {
                  return choices.map((Choice choice) {
                    return PopupMenuItem<Choice>(
                        value: choice,
                        child: Row(
                          children: <Widget>[
                            Material(
                              child: Icon(
                                choice.icon,
                                color: Colors.black,
                              ),
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
            title: Text(
              "Chat",
              style: TextStyle(fontFamily: 'Raleway'),
            )),
        body: Container(
          child: Stack(
            children: [
              msgList(),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3.0, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Material(
                            color: Colors.white,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 1),
                              child: IconButton(
                                color: Colors.blueGrey,
                                icon: Icon(Icons.mood),
                                onPressed: getSticker,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              child: TextField(
                                  style: TextStyle(fontFamily: 'Roboto'),
                                  textInputAction: TextInputAction.done,
                                  focusNode: focusNode,
                                  onSubmitted: (value) {
                                    sendmsg(textEditingController.text, 0);
                                  },
                                  controller: textEditingController,
                                  decoration: InputDecoration(
                                    fillColor: Color.fromRGBO(240, 242, 245, 1),
                                    filled: true,
                                    hintText: "Message",
                                    // hintStyle: TextStyle(color: Colors.white54),
                                    border: InputBorder.none,
                                  )),
                            ),
                          ),
                          Material(
                            color: Colors.white,
                            child: IconButton(
                              color: Colors.blueGrey,
                              icon: Icon(Icons.photo),
                              onPressed: getImage,
                            ),
                          ),
                          Material(
                            color: Colors.white,
                            child: IconButton(
                              color: Colors.blueGrey,
                              icon: Icon(Icons.send),
                              onPressed: () {
                                sendmsg(textEditingController.text, 0);
                              },
                            ),
                          ),
                        ],
                      ),
                      (isShowSticker ? buildSticker() : Container())
                    ],
                  ),
                ),
              ),
              Positioned(
                child: isLoading
                    ? Loader(
                        text: "Loading...",
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

