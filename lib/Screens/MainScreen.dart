import 'package:dr_tech/Components/CustomBehavior.dart';
import 'package:dr_tech/Config/Converter.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:dr_tech/Pages/Conversations.dart';
import 'package:dr_tech/Pages/Orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends StatefulWidget {
  final slider;
  const MainScreen(this.slider);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CustomBehavior(),
      child: Column(
        children: [
          widget.slider,
          getServices(),
        ],
      ),
    );
  }

  Widget getServices() {
    List<Widget> items = [];
    items.add(createServices("checklist", 35, () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => Orders()));
    }));
    items.add(createServices("chat", 36, () {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => Conversations()));
    }));
    // items.add(createServices("product", 37, () {
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (_) => UserProducts()));
    // }));
    // items.add(createServices("star", 38, () {
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (_) => UserFavoritProducts()));
    // }));
    // items.add(createServices("sharing", 39, () {}));
    // // items.add(createServices("info", 40, () {
    // //   Navigator.push(
    // //       context, MaterialPageRoute(builder: (_) => Subscription()));
    // // }));

    items.add(Container(
      height: 10,
    ));
    return Expanded(
      child: ScrollConfiguration(
          behavior: CustomBehavior(),
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            children: items,
          )),
    );
  }

  Widget createServices(icon, titel, onTap) {
    var width = MediaQuery.of(context).size.width * 0.9;
    if (width > 400) width = 400;
    double height = 70;
    return Container(
      margin: EdgeInsets.only(top: 12),
      alignment: Alignment.center,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height,
          width: width,
          child: Row(
            textDirection: LanguageManager.getTextDirection(),
            children: [
              Container(
                width: 10,
              ),
              Container(
                width: height * 0.8,
                height: height * 0.8,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  "assets/icons/$icon.svg",
                  width: height * 0.4,
                  height: height * 0.4,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Converter.hexToColor("#F2F2F2")),
              ),
              Container(
                width: 20,
              ),
              Expanded(
                child: Text(
                  LanguageManager.getText(titel),
                  textAlign: LanguageManager.getDirection()
                      ? TextAlign.right
                      : TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Converter.hexToColor("#707070")),
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withAlpha(20),
                    offset: Offset(0, 2),
                    blurRadius: 1,
                    spreadRadius: 1)
              ]),
        ),
      ),
    );
  }
}
