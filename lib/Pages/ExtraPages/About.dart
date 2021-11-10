import 'package:dr_tech/Components/CustomBehavior.dart';
import 'package:dr_tech/Components/CustomLoading.dart';
import 'package:dr_tech/Config/Converter.dart';
import 'package:dr_tech/Config/Globals.dart';
import 'package:dr_tech/Config/IconsMap.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:dr_tech/Network/NetworkManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class About extends StatefulWidget {
  const About();

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  bool isLoading = false;
  var data;
  @override
  void initState() {
    load();
    super.initState();
  }

  void load() {
    setState(() {
      isLoading = true;
    });
    NetworkManager.httpGet(Globals.baseUrl + "about",  context, (r) { // information/about
      setState(() {
        isLoading = false;
        data = r['data'];
      });
    }, cashable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          Container(
              decoration: BoxDecoration(color: Converter.hexToColor("#2094cd")),
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.only(left: 25, right: 25, bottom: 10, top: 25),
                  child: Row(
                    textDirection: LanguageManager.getTextDirection(),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 20,
                          child: Icon(
                            LanguageManager.getDirection()
                                ? FlutterIcons.chevron_right_fea
                                : FlutterIcons.chevron_left_fea,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        LanguageManager.getText(60),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Container(
                        width: 20,
                      ),
                    ],
                  ))),
          Expanded(
              child: isLoading
                  ? Center(
                      child: CustomLoading(),
                    )
                  : ScrollConfiguration(
                      behavior: CustomBehavior(),
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: ListView(
                          children: [
                            Text(
                              LanguageManager.getText(73),
                              textDirection: LanguageManager.getTextDirection(),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                            Text(
                              data.toString(),
                              textDirection: LanguageManager.getTextDirection(),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            ),
                            Container(
                              height: 30,
                            ),
                            Text(
                              LanguageManager.getText(74),
                              textDirection: LanguageManager.getTextDirection(),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                            ...getContectInfo()
                          ],
                        ),
                      ),
                    ))
        ]));
  }

  List<Widget> getContectInfo() {
    List<Widget> contects = [];
    for (var item in Globals.getConfig("contects")) {
      contects.add(Container(
        margin: EdgeInsets.only(bottom: 15),
        child: Row(
          textDirection: LanguageManager.getTextDirection(),
          children: [
            Row(
              textDirection: LanguageManager.getTextDirection(),
              children: [
                Icon(
                  IconsMap.from[item['icon']],
                  size: 18,
                  color: Converter.hexToColor("#6D727B"),
                ),
                Container(
                  width: 20,
                ),
                Text(
                  Converter.getRealText(item['name']),
                  textDirection: LanguageManager.getTextDirection(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Converter.hexToColor("#6D727B"),
                  ),
                ),
              ],
            ),
            Container(
              width: 40,
            ),
            SelectableText(
              Converter.getRealText(item['contect']),
              textDirection: LanguageManager.getTextDirection(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Converter.hexToColor("#6D727B"),
              ),
            )
          ],
        ),
      ));
    }
    return contects;
  }
}
