import 'package:dr_tech/Components/CustomBehavior.dart';
import 'package:dr_tech/Components/CustomLoading.dart';
import 'package:dr_tech/Config/Converter.dart';
import 'package:dr_tech/Config/Globals.dart';
import 'package:dr_tech/Config/IconsMap.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:dr_tech/Network/NetworkManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Terms extends StatefulWidget {
  const Terms();

  @override
  _TermsState createState() => _TermsState();
}

class _TermsState extends State<Terms> {
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
    NetworkManager.httpGet(Globals.baseUrl + "information/terms", (r) {
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
                        LanguageManager.getText(59),
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
                          children: data.toString().split("\n").map((e) {
                            bool isTitel = e.startsWith("*");
                            return Text(
                              isTitel ? e.replaceFirst("*", "") : e.toString(),
                              textDirection: LanguageManager.getTextDirection(),
                              style: TextStyle(
                                  fontSize: isTitel ? 16 : 14,
                                  fontWeight: isTitel
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isTitel ? Colors.blue : Colors.black),
                            );
                          }).toList(),
                        ),
                      ),
                    ))
        ]));
  }
}
