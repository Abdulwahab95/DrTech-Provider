
import 'package:dr_tech/Components/CustomBehavior.dart';
import 'package:dr_tech/Config/Converter.dart';
import 'package:dr_tech/Config/Globals.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:dr_tech/Pages/OnlineServices.dart';
import 'package:dr_tech/Pages/Service.dart';
import 'package:dr_tech/Pages/Store.dart';
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
    List<Widget> rows = [];
    var servicesApi = Globals.getConfig("services");
    if (servicesApi == "") return Container();
    List<Widget> lastInsert = [];
    var numItemAdd = 0;
    var numItemInactive = 0;
    for (var item in servicesApi) {

      if (item["status"] != "inactive"){
        if (lastInsert.length < 3) {
          print('item: $item');
          lastInsert.add(createService(item["icon"], item["name"], () {
            if (item["target"].toString() == "0") {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Store()));
              return;
            }
            if (item["target"].toString() == "1") {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => OnlineServices()));
              return;
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Service(item['id'], item["name"])));
          }, () {}));
        }

        if (lastInsert.length == 1) {
          print('row1: $item');
          lastInsert.add(Container(width: 20,));
        }
        if (lastInsert.length == 3) {
          numItemAdd += 2;
          print('row: $item');
          rows.add(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: LanguageManager.getTextDirection(),
            children: lastInsert,
          ));
          rows.add(Container(height: 20,));
          lastInsert = [];
        }

      } else numItemInactive++;

    }

    if ((servicesApi.length - numItemInactive) % 2 != 0 && servicesApi.length - numItemInactive - 1 == numItemAdd ){
      lastInsert.insert(0, Container(width: 27,));
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        textDirection: LanguageManager.getTextDirection(),
        children: lastInsert,
      ));
      rows.add(Container(height: 20,));
    }

    return Expanded(
      child: Container(
        child: ListView(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            children: rows),
      ),
    );
  }

  Widget createService(icon, text, onTap, onInfo) {
    var size = MediaQuery.of(context).size.width * 0.4;
    if (size > 200) size = 200;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size,
        height: size * 0.9,
        padding: EdgeInsets.all(7),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha(15),
                  blurRadius: 5,
                  spreadRadius: 1)
            ],
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Center(
                child: Container(
                  width: size * 0.35,
                  height: size * 0.35,
                  alignment: Alignment.center,
                  child: SvgPicture.network(
                    icon,
                    width: size * 0.2,
                    height: size * 0.2,
                  ),
                  decoration: BoxDecoration(
                      color: Converter.hexToColor("#F2F2F2"),
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      Converter.getRealText(text),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13,//14
                          color: Converter.hexToColor("#707070"),
                          fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: onInfo,
                      child: Text(
                        LanguageManager.getText(53),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            color: Converter.hexToColor("#707070"),
                            fontWeight: FontWeight.normal),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );

  // Widget getServices() {
  //   List<Widget> items = [];
  //   items.add(createServices("checklist", 35, () {
  //     Navigator.push(context, MaterialPageRoute(builder: (_) => Orders()));
  //   }));
  //   items.add(createServices("chat", 36, () {
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (_) => Conversations()));
  //   }));
  //   items.add(createServices("product", 37, () {
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (_) => UserProducts()));
  //   }));
  //   items.add(createServices("star", 38, () {
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (_) => UserFavoritProducts()));
  //   }));
  //   items.add(createServices("sharing", 39, () {}));
  //   items.add(createServices("info", 40, () {
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (_) => Subscription()));
  //   }));
  //
  //   items.add(Container(
  //     height: 10,
  //   ));
  //   return Expanded(
  //     child: ScrollConfiguration(
  //         behavior: CustomBehavior(),
  //         child: ListView(
  //           padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
  //           children: items,
  //         )),
  //   );
  // }
  //
  // Widget createServices(icon, titel, onTap) {
  //   var width = MediaQuery.of(context).size.width * 0.9;
  //   if (width > 400) width = 400;
  //   double height = 70;
  //   return Container(
  //     margin: EdgeInsets.only(top: 12),
  //     alignment: Alignment.center,
  //     child: InkWell(
  //       onTap: onTap,
  //       child: Container(
  //         height: height,
  //         width: width,
  //         child: Row(
  //           textDirection: LanguageManager.getTextDirection(),
  //           children: [
  //             Container(
  //               width: 10,
  //             ),
  //             Container(
  //               width: height * 0.8,
  //               height: height * 0.8,
  //               alignment: Alignment.center,
  //               child: SvgPicture.asset(
  //                 "assets/icons/$icon.svg",
  //                 width: height * 0.4,
  //                 height: height * 0.4,
  //               ),
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   color: Converter.hexToColor("#F2F2F2")),
  //             ),
  //             Container(
  //               width: 20,
  //             ),
  //             Expanded(
  //               child: Text(
  //                 LanguageManager.getText(titel),
  //                 textAlign: LanguageManager.getDirection()
  //                     ? TextAlign.right
  //                     : TextAlign.left,
  //                 style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                     color: Converter.hexToColor("#707070")),
  //               ),
  //             )
  //           ],
  //         ),
  //         decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(10),
  //             boxShadow: [
  //               BoxShadow(
  //                   color: Colors.black.withAlpha(20),
  //                   offset: Offset(0, 2),
  //                   blurRadius: 1,
  //                   spreadRadius: 1)
  //             ]),
  //       ),
  //     ),
  //   );
  }
}
