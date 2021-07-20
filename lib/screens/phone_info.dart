import 'package:chatapp/helper/database.dart';
import 'package:chatapp/helper/shared.dart';
import 'package:chatapp/screens/chat.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:chatapp/widgets/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneInfo extends StatefulWidget {
  final String phone, uid;
  PhoneInfo({Key key, this.phone, this.uid}) : super(key: key);

  @override
  _PhoneInfoState createState() => _PhoneInfoState();
}

class _PhoneInfoState extends State<PhoneInfo> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final Database database = Database();

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  final TextEditingController name = TextEditingController();

  final TextEditingController error = TextEditingController();
  final key = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  bool isloading = false;
  bool showerror = false;
  String errortext;
  final Helper helper = Helper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
          title: Text(
        "PROFILE",
        style: TextStyle(
            fontFamily: 'Raleway', fontSize: 16, fontWeight: FontWeight.w600),
      )),
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.height - 90,
            height: MediaQuery.of(context).size.height - 50,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 25),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: key,
                  child: Column(
                    children: [
                      Container(
                          child: TextFormField(
                              controller: name,
                              style: textStyle(),
                              keyboardType: TextInputType.name,
                              maxLength: 20,
                              validator: (val) {
                                return val.length < 4
                                    ? "Required 3+ characters"
                                    : null;
                              },
                              decoration: inputDecoration("Enter name"))),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Visibility(
                  visible: error.text != "" ? true : false,
                  child: Container(
                    alignment: Alignment.center,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        error.text != "" ? error.text : "",
                        style: TextStyle(color: Colors.redAccent, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onPressed: () async {
                      if (key.currentState.validate()) {
                        setState(() {
                          isloading = true;
                          showerror = false;
                          errortext = "";
                        });
                        try {
                          await database.upload(name.text, widget.phone);

                          Helper.setuserphone(widget.phone);
                          Helper.setusername(name.text);
                          Helper.setlog(true);
                          Helper.setid(widget.phone);
                          Helper.setuserphoto("");
                          Helper.setuserdes("Tell me something about yourself");

                          Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return Chat();
                          }));
                        } catch (e) {
                          setState(() {
                            isloading = false;
                            showerror = true;
                            errortext = e.toString();
                          });
                        }
                      }
                    },
                    child: Text("Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700))),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          child: isloading
              ? Loader(
                  text: "Loading...",
                )
              : Container(),
        ),
        Positioned(
          child: showerror
              ? Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Icon(
                          Icons.error_outline_rounded,
                          size: 37,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          errortext,
                          style: TextStyle(
                              color: Colors.yellow,
                              fontFamily: 'Raleway',
                              fontSize: 17,
                              fontWeight: FontWeight.w800),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  color: Color.fromRGBO(136, 8, 8, 1),
                )
              : Container(),
        ),
      ]),
    );
  }
}
