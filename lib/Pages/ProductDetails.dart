import 'package:cached_network_image/cached_network_image.dart';
import 'package:dr_tech/Components/CustomBehavior.dart';
import 'package:dr_tech/Components/CustomLoading.dart';
import 'package:dr_tech/Components/TitleBar.dart';
import 'package:dr_tech/Config/Converter.dart';
import 'package:dr_tech/Config/Globals.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:dr_tech/Pages/OpenImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';

import '../Components/Alert.dart';
import '../Config/IconsMap.dart';
import '../Network/NetworkManager.dart';
import 'AddProduct.dart';

class ProductDetails extends StatefulWidget {
  final args;

  const ProductDetails(this.args);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isLoading = false;
  ScrollController sliderController = ScrollController();
  int sliderSelectedIndex = -1;
  Map body = {}, errors = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
          TitleBar(() {Navigator.pop(context);}, 162),
          isLoading
          ? Expanded(child: Center(child: CustomLoading()))
          : Expanded(
              child: widget.args['revision_status'] == 'accepted'? ScrollConfiguration(
              behavior: CustomBehavior(),
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                children: [
                  getSlider(),
                  Container(
                    padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                    child: Row(
                      textDirection: LanguageManager.getTextDirection(),
                      children: [
                        Expanded(
                            child: Text(
                          widget.args[LanguageManager.getDirection()
                              ? 'name'
                              : 'name_en'],
                          textDirection: LanguageManager.getTextDirection(),
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                        widget.args['is_offer'].toString() == '1'
                            ? RichText(
                                textDirection:
                                    LanguageManager.getTextDirection(),
                                text: TextSpan(
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: widget.args['price'].toString() +
                                            ' ' +
                                            Globals.getUnit(),
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey)),
                                    TextSpan(text: '\t'),
                                    TextSpan(
                                        text: widget.args['offer_price']
                                                .toString() +
                                            ' ' +
                                            Globals.getUnit()),
                                  ],
                                ),
                              )
                            : Text(
                                widget.args['price'].toString() +
                                    ' ' +
                                    Globals.getUnit(),
                                textDirection:
                                    LanguageManager.getTextDirection(),
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                      ],
                    ),
                  ),
                  for (var iconInfo in widget.args['details_info'])
                    if (iconInfo.runtimeType.toString() ==
                            '_InternalLinkedHashMap<String, dynamic>' &&
                        iconInfo['icon'] != null &&
                        iconInfo['text_ar'] != null)
                      createInfoIcon(
                          iconInfo['icon'],
                          iconInfo[LanguageManager.getDirection()
                                  ? 'text_ar'
                                  : 'text_en'] ??
                              ''),
                  Container(
                    padding:
                        EdgeInsets.only(left: 15, right: 15, top: 2, bottom: 0),
                    child: Text(
                      LanguageManager.getText(163),
                      textDirection: LanguageManager.getTextDirection(),
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Wrap(
                      textDirection: LanguageManager.getTextDirection(),
                      children: getProductSpecifications(),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 15, right: 15, top: 2, bottom: 0),
                    child: Text(
                      LanguageManager.getText(165),
                      textDirection: LanguageManager.getTextDirection(),
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 15, right: 15, top: 2, bottom: 0),
                    child: Text(
                      widget.args["description"].toString(),
                      textDirection: LanguageManager.getTextDirection(),
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ): getFormContent() ),
      isLoading
          ? Container()
          : Row(
              textDirection: LanguageManager.getTextDirection(),
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      var returnResult = await Navigator.push(context, MaterialPageRoute(builder: (_) => AddProduct(data: widget.args)));
                      // if (returnResult == true) {
                      //   load();
                      // }
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      height: 45,
                      alignment: Alignment.center,
                      child: Text(
                        LanguageManager.getText(170), // تعديل
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
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
                ),
                Expanded(
                  child: InkWell(
                    onTap: deleteProduct,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      height: 45,
                      alignment: Alignment.center,
                      child: Text(
                        LanguageManager.getText(169),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withAlpha(15),
                                spreadRadius: 2,
                                blurRadius: 2)
                          ],
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.red),
                    ),
                  ),
                ),
              ],
            )
    ]));
  }

  List<Widget> getProductSpecifications() {
    List<Widget> items = [];

    for (var item in widget.args['product_specifications'])
      if (item.runtimeType.toString() ==
          '_InternalLinkedHashMap<String, dynamic>')
        items.add(createSpecificationsItem(
            item['icon'],
            item[LanguageManager.getDirection() ? 'text_ar' : 'text_en'] ??
                ''));

    return items;
  }

  Widget createSpecificationsItem(icon, text) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      padding: EdgeInsets.only(left: 15, right: 15),
      height: 38,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: LanguageManager.getTextDirection(),
        children: [
          Icon(
            IconsMap.from[icon],
            color: Converter.hexToColor("#C4C4C4"),
          ),
          Container(
            width: 5,
          ),
          Text(
            text.toString(),
            textDirection: LanguageManager.getTextDirection(),
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Converter.hexToColor("#707070")),
          ),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Converter.hexToColor("#F2F2F2")),
    );
  }

  Widget getSlider() {
    double size = MediaQuery.of(context).size.width * 0.95;
    return Center(
      child: Container(
        margin: EdgeInsets.all(10),
        width: size,
        height: size * 0.6,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Converter.hexToColor("#F2F2F2")),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ListView(
                  scrollDirection: Axis.horizontal,
                  controller: sliderController,
                  children: getSliderContent(Size(size - 20, size * 0.45)),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    textDirection: LanguageManager.getTextDirection(),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 20,
                        height: 0,
                      ),
                      Row(
                        textDirection: LanguageManager.getTextDirection(),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: getSliderDots(),
                      ),
                      Icon(
                        FlutterIcons.share_2_fea,
                        color: Converter.hexToColor("#344F64"),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getSliderContent(Size size) {
    List<Widget> sliders = [];
    for (var item in widget.args['images']) {
      sliders.add(InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => OpenImage(
                    url: widget.args['images']
                        .toString()
                        .replaceAll(',', '||')
                        .replaceAll('[', '')
                        .replaceAll(']', '')
                        .replaceAll(' ', '')))),
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.contain,
                  image:
                      CachedNetworkImageProvider(Globals.correctLink(item)))),
        ),
      ));
    }
    return sliders;
  }

  List<Widget> getSliderDots() {
    List<Widget> sliders = [];
    for (var i = 0; i < widget.args['images'].length; i++) {
      bool selected = sliderSelectedIndex == i;
      sliders.add(Container(
        width: selected ? 14 : 8,
        height: 8,
        margin: EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Converter.hexToColor(selected ? "#2094CD" : "#C4C4C4")),
      ));
    }
    return sliders;
  }

  Widget createInfoIcon(icon, text) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        textDirection: LanguageManager.getTextDirection(),
        children: [
          Icon(
            IconsMap.from[icon],
            color: Converter.hexToColor("#C4C4C4"),
            size: 20,
          ),
          Container(
            width: 10,
          ),
          Expanded(
              child: Text(
            Converter.getRealTime(text),
            textDirection: LanguageManager.getTextDirection(),
            style: TextStyle(
                fontSize: 16,
                color: Converter.hexToColor("#707070"),
                fontWeight: FontWeight.w600),
          ))
        ],
      ),
    );
  }

  void deleteProduct() {
    Alert.show(
        context,
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            textDirection: LanguageManager.getTextDirection(),
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                textDirection: LanguageManager.getTextDirection(),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      FlutterIcons.x_fea,
                      size: 24,
                    ),
                  )
                ],
              ),
              Container(
                child: Icon(
                  FlutterIcons.trash_faw,
                  size: 50,
                  color: Converter.hexToColor("#707070"),
                ),
              ),
              Container(
                height: 30,
              ),
              Text(
                LanguageManager.getText(171),
                style: TextStyle(
                    color: Converter.hexToColor("#707070"),
                    fontWeight: FontWeight.bold),
              ),
              Container(
                height: 30,
              ),
              Row(
                textDirection: LanguageManager.getTextDirection(),
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      deleteProductConferm();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 45,
                      alignment: Alignment.center,
                      child: Text(
                        LanguageManager.getText(169),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withAlpha(15),
                                spreadRadius: 2,
                                blurRadius: 2)
                          ],
                          borderRadius: BorderRadius.circular(8),
                          color: Converter.hexToColor("#FF0000")),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Alert.publicClose();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 45,
                      alignment: Alignment.center,
                      child: Text(
                        LanguageManager.getText(172),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
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
                  )
                ],
              )
            ],
          ),
        ),
        type: AlertType.WIDGET);
  }

  void deleteProductConferm() {
    Alert.startLoading(context);
    NetworkManager.httpGet(
        Globals.baseUrl + "product/delete/${widget.args['id']}", context, (r) {
      Alert.endLoading();
      if (r['state'] == true) {
        Navigator.of(context)
          ..pop(true)
          ..pop(true);
      }
    });
  }

  Widget getFormContent() {
    return Column(
      children: [
        Container(height: 70),
        SvgPicture.asset("assets/illustration/join.svg", width: 120, height: 120),
        Container(height: 10),
        Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 0),
          child: Text(
            LanguageManager.getText(widget.args['in_update'] == 1 ? 470 : 469) + ':\n\"${widget.args[LanguageManager.getDirection()? 'name' : 'name_en']}\"',
            textDirection: LanguageManager.getTextDirection(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Converter.hexToColor("#2094CD")),
          ),
        ),
        Container(height: 10),
        Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 0),
          child: Row(
            textDirection: LanguageManager.getTextDirection(),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                LanguageManager.getText(215),
                textDirection: LanguageManager.getTextDirection(),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Converter.hexToColor("#344F64")),
              ),
              Container(width: 10),
              getStatusText(),
            ],
          ),
        )
      ],
    );
  }

  Widget getStatusText() {
    var map = {
      'pending': {"text": 217, "color": "#DFC100"}, // 216, #000000
      'accepted': {"text": 218, "color": "#00710B"},
      'denied': {"text": 219, "color": "#F00000"}
    };
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Converter.hexToColor(map[widget.args['revision_status']]["color"]).withAlpha(15)),
      child: Text(
        LanguageManager.getText(map[widget.args['revision_status']]["text"]),
        textDirection: LanguageManager.getTextDirection(),
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Converter.hexToColor(map[widget.args['revision_status']]["color"])),
      ),
    );
  }
}
