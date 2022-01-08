import 'package:cached_network_image/cached_network_image.dart';
import 'package:dr_tech/Components/Alert.dart';
import 'package:dr_tech/Components/CustomBehavior.dart';
import 'package:dr_tech/Config/Converter.dart';
import 'package:dr_tech/Config/Globals.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:dr_tech/Pages/OnlineServices.dart';
import 'package:dr_tech/Pages/Service.dart';
import 'package:dr_tech/Pages/Store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ServicesScreen extends StatefulWidget {
  final slider;
  const ServicesScreen(this.slider);

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CustomBehavior(),
      child: Column(
        children: [
          widget.slider,
          Globals.showNotOriginal()
              ? Container(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    Converter.getRealText(318),
                    style: TextStyle(color: Colors.red),
                    textDirection: LanguageManager.getTextDirection(),
                  ),
                )
              :Container(),
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


    for (var item in servicesApi) {
      print('here_row_item: ${item['name']}');
        if (lastInsert.length < 3) {
          print('here_row < 3: ${item['name']}, lastInsert: ${lastInsert.length}');
          lastInsert.add(createService(item["icon"], Globals.isRtl()? item["name"]: item["name_en"], () {
            if (item["target"].toString() == "0") {
              Navigator.push(context, MaterialPageRoute(builder: (_) => Store()));
              return;
            }
            if (item["target"].toString() == "1") {
              Navigator.push(context, MaterialPageRoute(builder: (_) => OnlineServices()));
              return;
            }
            Navigator.push(context, MaterialPageRoute(
                    builder: (_) => Service(item['id'], Globals.isRtl()? item["name"]: item["name_en"])));
          }, () {Alert.show(context, item['description']);}));
          print('here_row_length: ${rows.length}, lastInsert: ${lastInsert.length}');
        }

      if (lastInsert.length == 1) {
        print('here_row == 1: ${item['name']}');
        lastInsert.add(Container(width: 20,));
        print('here_row_length: ${rows.length}, lastInsert: ${lastInsert.length}');
      }
      if (lastInsert.length == 3) {
        print('here_row == 3: ${item['name']}');
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: LanguageManager.getTextDirection(),
          children: lastInsert,
        ));
        rows.add(Container(height: 20,));
        print('here_row_length: ${rows.length}, lastInsert: ${lastInsert.length}');
        lastInsert = [];
      }
    }
    print('here_length: rows: ${rows.length}, items: ${(servicesApi as List).length}');

    if(rows.length < (servicesApi as List).length){
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        textDirection: LanguageManager.getDirection() ? TextDirection.ltr : TextDirection.rtl,
        children: lastInsert,
      ));
      lastInsert.add(Container(width: 7,));
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
                  child: icon.toString().toLowerCase().contains('svg')
                      ? SvgPicture.network(
                          icon,
                          width: size * 0.2,
                          height: size * 0.2,
                        )
                      : Container()
                  ,
                  decoration: BoxDecoration(
                      image: !icon.toString().toLowerCase().contains('svg')
                          ? DecorationImage(
                        fit: BoxFit.fill,
                              image: CachedNetworkImageProvider(
                                  Globals.correctLink(icon)))
                          : null,
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
                          fontSize: 14,//14
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
  }
}
