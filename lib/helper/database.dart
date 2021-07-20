import 'package:chatapp/helper/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  upload(String name, String phone) async {
    await firebaseFirestore.collection('users').doc(phone).set({
      "name": name,
      "phone": phone,
      "about": "Tell me something about yourself",
      "photo": ""
    }).catchError((e) {
      print(e.toString());
    });
  }

  update(String name, String about, String photo) async {
    await firebaseFirestore.collection('users').doc(Constants.phone).set({
      "name": name,
      "about": about,
      "photo": photo,
      "phone": Constants.phone,
    }).catchError((e) {
      print(e.toString());
    });
  }

  getuser() async {
    return await firebaseFirestore.collection('users').get();
  }

  getusernamewithphone(String phone) async {
    return await firebaseFirestore
        .collection('users')
        .where("phone", isEqualTo: phone)
        .get();
  }

  chatroom(String id, chatroommap) {
    firebaseFirestore
        .collection('chatroom')
        .doc(id)
        .set(chatroommap)
        .catchError((e) {
      print(e.toString());
    });
  }

  sendmessage(String id, messagemap) {
    firebaseFirestore
        .collection('chatroom')
        .doc(id)
        .collection('chats')
        .add(messagemap)
        .catchError((e) {
      print(e.toString());
    });
  }

  updatetime(String id,String time) {
    firebaseFirestore.collection('chatroom').doc(id).update({"time": time});
  }

  getmessages(String id) async {
    return await firebaseFirestore
        .collection('chatroom')
        .doc(id)
        .collection('chats')
        .orderBy('time2', descending: true)
        .snapshots();
  }

  getRooms(String username) async {
    return await firebaseFirestore
        .collection('chatroom')
        .orderBy("time", descending: true)
        .where("users", arrayContains: username)
        .snapshots();
  }

  deletechatroom(String id) async {
    await firebaseFirestore
        .collection('chatroom')
        .doc(id)
        .collection('chats')
        .get()
        .then((snapshot) {
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    await firebaseFirestore.collection('chatroom').doc(id).delete();
  }

  deletemessage(String id, String id2) async {
    await firebaseFirestore
        .collection('chatroom')
        .doc(id)
        .collection('chats')
        .doc(id2)
        .delete();
  }
}
