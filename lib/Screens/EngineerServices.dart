import 'package:cached_network_image/cached_network_image.dart';
import 'package:dr_tech/Components/CustomLoading.dart';
import 'package:dr_tech/Components/RateStars.dart';
import 'package:dr_tech/Config/Converter.dart';
import 'package:dr_tech/Config/Globals.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:dr_tech/Network/NetworkManager.dart';
import 'package:dr_tech/Pages/AddServices.dart';
import 'package:dr_tech/Pages/ServicePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EngineerServices extends StatefulWidget {
  const EngineerServices();

  @override
  _EngineerServicesState createState() => _EngineerServicesState();
}

class _EngineerServicesState extends State<EngineerServices> {
  bool isLoading = false;
  List data = [];

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() {
    setState(() {
      isLoading = true;
    });
    NetworkManager.httpGet(Globals.baseUrl + "user/services", context, (r) {
      setState(() {
        isLoading = false;
      });
      if (r['state'] == true) {
        setState(() {
          data = r['data'];
        });
      }
    }, cashable: true);
  }

  @override
  Widget build(BuildContext context) {
    return getContent();
  }

  Widget getContent() {
    if (isLoading) {
      return Center(
        child: CustomLoading(),
      );
    } else if (data.length == 0) {
      double size = MediaQuery.of(context).size.width * 0.8;
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: SvgPicture.asset(
              "assets/illustration/empty.svg",
              width: size,
              height: size,
            ),
          ),
          Text(
            LanguageManager.getText(251),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 10,
          ),
          Text(
            LanguageManager.getText(252),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 30,
          ),
          getAddButton(),
        ],
      );
    }
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SingleChildScrollView(
          child: Wrap(
            children: data.map((e) => getServiceItem(e)).toList(),
          ),
        ),
        Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.bottomLeft,
            child: getAddButton()),
      ],
    );
  }

  Widget getServiceItem(item) {
    double size = MediaQuery.of(context).size.width * 0.5;
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => ServicePage(item["id"])));
      },
      child: Container(
        width: size,
        padding: EdgeInsets.all(10),
        child: Container(
          child: Column(
            children: [
              Container(
                width: size * 0.8,
                height: size * 0.7,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(Globals.correctLink(item["image"]))),
                    color: Colors.black.withAlpha(20),
                    borderRadius: BorderRadius.circular(10)),
              ),
              Text(
                item['name'].toString(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Converter.hexToColor("#2094CD"),
                    fontWeight: FontWeight.bold),
              ),
              Row(
                textDirection: LanguageManager.getTextDirection(),
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RateStars(
                    15,
                    stars: item['rate'],
                  ),
                  Container(
                    width: 10,
                  ),
                  Text(
                    item['rate'].toString(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Container(
                height: 10,
              )
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 2,
                    spreadRadius: 2)
              ]),
        ),
      ),
    );
  }

  Widget getAddButton() {
    double size = 60;
    return InkWell(
      onTap: () async {
        var results = await Navigator.push(
            context, MaterialPageRoute(builder: (_) => AddServices()));
        if (results == true) {
          load();
        }
      },
      child: Container(
        width: size,
        height: size,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: size * 0.9,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size),
            color: Converter.hexToColor("#344F64")),
      ),
    );
  }
}
