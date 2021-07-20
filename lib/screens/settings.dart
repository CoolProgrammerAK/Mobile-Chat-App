import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/helper/database.dart';
import 'package:chatapp/helper/shared.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:chatapp/widgets/loader.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ChatSettings extends StatefulWidget {
  ChatSettings({Key key}) : super(key: key);

  @override
  _ChatSettingsState createState() => _ChatSettingsState();
}

class _ChatSettingsState extends State<ChatSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context, "Settings"),
      body: Settings(),
    );
  }
}

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController controllername;
  TextEditingController controllerAboutMe;
  TextEditingController controllerphone;

  final Helper helper = Helper();
  File avatarImageFile;
  bool isupdating = false;
  String photo = '';
  String id = '';
  String name = '';
  String aboutme = '';
  final Database database = Database();
  final FocusNode focusNodeName = FocusNode();
  final FocusNode focusNodeAboutMe = FocusNode();
  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    id = await Helper.getid() ?? '';

    name = await Helper.getname() ?? '';
    aboutme = await Helper.getabout() ?? '';
    photo = await Helper.getphoto() ?? '';
    controllername = TextEditingController(text: name);
    controllerAboutMe = TextEditingController(text: aboutme=="Tell me something about yourself"?null:aboutme);
    controllerphone = TextEditingController(text: id);
    // Force refresh input
    setState(() {});
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    File image = File(pickedFile.path);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isupdating = true;
      });
    }
    uploadFile();
  }

  Future uploadFile() async {
    String fileName = id;
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(avatarImageFile);
    uploadTask.whenComplete(() async {
      try {
        String downloadurl = await reference.getDownloadURL();
        photo = downloadurl;

        await database.update(name, aboutme, photo);

        Helper.setuserphoto(photo);

        setState(() {
          isupdating = false;
        });
        Fluttertoast.showToast(
            msg: "Image uploaded",
            textColor: Colors.black,
            backgroundColor: Colors.grey[100]);
      } catch (e) {
        setState(() {
          isupdating = false;
        });
        Fluttertoast.showToast(msg: e.toString());
      }
    });
  }

  void handleUpdateData() async {
    focusNodeName.unfocus();
    focusNodeAboutMe.unfocus();

    setState(() {
      isupdating = true;
    });
    try {
      await database.update(name, aboutme, photo);
      Helper.setusername(name);
      Helper.setuserphoto(photo);
      Helper.setuserdes(aboutme);

      setState(() {
        isupdating = false;
      });
      Fluttertoast.showToast(
          msg: "Profile Updated successfully",
          textColor: Colors.black,
          backgroundColor: Colors.grey[100]);
    } catch (e) {
      setState(() {
        isupdating = false;
      });
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Avatar
              Container(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      (avatarImageFile == null)
                          ? (photo != ''
                              ? Material(
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.amber),
                                      ),
                                      width: 90.0,
                                      height: 90.0,
                                      padding: EdgeInsets.all(20.0),
                                    ),
                                    imageUrl: photo,
                                    width: 120.0,
                                    height: 120.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(65.0)),
                                  clipBehavior: Clip.hardEdge,
                                )
                              : Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(65)),
                                  child: Center(
                                    child: Text(
                                       name!="" ? name.substring(0, 1).toUpperCase():"",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w300)),
                                  ),
                                ))
                          : Material(
                              child: Image.file(
                                avatarImageFile,
                                width: 120.0,
                                height: 120.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(65.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                      Positioned(
                        right: -25,
                        bottom: -25,
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.black.withOpacity(0.8),
                          ),
                          onPressed: getImage,
                          padding: EdgeInsets.all(20.0),
                          highlightColor: Colors.grey,
                          iconSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(20.0),
              ),

              // Input
              Column(
                children: <Widget>[
                  // Username
                  Container(
                    child: Text(
                      'Name',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, bottom: 5.0, top: 10.0),
                  ),
                  Container(
                    child: TextField(
                      style: TextStyle(color: Colors.grey[700]),
                      cursorColor: Color.fromRGBO(0, 100, 0, 1),
                      decoration: InputDecoration(
                        hintText: 'Sweetie',
                        contentPadding: EdgeInsets.all(5.0),
                        hintStyle: TextStyle(color: Colors.grey[400]),
                      ),
                      controller: controllername,
                      onChanged: (value) {
                        name = value;
                      },
                      focusNode: focusNodeName,
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),

                  // About me
                  Container(
                    child: Text(
                      'About me',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, top: 30.0, bottom: 5.0),
                  ),
                  Container(
                    child: TextField(
                      cursorColor: Color.fromRGBO(0, 100, 0, 1),
                      style: TextStyle(color: Colors.grey[700]),
                      decoration: InputDecoration(
                        hintText: 'Fun, like travel and play PES...',
                        contentPadding: EdgeInsets.all(5.0),
                        hintStyle: TextStyle(color: Colors.grey[400]),
                      ),
                      controller: controllerAboutMe,
                      onChanged: (value) {
                        aboutme = value;
                      },
                      focusNode: focusNodeAboutMe,
                    ),
                    // ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),

                  Container(
                    child: Text(
                      'Phone number',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, top: 30.0, bottom: 5.0),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[700]))),
                    child: Text(
                      "${id}",
                      style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    ),
                    // ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),

              // Button
              Container(
                child: FlatButton(
                    onPressed: handleUpdateData,
                    child: Text(
                      'UPDATE',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    color: Color.fromRGBO(0, 100, 0, 1),
                    highlightColor: Color(0xff8d93a0),
                    splashColor: Colors.transparent,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9))),
                margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
        ),

        // Loading

        Positioned(
          child: isupdating == true ? Loader(text: "Updating...") : Container(),
        ),
      ],
    );
  }
}
