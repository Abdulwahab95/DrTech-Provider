import 'package:cached_network_image/cached_network_image.dart';
import 'package:dr_tech/Components/CustomLoading.dart';
import 'package:dr_tech/Components/SplashEffect.dart';
import 'package:dr_tech/Config/Converter.dart';
import 'package:dr_tech/Config/Globals.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:dr_tech/Network/NetworkManager.dart';
import 'package:dr_tech/Pages/AddProduct.dart';
import 'package:dr_tech/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Components/Alert.dart';
import '../Pages/ProductDetails.dart';


class EngineerProducts extends StatefulWidget {
  const EngineerProducts();

  @override
  _EngineerProductsState createState() => _EngineerProductsState();
}

class _EngineerProductsState extends State<EngineerProducts> {
  bool isLoading = false;
  List data = [];

  @override
  void initState() {
    print('here_infoBody $data');
    Globals.reloadPageEngineerServices = () {
      if (mounted) load();
    };
    load();
    super.initState();
  }

  var isFirstLoad = true;
  void load() {
    if(isLoading) return;
    setState(() {
      isLoading = true;
    });

    NetworkManager.httpGet(Globals.baseUrl + "provider/products",  context, (r) { // user/services
      setState(() {
        isLoading = false;
      });
      if (r['state'] == true) {
        data = r['data'];
        setState(() {});
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
          child: Container(
            padding: EdgeInsets.only(bottom: 50),
            child: Wrap(
              children: data.map((e) => getServiceItem(e)).toList(), // createProductItem
            ),
          ),
        ),
        Container(
            padding: EdgeInsets.all(10),
            alignment: Globals.isRtl()?Alignment.bottomLeft:Alignment.bottomRight,
            child: getAddButton()),
      ],
    );
  }

