import 'dart:async';

import 'package:dr_tech/Components/Alert.dart';
import 'package:dr_tech/Components/HomeSlider.dart';
import 'package:dr_tech/Components/NavBar.dart';
import 'package:dr_tech/Components/NavBarEngineer.dart';
import 'package:dr_tech/Config/Converter.dart';
import 'package:dr_tech/Models/DatabaseManager.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:dr_tech/Models/UserManager.dart';
import 'package:dr_tech/Pages/Conversations.dart';
import 'package:dr_tech/Pages/Orders.dart';
import 'package:dr_tech/Pages/Subscription.dart';
import 'package:dr_tech/Screens/EngineerServices.dart';
import 'package:dr_tech/Screens/MainScreen.dart';
import 'package:dr_tech/Screens/NotificationsScreen.dart';
import 'package:dr_tech/Screens/ProfileScreen.dart';
import 'package:dr_tech/Screens/ServicesScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Home extends StatefulWidget {
  final page;
  const Home({this.page});

  @override
  State<Home> createState() => UserManager.currentUser("type") == "ENGINEER"
      ? _HomeEngineerState()
      : _HomeState();
}

class _HomeEngineerState extends State<Home> {
  int iScreenIndex = 0;
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
                  // [249, 250, 35, 45, 46][iScreenIndex]),
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
            }),
          )
        ],
      ),
    );
  }
}

class _HomeState extends State<Home> {
  String name = "", email = "",nameUserTxt = UserManager.nameUser("name").split(" ")[0];
  int iScreenIndex = 0;
  bool isOpenMessage = false;

  HomeSlider homeSlider = HomeSlider();
  @override
  void initState() {
    if (widget.page != null) iScreenIndex = widget.page;
    Timer(Duration(seconds: 3), () {
      setState(() {
        isOpenMessage = true;
      });
    });
    Timer(Duration(seconds: 10), () {
      setState(() {
        isOpenMessage = false;
      });
    });
    if (UserManager.nameUser("name") == "") {
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
                        name = r;
                      },
                      textDirection: LanguageManager.getTextDirection(),
                      textAlign: LanguageManager.getDirection()
                          ? TextAlign.right
                          : TextAlign.left,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: LanguageManager.getText(33)),
                    ),
                  ),
                  Container(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Converter.hexToColor("#F2F2F2")),
                    child: TextField(
                      onChanged: (r) {
                        email = r;
                      },
                      textDirection: LanguageManager.getTextDirection(),
                      textAlign: LanguageManager.getDirection()
                          ? TextAlign.right
                          : TextAlign.left,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: LanguageManager.getText(282)),
                    ),
                  ),
                  Container(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      if (name.length < 3) return;
                      if(email.length < 3) return;
                      Navigator.pop(context);
                      Alert.startLoading(context);
                      UserManager.update("name", name, (status) {
                        DatabaseManager.save("name", name);
                        Alert.endLoading();
                        if (status == true) {
                          setState(() {
                            nameUserTxt = name;
                          });
                        }
                      });
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                decoration:
                BoxDecoration(color: Converter.hexToColor("#2094cd")),
                padding:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                  EdgeInsets.only(left: 25, right: 25, bottom: 10, top: 25),
                  child:
                  iScreenIndex != 0 ?
                  Text(
                    LanguageManager.getText(
                        [43, 44, 45, 46][iScreenIndex]),
                    // [43, 45, 46][iScreenIndex]),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                      : Row(
                    textDirection: LanguageManager.getTextDirection(),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LanguageManager.getText(32) +
                            " - " + nameUserTxt,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      InkWell(
                        onTap: () {
                          var cities = DatabaseManager
                              .liveDatabase['country_cities'];
                          if (cities == null || cities == "") return;
                          for (var i = 0; i < cities.length; i++) {
                            cities[i]['text'] = cities[i]['name'];
                          }
                          Alert.show(context, cities,
                              type: AlertType.SELECT, onSelected: (item) {
                                DatabaseManager.liveDatabase["city"] = item;
                              });
                        },
                        child: Row(
                          textDirection:
                          LanguageManager.getTextDirection(),
                          children: [
                            Icon(
                              FlutterIcons.location_on_mdi,
                              size: 18,
                              color: Colors.white,
                            ),
                            Container(
                              width: 5,
                            ),
                            Text(
                              DatabaseManager.liveDatabase["city"] != null
                                  ? DatabaseManager.liveDatabase["city"]
                              ["name"]
                                  .toString()
                                  : "",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.white),
                            ),
                            Container(
                              width: 5,
                            ),
                            Icon(
                              FlutterIcons.chevron_down_ent,
                              size: 18,
                              color: Colors.white,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: [
                    MainScreen(homeSlider),
                    ServicesScreen(homeSlider),
                    NotificationsScreen(),
                    ProfileScreen(() {
                      setState(() {});
                    })
                  ][iScreenIndex]),
              AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  height: isOpenMessage ? 50 : 0,
                  decoration:
                  BoxDecoration(color: Converter.hexToColor("#707070")),
                  child: ScrollConfiguration(
                      behavior: ScrollBehavior(),
                      child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(12),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                textDirection: LanguageManager.getTextDirection(),
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    LanguageManager.getText(41),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => Subscription()));
                                    },
                                    child: Text(
                                      LanguageManager.getText(42),
                                      style: TextStyle(
                                          color: Converter.hexToColor("#DBE208"),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isOpenMessage = false;
                                      });
                                    },
                                    child: Icon(
                                      FlutterIcons.close_ant,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  )
                                ]),
                          )))),
              Container(
                height: 70,
              )
            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: NavBar(onUpdate: (index) {
              setState(() {
                iScreenIndex = index;
              });
            }),
          )
        ],
      ),
    );
  }
}
