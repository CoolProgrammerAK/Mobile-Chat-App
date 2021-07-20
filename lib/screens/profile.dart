import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String photo, name, about, phone;
  const Profile({Key key, this.photo, this.name, this.about, this.phone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: appbar(context, "Profile"),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // Avatar
                  Container(
                    child: Center(
                        child: (photo != ''
                            ? Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
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
                                      name != ""
                                          ? name.substring(0, 1).toUpperCase()
                                          : "",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w300)),
                                ),
                              ))),
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
                        margin:
                            EdgeInsets.only(left: 30.0, bottom: 5.0, top: 10.0),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.grey[700]))),
                        child: Text(
                          "${name}",
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 16),
                        ),
                        // ),
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
                        margin:
                            EdgeInsets.only(left: 30.0, top: 30.0, bottom: 5.0),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.grey[700]))),
                        child: Text(
                          "${about}",
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 16),
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
                        margin:
                            EdgeInsets.only(left: 30.0, top: 30.0, bottom: 5.0),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.grey[700]))),
                        child: Text(
                          "${phone}",
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 16),
                        ),
                        // ),
                        margin: EdgeInsets.only(left: 30.0, right: 30.0),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ],
              ),
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
            ),

            // Loading
          ],
        ),
      ),
    );
    ;
  }
}