  Widget createProductItem(item) {
    double size = 120;
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 0),
      padding: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 2),
                color: Colors.black.withAlpha(20),
                spreadRadius: 2,
                blurRadius: 4)
          ]),
      child: Stack(
        children: [
          Row(
            textDirection: LanguageManager.getTextDirection(),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                textDirection: LanguageManager.getTextDirection(),
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: size,
                    height: size,
                    margin: EdgeInsets.only(left: 15, right: 15),
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 30,
                      width: 70,
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.center,
                      child: Text(
                        LanguageManager.getText(
                            item['active'] == true ? 167 : 168),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      decoration: BoxDecoration(
                          color: Converter.hexToColor(
                              item['active'] == true ? "#2094CD" : "#FF0000"),
                          borderRadius: LanguageManager.getDirection()
                              ? BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15))
                              : BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15))),
                    ),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                            CachedNetworkImageProvider(Globals.correctLink((item['images'] as List).isEmpty? '/images/avatars/default.png' : item['images'][0]))),
                        borderRadius: BorderRadius.circular(7),
                        color: Converter.hexToColor("#F2F2F2")),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  textDirection: LanguageManager.getTextDirection(),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      textDirection: LanguageManager.getTextDirection(),
                      children: [
                        Expanded(
                          child: Text(
                            item["name"].toString(),
                            textDirection: LanguageManager.getTextDirection(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Converter.hexToColor("#2094CD")),
                          ),
                        ),
                        Container(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              // opendOptions = item["id"];
                            });
                          },
                          child: Icon(
                            FlutterIcons.dots_vertical_mco,
                            size: 26,
                            color: Converter.hexToColor("#707070"),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      textDirection: LanguageManager.getTextDirection(),
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            textDirection: LanguageManager.getTextDirection(),
                            children: [
                              Text(
                                item["price"].toString(),
                                textDirection:
                                LanguageManager.getTextDirection(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Converter.hexToColor("#2094CD")),
                              ),
                              Container(
                                width: 5,
                              ),
                              Text(
                                Globals.getUnit(),
                                textDirection:
                                LanguageManager.getTextDirection(),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Converter.hexToColor("#2094CD")),
                              )
                            ],
                          ),
                          padding: EdgeInsets.only(
                              top: 2, bottom: 2, right: 10, left: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Converter.hexToColor("#F2F2F2")),
                        )
                      ],
                    ),
                    // Wrap(
                    //   textDirection: LanguageManager.getTextDirection(),
                    //   crossAxisAlignment: WrapCrossAlignment.start,
                    //   children: [
                    //     createInfoIcon(FlutterIcons.md_color_palette_ion,
                    //         item['color'].toString()),
                    //     createInfoIcon(
                    //       FlutterIcons.smartphone_fea,
                    //       LanguageManager.getText(
                    //           item['state'] == 'USED' ? 143 : 142),
                    //     ),
                    //     createInfoIcon(FlutterIcons.location_on_mdi,
                    //         item['location'].toString()),
                    //   ],
                    // ),
                    Container(
                      height: 15,
                    ),
                  ],
                ),
              )
            ],
          ),
          // opendOptions != item["id"]
          //     ? Container()
          //     : GestureDetector(
          //   onTap: () {
          //     setState(() {
          //       opendOptions = null;
          //     });
          //   },
          //   child: Container(
          //     color: Colors.transparent,
          //     height: size,
          //     alignment: Alignment.topLeft,
          //     child: Container(
          //       padding: EdgeInsets.all(7),
          //       width: 140,
          //       child: Column(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           InkWell(
          //             onTap: () {
          //               setState(() {
          //                 opendOptions = null;
          //               });
          //               editProduct(item['id']);
          //             },
          //             child: Row(
          //               textDirection: LanguageManager.getTextDirection(),
          //               children: [
          //                 Icon(
          //                   FlutterIcons.pencil_ent,
          //                   color: Colors.grey,
          //                   size: 20,
          //                 ),
          //                 Container(
          //                   width: 10,
          //                 ),
          //                 Text(
          //                   LanguageManager.getText(170),
          //                   style: TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                       fontSize: 15,
          //                       color: Colors.grey),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           Container(
          //             margin: EdgeInsets.only(top: 5, bottom: 5),
          //             height: 1,
          //             color: Colors.grey,
          //           ),
          //           InkWell(
          //             onTap: () {
          //               setState(() {
          //                 opendOptions = null;
          //               });
          //               deleteProduct(item['id']);
          //             },
          //             child: Row(
          //               textDirection: LanguageManager.getTextDirection(),
          //               children: [
          //                 Icon(
          //                   FlutterIcons.trash_faw,
          //                   color: Colors.grey,
          //                   size: 20,
          //                 ),
          //                 Container(
          //                   width: 10,
          //                 ),
          //                 Text(
          //                   LanguageManager.getText(169),
          //                   style: TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                       fontSize: 15,
          //                       color: Colors.grey),
          //                 ),
          //               ],
          //             ),
          //           )
          //         ],
          //       ),
          //       decoration: BoxDecoration(
          //           boxShadow: [
          //             BoxShadow(
          //                 color: Colors.black.withAlpha(20),
          //                 spreadRadius: 2,
          //                 blurRadius: 2)
          //           ],
          //           borderRadius: BorderRadius.circular(10),
          //           color: Converter.hexToColor("#F2F2F2")),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget getServiceItem(item) {
    double size = MediaQuery.of(context).size.width * 0.5;
    return InkWell(
      onTap: () async{
        await Navigator.push(
            context, MaterialPageRoute(builder: (_) => ProductDetails(item))).then((value) {
          load();
        });
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
                        image: CachedNetworkImageProvider(Globals.correctLink((item['images'] as List).isEmpty? '/images/avatars/default.png' : item['images'][0]))//image
                    ),
                    color: Colors.black.withAlpha(20),
                    borderRadius: BorderRadius.circular(10)),
              ),
              Text(
                item[LanguageManager.getDirection()? 'name' : 'name_en'].toString(), // name
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Converter.hexToColor("#2094CD"),
                    fontWeight: FontWeight.bold),
              ),

              Row(
                textDirection: LanguageManager.getTextDirection(),
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 10),
                  item['revision_status']!=null? getStatusProduct(item) : Container(),
                  Container(width: 5),
                  Expanded(child: Center(child: item['is_offer'].toString() == '1'
                      ? RichText(
                    textDirection: LanguageManager.getTextDirection(),
                    text: TextSpan(
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: "Cario",
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' ' + item['price'].toString() + ' ',
                            style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                        TextSpan(text: item['offer_price'].toString() + ' ' + Globals.getUnit()),
                      ],
                    ),
                  )
                      : Text(
                    item['price'].toString() + ' ' + Globals.getUnit(),
                    textDirection: LanguageManager.getTextDirection(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),)),
                  Container(width: 5),
                  SplashEffect(
                      onTap: (){
                        print('here_active: ${item['active']}');
                        setState(() {
                          item['loading'] = true;
                        });
                        NetworkManager.httpGet(Globals.baseUrl + "product/change/active/${item['id']}", context, (r) { // services/add
                          if (r['state'] == true) {
                            setState(() {
                              item['loading'] = false;
                              item['active'] = r['data']['active'];
                              print('here_active2: ${item['active']}');
                              Globals.messageText = item['active'] == 0? 'تم إخفاء المنتج عند إعادة تحميل المتجر' : 'تم إظهار المنتج عند إعادة تحميل المتجر';
                              Globals.showMessageBavBar();
                            });
                          } else if (r["message"] != null) {
                            Alert.show(context, Converter.getRealText(r["message"]));
                          }
                        });
                      },
                      color: Colors.white,
                      padding: EdgeInsets.all(5),
                      alphaShadow: 25,
                      child:
                      item['loading'] == true ?
                      CustomLoading(width: 24.0,)
                      : Icon(
                        item['active'] == 0? FlutterIcons.ios_eye_off_ion: FlutterIcons.eye_check_mco,
                        color: item['active'] == 0 ? Colors.red : Colors.green,
                      )),
                  Container(width: 5),
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
        await Navigator.push(
            context, MaterialPageRoute(builder: (_) => AddProduct())).then((value) {
          load();
        });
      },
      child: Container(
        width: size,
        height: size,
        child: Icon(
          Icons.add_business,
          color: Colors.white,
          size: size * 0.5,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size),
            color: Converter.hexToColor("#344F64")),
      ),
    );
  }

  Widget getStatusProduct(item) {
    var map = {
      'pending': {"text": 217, "color": "#EDF25A"}, // 216, #000000
      'accepted': {"text": 218, "color": "#21CD20"},
      'denied': {"text": 219, "color": "#F00000"}
    };
    return Container(
        alignment: Alignment.center,
        width: 10,
        height: 10,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), color: Converter.hexToColor(map[item['revision_status']]["color"])),
        child: Text(' '),
      );
  }

}
