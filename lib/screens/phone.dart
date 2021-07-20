
import 'package:chatapp/screens/otpverify.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:chatapp/widgets/loader.dart';
import 'package:flutter/material.dart';

class Phone extends StatefulWidget {
  Phone({Key key}) : super(key: key);

  @override
  _PhoneState createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  final TextEditingController phone = TextEditingController();
  final TextEditingController error = TextEditingController();
  final key = GlobalKey<FormState>();
  
  bool isloading = false;
 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 50,
            width: MediaQuery.of(context).size.height - 90,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 25),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/chat.png',
                  width: 220,
                  height: 220.0,
                ),
                Form(
                  key: key,
                  child: Column(
                    children: [
                      Container(
                        child: TextFormField(
                            controller: phone,
                            style: textStyle(),
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            validator: (val) {
                              return val.length < 10
                                  ? "Enter valid phone number"
                                  : null;
                            },
                            decoration: InputDecoration(
                              hintText: "Enter Phone number",
                              prefixStyle: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                              prefixText: "+91 ",
                              counterStyle: TextStyle(color: Colors.black45),
                              filled: true,
                              fillColor: Colors.white30,
                              errorStyle: TextStyle(color: Colors.redAccent),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                            )),
                      ),
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
                    onPressed: () {
                      if (key.currentState.validate()) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return OTp(
                            phone: phone.text,
                          );
                        }));
                      }
                    },
                    child: Text("Continue",
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
      ]),
    );
  }
}
