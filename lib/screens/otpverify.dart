import 'dart:async';
import 'package:chatapp/helper/database.dart';
import 'package:chatapp/helper/shared.dart';
import 'package:chatapp/screens/chat.dart';
import 'package:chatapp/screens/phone_info.dart';
import 'package:chatapp/widgets/loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OTp extends StatefulWidget {
  final String phone;
  OTp({Key key, this.phone}) : super(key: key);

  @override
  _OTpState createState() => _OTpState();
}

class _OTpState extends State<OTp> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final TextEditingController otp = TextEditingController();
  final TextEditingController error = TextEditingController();
  final key = GlobalKey<FormState>();
  QuerySnapshot querySnapshot;
  bool isloading = false;
  bool verify = false;
  bool showsent = false;
  bool checking = false;
  bool showerror = false;
  String errortext;
  final Helper helper = Helper();
  final Database database = Database();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: Color.fromRGBO(255, 255, 250, 1),
    borderRadius: BorderRadius.circular(6.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
          title: Text(
        "LOG IN",
        style: TextStyle(
            fontFamily: 'Raleway', fontSize: 16, fontWeight: FontWeight.w600),
      )),
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height - 50,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    margin: EdgeInsets.only(top: 20),
                    alignment: Alignment.topLeft,
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "OTP sent to ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                                color: Colors.black45),
                          ),
                          TextSpan(
                              text: "${widget.phone}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Colors.black54)),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 22,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: Column(
                    children: [
                      Text(
                        "Enter the OTP you received",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.black45),
                      ),
                      SizedBox(height: 10),
                      PinPut(
                        fieldsCount: 6,
                        textStyle: const TextStyle(
                            fontSize: 22.0, color: Colors.black),
                        eachFieldWidth: 40.0,
                        eachFieldHeight: 45.0,
                        focusNode: _pinPutFocusNode,
                        controller: _pinPutController,
                        submittedFieldDecoration: pinPutDecoration,
                        selectedFieldDecoration: pinPutDecoration,
                        followingFieldDecoration: pinPutDecoration,
                        pinAnimationType: PinAnimationType.fade,
                        onSubmit: (pin) async {
                          try {
                            setState(() {
                              checking = true;
                            });
                            await FirebaseAuth.instance
                                .signInWithCredential(
                                    PhoneAuthProvider.credential(
                                        verificationId: _verificationCode,
                                        smsCode: pin))
                                .then((value) async {
                              if (value.user != null) {
                                setState(() {
                                  checking = false;
                                });
                                database
                                    .getusernamewithphone(widget.phone)
                                    .then((v) {
                                  if (v.docs.length == 0) {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return PhoneInfo(
                                          phone: widget.phone,
                                          uid: value.user.uid);
                                    }));
                                  } else {
                                    querySnapshot = v;
                                    Helper.setusername(
                                        querySnapshot.docs[0].get("name"));
                                    Helper.setuserdes(
                                        querySnapshot.docs[0].get("about"));
                                    Helper.setuserphoto(
                                        querySnapshot.docs[0].get("photo"));
                                    Helper.setlog(true);
                                    Helper.setuserphone(widget.phone);
                                    Helper.setid(widget.phone);
                                    setState(() {});
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return Chat();
                                    }));
                                  }
                                });
                              }
                            });
                          } catch (e) {
                            setState(() {
                              checking = false;
                              _pinPutController.text = "";
                            });

                            FocusScope.of(context).unfocus();

                            Fluttertoast.showToast(
                                msg: "Invalid OTP",
                                backgroundColor: Color(0xffe5e5e5),
                                textColor: Colors.black);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                //   MaterialButton(
                //       minWidth: MediaQuery.of(context).size.width,
                //       padding: EdgeInsets.symmetric(vertical: 16),
                //       color: Color(0xff007ef4),
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(20)),
                //       onPressed: () {},
                //       child: Text("Submit", style: textStyle())),
              ])),
        ),
        Positioned(
          child: isloading
              ? Loader(
                  text: "Loading...",
                )
              : Container(),
        ),
        Positioned(
          child: showsent
              ? Loader(
                  text: "Sending OTP",
                )
              : Container(),
        ),
        Positioned(
          child: verify
              ? Loader(
                  text: "Verifying...",
                )
              : Container(),
        ),
        Positioned(
          child: checking
              ? Loader(
                  text: "Checking...",
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

  _verifyphone() async {
    setState(() {
      isloading = false;
      errortext = "";
      showerror = false;
      showsent = false;
      verify = true;
    });
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+91 ${widget.phone}',
          verificationCompleted: (PhoneAuthCredential ph) async {},
          verificationFailed: (FirebaseAuthException e) {
            setState(() {
              isloading = false;
              showerror = true;
              showsent = false;
              errortext = e.message;
              verify = false;
            });
          },
          codeSent: (String verficationID, int resendToken) {
            setState(() {
              _verificationCode = verficationID;
              isloading = false;
              verify = false;
              errortext = "";
              showerror = false;

              showsent = true;
            });
            Future.delayed(const Duration(seconds: 5), () {
              setState(() {
                showsent = false;
              });
            });
          },
          codeAutoRetrievalTimeout: (String verficationID) {
            setState(() {
              _verificationCode = verficationID;
            });
          },
          timeout: Duration(minutes: 1));
    } catch (e) {
      errortext = e.toString();
    }
  }

  @override
  void initState() {
    super.initState();

    _verifyphone();
  }
}
