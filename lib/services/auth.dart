import 'package:chatapp/helper/database.dart';
import 'package:chatapp/helper/shared.dart';
import 'package:chatapp/modal/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final Database database = Database();
  final Helper helper = Helper();
  //final GoogleSignIn _googleSignIn = GoogleSignIn();

  UserM _user(User us) {
    return us != null ? UserM(userId: us.uid) : null;
  }

  // Future signinwithemail(String email, String password) async {
  //   try {
  //     UserCredential userCredential = await firebaseAuth
  //         .signInWithEmailAndPassword(email: email, password: password);
  //     User user = await userCredential.user;
  //     return _user(user);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future signinwithgoogle() async {
  //   try {
  //     GoogleSignInAccount account = await _googleSignIn.signIn();
  //     GoogleSignInAuthentication authentication = await account.authentication;
  //     AuthCredential credential = GoogleAuthProvider.credential(
  //         accessToken: authentication.accessToken,
  //         idToken: authentication.idToken);

  //     UserCredential duser =
  //         await firebaseAuth.signInWithCredential(credential);
  //     User user = await duser.user;
  //     Helper.username(user.displayName);
  //     Helper.useremail(user.email);
  //     Helper.userdesc("Describe yourself");
  //     Helper.saveduser(true);
  //     debugPrint("${user.displayName}");
  //     database.upload(user.displayName, user.email);
  //     return _user(user);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future resetPassword(String email) async {
  //   try {
  //     return firebaseAuth.sendPasswordResetEmail(email: email);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
