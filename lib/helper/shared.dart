import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static String LOGGEDINKEY = "LOGGEDINKEY";
  static String USERKEY = "USERKEY";
  static String EMAILKEY = "EMAILKEY";
  static String ABOUT = "ABOUT";
  static String ID = "ID";
    static String PHOTO = "PHOTO";

  static Future<void> setlog(bool loggedin) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return await sharedPreferences.setBool(LOGGEDINKEY, loggedin);
  }
static Future<void> setid(String loggedin) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(ID, loggedin);
  }
  static Future<void> setusername(String loggedin) async {
   
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(USERKEY, loggedin);
  }

  static Future<void> setuserphone(String loggedin) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(EMAILKEY, loggedin);
  }
 static Future<void> setuserdes(String loggedin) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(ABOUT, loggedin);
  }
  static Future<void> setuserphoto(String loggedin) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(PHOTO, loggedin);
  }
  static Future<bool> getlog() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(LOGGEDINKEY);
  }

  static Future<String> getname() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(USERKEY);
  }

  static Future<String> getphone() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(EMAILKEY);
  }
   static Future<String> getabout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(ABOUT);
  }
  static Future<String> getid() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(ID);
  }
    static Future<String> getphoto() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(PHOTO);
  }
  static Future<bool> clear() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.clear();
  }
}
