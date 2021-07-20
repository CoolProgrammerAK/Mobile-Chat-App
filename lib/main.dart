import 'package:chatapp/screens/chat.dart';
import 'package:chatapp/screens/phone.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userloggedin = false;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    check();
   
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: Color.fromRGBO(255, 255, 247, 1),
            primaryColor: Color.fromRGBO(0, 100, 0, 1),
            fontFamily: 'Roboto',
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: userloggedin ? Chat() : Phone());
  }

  void check() async {
    User user = await firebaseAuth.currentUser;
    if (user == null) {
      setState(() {
        userloggedin = false;
      });
    } else {
      setState(() {
        userloggedin = true;
      });
    }
  }
}
