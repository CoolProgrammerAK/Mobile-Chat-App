import 'dart:ui';
import 'package:chatapp/components/emptytext.dart';
import 'package:chatapp/components/searchcard.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/database.dart';
import 'package:chatapp/helper/shared.dart';
import 'package:chatapp/screens/settings.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/screens/conversation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Database database = Database();
  SharedPreferences sharedPreferences;
  bool isloading = false;
  QuerySnapshot querySnapshot;
  TextEditingController search = TextEditingController();
  String currentphone;
  @override
  void initState() {
    super.initState();
    search.text = "";
    Helper.getphone().then((value) {
      setState(() {
        currentphone = value;
      });
    });
  }

  initiate() {
    setState(() {
      isloading = true;
    });

    database.getuser().then((val) {
      setState(() {
        querySnapshot = val;

        isloading = false;
      });
    });
  }

  Widget seachlist() {
    return querySnapshot != null
        ? ListView.builder(
            itemCount: querySnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, index) {
              String name = querySnapshot.docs[index].get('name');
              if (name.toLowerCase().contains(search.text.toLowerCase())) {
                return SearchCard(
                    username: name,
                    currentphone: currentphone,
                    phone: querySnapshot.docs[index].get("phone"),
                    photo: querySnapshot.docs[index].get("photo"),
                    about: querySnapshot.docs[index].get("about"));
              } else {
                return Container();
              }
            },
          )
        : Emptytext(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appbar(context, "Search"),
      body: Container(
        child: Column(
          children: [
            Container(
              // color: Color(0x54FFFFFF),
              color: Color.fromRGBO(240, 242, 245, 1),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      textInputAction: TextInputAction.search,

                      onSubmitted: (e) {
                        initiate();
                      },
                      controller: search,
                      // style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          fillColor: Color.fromRGBO(240, 242, 245, .6),
                          filled: true,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: "Search username",
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black45, width: 2.0),
                          ),
                          // hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiate();
                    },
                    child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 100, 0, 1),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: EdgeInsets.all(12),
                        child: Image.asset('assets/images/search_white.png')),
                  )
                ],
              ),
            ),
            Stack(
              children: [
                Positioned(
                  child: isloading
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 175,
                          child: Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color.fromRGBO(0, 100, 0, 1))),
                          ),
                        )
                      : seachlist(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}



