import 'dart:async';

import 'package:dr_tech/Components/Alert.dart';
import 'package:dr_tech/Components/NavBarEngineer.dart';
import 'package:dr_tech/Config/Converter.dart';
import 'package:dr_tech/Models/DatabaseManager.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:dr_tech/Models/UserManager.dart';
import 'package:dr_tech/Pages/Conversations.dart';
import 'package:dr_tech/Pages/Orders.dart';
import 'package:dr_tech/Screens/EngineerServices.dart';
import 'package:dr_tech/Screens/NotificationsScreen.dart';
import 'package:dr_tech/Screens/ProfileScreen.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final page;
  const Home({this.page});

  @override
  State<Home> createState() => _HomeEngineerState();
}

class _HomeEngineerState extends State<Home> {
  int iScreenIndex = 0;
  Map<String, String> body = {};

  @override
  void initState() {

    if (UserManager.currentUser("about") == "") {
      Timer(Duration(milliseconds: 200), () {
        Alert.show(
            context,
            Container(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Converter.hexToColor("#F2F2F2")),
                    child: TextField(
                      onChanged: (r) {
                        body['about'] = r;
                      },
                      textDirection: LanguageManager.getTextDirection(),
                      textAlign: LanguageManager.getDirection()
                          ? TextAlign.right
                          : TextAlign.left,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: LanguageManager.getText(330)),
                    ),
                  ),
                  Container(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      if (UserManager.currentUser("about") == ""  &&  (body['about'] == null || (body['about'] != null && body['about'].length < 3))) return;
                      // Navigator.pop(context);
                      Alert.startLoading(context);
                      UserManager.update("about", body['about'], context ,(r) {
                        // DatabaseManager.save("name", name);
                        Alert.endLoading();
                        if (r['state'] == true) {
                          Navigator.pop(context);
                          DatabaseManager.save("about", body['about']);
                        }});
                    },
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      child: Text(
                        LanguageManager.getText(34),
                        style: TextStyle(color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withAlpha(15),
                                spreadRadius: 2,
                                blurRadius: 2)
                          ],
                          borderRadius: BorderRadius.circular(8),
                          color: Converter.hexToColor("#344f64")),
                    ),
                  ),
                ],
              ),
            ),
            type: AlertType.WIDGET);
      });
    }

    if (widget.page != null) iScreenIndex = widget.page;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Converter.hexToColor("#2094cd")),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    EdgeInsets.only(left: 25, right: 25, bottom: 10, top: 25),
                child: Text(
                  LanguageManager.getText(
                      [249, 250, 35, 45, 46][iScreenIndex]),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
          ),
          Expanded(
              child: [
            EngineerServices(),
            Conversations(noheader: true),
            Orders(noheader: true),
            NotificationsScreen(),
            ProfileScreen(() {
              setState(() {});
            })
          ][iScreenIndex]),
          Container(
            alignment: Alignment.bottomCenter,
            child: NavBarEngineer(onUpdate: (index) {
              setState(() {
                iScreenIndex = index;
              });
            }, page: iScreenIndex),
          )
        ],
      ),
    );
  }
}
