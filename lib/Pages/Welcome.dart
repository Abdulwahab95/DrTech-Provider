import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dr_tech/Config/Converter.dart';
import 'package:dr_tech/Config/Globals.dart';
import 'package:dr_tech/Models/DatabaseManager.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:dr_tech/Models/UserManager.dart';
import 'package:dr_tech/Pages/JoinRequest.dart';
import 'package:flutter/material.dart';

import 'Home.dart';
import 'LiveChat.dart';
import 'Login.dart';
import 'WebBrowser.dart';

class Welcome extends StatefulWidget {
  const Welcome();

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool isInLogoScreen = true;
  ScrollController imagesController = ScrollController();
  ScrollController titelsController = ScrollController();
  ScrollController textsController = ScrollController();
  List<dynamic> welcomePages = [];

  int currentTabIndex = 0;
  double opacity = 0.2;
  @override
  void initState() {
    welcomePages = Globals.getConfig("welcome");
    animationTimer();
    screenTimer();
    super.initState();
  }

  void animationTimer() {
    Timer(Duration(milliseconds: 250), () {
      setState(() {
        opacity = 1;
      });
    });
  }

  void screenTimer() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        DatabaseManager.load("welcome") != true ?isInLogoScreen = false : close();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          isInLogoScreen ? Colors.white : Converter.hexToColor("#2094cd"),
      body: isInLogoScreen ? getLogoPage() : getTutorial(),
    );
  }



  Widget getLogoPage() {
    double size = MediaQuery.of(context).size.width * 0.5;
    return Center(
        child: Container(
            width: size,
            height: size,
            child: AnimatedOpacity(
              opacity: opacity,
              duration: Duration(milliseconds: 750),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    image: DecorationImage(
                        image: AssetImage("assets/images/logo.png"))),
              ),
            )));
  }

  Widget getTutorial() {
    return Column(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.width,
              child: ListView(
                  reverse: LanguageManager.getDirection(),
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  controller: imagesController,
                  children: getImages()),
            ),
          ),
        ),
        Container(
          height: 40,
          child: ListView(
              reverse: LanguageManager.getDirection(),
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: titelsController,
              children: getTitels()),
        ),
        Container(
          height: 150,
          child: ListView(
              reverse: LanguageManager.getDirection(),
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: textsController,
              children: getTexts()),
        ),
        Row(
          textDirection: LanguageManager.getTextDirection(),
          children: [
            InkWell(
              onTap: close,
              child: Container(
                padding:
                    EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                child: Text(
                  LanguageManager.getText(2),
                  style: TextStyle(
                      color: currentTabIndex < welcomePages.length - 1
                          ? Colors.white
                          : Colors.transparent),
                ),
              ),
            ),
            Expanded(
                child: Container(
              child: Row(
                textDirection: LanguageManager.getTextDirection(),
                mainAxisAlignment: MainAxisAlignment.center,
                children: getDots(),
              ),
            )),
            InkWell(
              onTap: () {
                setState(() {
                  currentTabIndex++;

                  if (currentTabIndex >= welcomePages.length) {
                    close();
                    return;
                  }

                  double nextStepOffset =
                      MediaQuery.of(context).size.width * currentTabIndex;
                  imagesController.animateTo(nextStepOffset,
                      duration: Duration(milliseconds: 150),
                      curve: Curves.easeInOut);
                  titelsController.animateTo(nextStepOffset,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                  textsController.animateTo(nextStepOffset,
                      duration: Duration(milliseconds: 450),
                      curve: Curves.easeInOut);
                });
              },
              child: Container(
                padding:
                    EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: getBorder(),
                    color: Converter.hexToColor("#344f64")),
                child: Text(
                  LanguageManager.getText(
                      currentTabIndex < welcomePages.length - 1 ? 3 : 4),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 20,
        )
      ],
    );
  }

  List<Widget> getDots() {
    List<Widget> dots = [];
    for (var i = 0; i < welcomePages.length; i++) {
      dots.add(AnimatedContainer(
        margin: EdgeInsets.only(left: 5, right: 5),
        width: currentTabIndex == i ? 17 : 7,
        height: 7,
        duration: Duration(milliseconds: 280),
        decoration: BoxDecoration(
            color: currentTabIndex == i
                ? Colors.white
                : Converter.hexToColor("#344f64"),
            borderRadius: BorderRadius.circular(20)),
      ));
    }
    return dots;
  }

  List<Widget> getTitels() {
    List<Widget> titels = [];
    for (var item in welcomePages) {
      titels.add(Container(
        width: MediaQuery.of(context).size.width,
        child: Text(
          item['titel'],
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ));
    }
    return titels;
  }

  List<Widget> getTexts() {
    List<Widget> texts = [];
    for (var item in welcomePages) {
      texts.add(Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.15,
            right: MediaQuery.of(context).size.width * 0.15),
        child: Text(
          item['body'],
          style: TextStyle(
              fontSize: 14, color: Colors.white, fontWeight: FontWeight.normal),
          textAlign: TextAlign.center,
        ),
      ));
    }
    return texts;
  }

  List<Widget> getImages() {
    List<Widget> images = [];
    double size = MediaQuery.of(context).size.width * 0.8;
    for (var item in welcomePages) {
      images.add(Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size * 0.12),
              color: Colors.white,
              image: DecorationImage(
                  image: CachedNetworkImageProvider(Globals.correctLink(item['image'])))),
        ),
      ));
    }

    return images;
  }

  BorderRadius getBorder() {
    if (LanguageManager.getDirection())
      return BorderRadius.only(
          topRight: Radius.circular(50), bottomRight: Radius.circular(50));

    return BorderRadius.only(
        topLeft: Radius.circular(50), bottomLeft: Radius.circular(50));
  }

  void close() {
    DatabaseManager.save("welcome", true);
    print('heree: identity ${UserManager.currentUser("identity")}');
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (c) =>
                Globals.checkUpdate() && Globals.getWebViewUrl().isNotEmpty
                    ? WebBrowser(Globals.getWebViewUrl(), '')
                    :
                UserManager.currentUser("id").isNotEmpty
                    ?  UserManager.currentUser("identity").isEmpty? JoinRequest() //
                    : Globals.isOpenFromNotification? LiveChat(Globals.currentConversationId) : Home()
                    : Login())
    );
  }
}