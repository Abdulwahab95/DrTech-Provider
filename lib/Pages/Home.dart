import 'package:dr_tech/Components/NavBarEngineer.dart';
import 'package:dr_tech/Config/Converter.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
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

  @override
  void initState() {
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
