import 'package:dr_tech/Config/Converter.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavBarEngineer extends StatefulWidget {
  final onUpdate;
  final page;
  const NavBarEngineer({this.onUpdate,this.page});

  @override
  _NavBarEngineerState createState() => _NavBarEngineerState();
}

class _NavBarEngineerState extends State<NavBarEngineer> {
  Color activeColor;
  int iSelectedIndex = 0;
  double homeIconSize;
  @override
  void initState() {
    activeColor = Converter.hexToColor("#2094CD");
    if(widget.page != null) iSelectedIndex = widget.page;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    homeIconSize = MediaQuery.of(context).size.width * 0.35;
    if (homeIconSize > 160) homeIconSize = 160;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: homeIconSize * 0.5,
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(10),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, -1))
          ]),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 10),
          height: homeIconSize * 0.5,
          child: Row(
            textDirection: LanguageManager.getTextDirection(),
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Home
              createIcon("services", 249, () {
                setState(() {
                  iSelectedIndex = 0;
                });
                widget.onUpdate(iSelectedIndex);
              }, iSelectedIndex == 0, isBig: true),

              createIcon("chat", 250, () {
                setState(() {
                  iSelectedIndex = 1;
                });
                widget.onUpdate(iSelectedIndex);
              }, iSelectedIndex == 1),

              createIcon("checklist", 35, () {
                setState(() {
                  iSelectedIndex = 2;
                });
                widget.onUpdate(iSelectedIndex);
              }, iSelectedIndex == 2),
              createIcon("bell", 45, () {
                setState(() {
                  iSelectedIndex = 3;
                });
                widget.onUpdate(iSelectedIndex);
              }, iSelectedIndex == 3),
              createIcon("menu", 46, () {
                setState(() {
                  iSelectedIndex = 4;
                });
                widget.onUpdate(iSelectedIndex);
              }, iSelectedIndex == 4),
            ],
          ),
        ),
      ],
    );
  }

  Widget createIcon(icon, text, onTap, isActive, {isBig = false}) {
    if (!isBig)
      return InkWell(
          onTap: onTap,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: homeIconSize * 0.15,
                height: homeIconSize * 0.15,
                child: SvgPicture.asset(
                  "assets/icons/$icon.svg",
                  color: isActive ? activeColor : Colors.grey,
                  fit: BoxFit.contain,
                )),
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Text(
                LanguageManager.getText(text),
                style: TextStyle(
                    color: isActive ? activeColor : Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            )
          ]));
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Column(
          textDirection: LanguageManager.getTextDirection(),
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: homeIconSize * 0.04),
              width: homeIconSize * 0.45,
              height: homeIconSize * 0.45,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/icons/$icon.svg",
                    width: homeIconSize * 0.15,
                    height: homeIconSize * 0.15,
                    color: Colors.white,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Text(
                      LanguageManager.getText(text),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(homeIconSize)),
            ),
          ],
        ),
      ),
    );
  }
}
