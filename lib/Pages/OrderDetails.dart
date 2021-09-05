import 'package:dr_tech/Components/Alert.dart';
import 'package:dr_tech/Components/NotificationIcon.dart';
import 'package:dr_tech/Config/Converter.dart';
import 'package:dr_tech/Config/Globals.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:dr_tech/Network/NetworkManager.dart';
import 'package:dr_tech/Pages/OrderSetRating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class OrderDetails extends StatefulWidget {
  final data;
  OrderDetails(this.data);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
            textDirection: LanguageManager.getTextDirection(),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  decoration:
                      BoxDecoration(color: Converter.hexToColor("#2094cd")),
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          left: 25, right: 25, bottom: 10, top: 25),
                      child: Row(
                        textDirection: LanguageManager.getTextDirection(),
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                LanguageManager.getDirection()
                                    ? FlutterIcons.chevron_right_fea
                                    : FlutterIcons.chevron_left_fea,
                                color: Colors.white,
                                size: 26,
                              )),
                          Text(
                            LanguageManager.getText(178),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          NotificationIcon(),
                        ],
                      ))),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.width * 0.455,
                margin:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Converter.hexToColor("#F2F2F2")),
                alignment: Alignment.topLeft,
                child: Container(
                  height: 30,
                  width: 60,
                  margin: EdgeInsets.only(top: 5),
                  alignment: Alignment.center,
                  child: Text(
                    getStatusText(widget.data["status"]),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  decoration: BoxDecoration(
                      color: Converter.hexToColor(
                          widget.data["status"] == 'CANCELED'
                              ? "#f00000"
                              : "#2094CD"),
                      borderRadius: LanguageManager.getDirection()
                          ? BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15))
                          : BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15))),
                ),
              ),
              Container(
                height: 10,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    textDirection: LanguageManager.getTextDirection(),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data["service_name"].toString(),
                        textDirection: LanguageManager.getTextDirection(),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Converter.hexToColor("#2094CD")),
                      ),
                      Container(
                        height: 10,
                      ),
                      Row(
                        textDirection: LanguageManager.getTextDirection(),
                        children: [
                          Text(
                            LanguageManager.getText(95),
                            textDirection: LanguageManager.getTextDirection(),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Converter.hexToColor("#2094CD")),
                          ),
                          Container(
                            width: 30,
                          ),
                          Container(
                            child: Row(
                              textDirection: LanguageManager.getTextDirection(),
                              children: [
                                Text(
                                  widget.data["price"].toString(),
                                  textDirection:
                                      LanguageManager.getTextDirection(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Converter.hexToColor("#2094CD")),
                                ),
                                Container(
                                  width: 5,
                                ),
                                Text(
                                  widget.data["unit"].toString(),
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
                          ),
                        ],
                      ),
                      Container(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        textDirection: LanguageManager.getTextDirection(),
                        children: [
                          Row(
                            textDirection: LanguageManager.getTextDirection(),
                            children: [
                              Icon(
                                Icons.person,
                                color: Converter.hexToColor("#C4C4C4"),
                                size: 20,
                              ),
                              Container(
                                width: 7,
                              ),
                              Text(
                                widget.data['name'].toString(),
                                style: TextStyle(
                                    color: Converter.hexToColor("#707070"),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                                textDirection:
                                    LanguageManager.getTextDirection(),
                              )
                            ],
                          ),
                          Row(
                            textDirection: LanguageManager.getTextDirection(),
                            children: [
                              InkWell(
                                onTap: () {
                                  // Chat action
                                },
                                child: Icon(
                                  FlutterIcons.phone_faw,
                                  color: Converter.hexToColor("#344F64"),
                                  size: 22,
                                ),
                              ),
                              Container(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  // Chat action
                                },
                                child: Icon(
                                  Icons.message,
                                  color: Converter.hexToColor("#344F64"),
                                  size: 22,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        height: 10,
                      ),
                      Text(
                        widget.data['description'].toString(),
                        style: TextStyle(
                            color: Converter.hexToColor("#707070"),
                            fontWeight: FontWeight.normal,
                            fontSize: 14),
                        textDirection: LanguageManager.getTextDirection(),
                      )
                    ],
                  ),
                ),
              ),
              widget.data['status'] != 'PENDING' &&
                      widget.data['status'] != 'PROCESSING'
                  ? Container()
                  : Row(
                      textDirection: LanguageManager.getTextDirection(),
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: completedOrder,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: 45,
                            alignment: Alignment.center,
                            child: Text(
                              LanguageManager.getText(179),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
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
                        InkWell(
                          onTap: () {
                            cancelOrder();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: 45,
                            alignment: Alignment.center,
                            child: Text(
                              LanguageManager.getText(180),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
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
                      ],
                    ),
              Container(
                height: 15,
              )
            ]));
  }

  void cancelOrderConferm() {
    Alert.startLoading(context);
    Map<String, String> body = {"id": widget.data['id'].toString()};
    NetworkManager.httpPost(Globals.baseUrl + "orders/cancel", (r) {
      Alert.endLoading();
      if (r['status'] == true) {
        Navigator.of(context).pop(true);
      }
      if (r['message'] != null) {
        Alert.show(context, Converter.getRealText(r['message']));
      }
    }, body: body);
  }

  void completedOrderConferm() {
    Alert.startLoading(context);
    Map<String, String> body = {"id": widget.data['id'].toString()};
    NetworkManager.httpPost(Globals.baseUrl + "orders/completed", (r) {
      Alert.endLoading();
      if (r['status'] == true) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => OrderSetRating(widget.data['id'])));
      }
      if (r['message'] != null) {
        Alert.show(context, Converter.getRealText(r['message']));
      }
    }, body: body);
  }

  void cancelOrder() {
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
                  color: Converter.hexToColor("#f00000"),
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
                      Alert.publicClose();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45,
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
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      cancelOrderConferm();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45,
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
                ],
              )
            ],
          ),
        ),
        type: AlertType.WIDGET);
  }

  void completedOrder() {
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
                  FlutterIcons.info_fea,
                  size: 60,
                  color: Converter.hexToColor("#2094CD"),
                ),
              ),
              Container(
                height: 30,
              ),
              Text(
                LanguageManager.getText(181),
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
                      completedOrderConferm();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: 45,
                      alignment: Alignment.center,
                      child: Text(
                        LanguageManager.getText(182),
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
                          color: Converter.hexToColor("#2094CD")),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Alert.publicClose();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45,
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
                  ),
                ],
              )
            ],
          ),
        ),
        type: AlertType.WIDGET);
  }

  String getStatusText(status) {
    return LanguageManager.getText({
          'PENDING': 92,
          'PROCESSING': 93,
          'COMPLETED': 94,
          'CANCELED': 184
        }[status] ??
        92);
  }
}
