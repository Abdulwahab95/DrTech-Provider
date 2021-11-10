import 'package:cached_network_image/cached_network_image.dart';
import 'package:dr_tech/Components/CustomBehavior.dart';
import 'package:dr_tech/Components/CustomLoading.dart';
import 'package:dr_tech/Components/EmptyPage.dart';
import 'package:dr_tech/Components/NotificationIcon.dart';
import 'package:dr_tech/Config/Converter.dart';
import 'package:dr_tech/Config/Globals.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:dr_tech/Network/NetworkManager.dart';
import 'package:dr_tech/Pages/OrderDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'LiveChat.dart';

class Orders extends StatefulWidget {
  final status = ['PENDING', 'COMPLETED', 'CANCELED'];
  final bool noheader;
  Orders({this.noheader = false});

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> with TickerProviderStateMixin {
  TabController tabController;
  // Map<String, Map<int, List>> data = {};
  // Map<String, int> pages = {};
  List data = [];
  bool isLoading = false;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener((){
      print('here_listener_index: ${tabController.index}');
      print('here_listener_index: indexIsChanging ${tabController.indexIsChanging}');

      if (tabController.indexIsChanging) {
        load();
      } else {
        setState(() {
          tabController.animateTo(tabController.index);
          data = [];
          load();
        });
      }
    });
    print('here_initState_index: ${tabController.index}');
    load();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void load({index}) {
    setState(() {
      print('here_setState: from here 2');
      isLoading = true;
    });
    var status = widget.status[index != null ? index : tabController.index].toLowerCase();
    // data['filter'] = status;
    // int page = 0;
    // if (pages.containsKey(status)) {
    //   page = pages[status] + 1;
    // }
    Function callback = (r) {
      if (r['state'] == true) {
        data = r['data'];
        print('here_callback: ${data.runtimeType}');
        // pages[r['filter']] = r['page'];
        // if (!data.containsKey(r['filter'])) {
        //   data[r['filter']] = {r["page"]: r['data']};
        // } else {
        //   data[r['filter']][r["page"]] = r['data'];
        // }
      }
      setState(() {
        print('here_setState: from here 3');
        isLoading = false;
      });

    };

    NetworkManager.httpGet(
        Globals.baseUrl + "orders/?status=$status", context, callback,// orders/load?page=$page&status=$status
        cashable: false);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          widget.noheader == true
              ? Container()
              : Container(
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
                        LanguageManager.getText(35),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      NotificationIcon(),
                    ],
                  ))),
          Row(
            textDirection: LanguageManager.getTextDirection(),
            children: [
              getTabTitle(88, 0),// LanguageManager.getTextDirection() == TextDirection.rtl? 2 : 0
              getTabTitle(89, 1),
              getTabTitle(90, 2),// LanguageManager.getTextDirection() == TextDirection.rtl? 0 : 2
            ],
          ),
          Expanded(
              child: TabBarView(
                controller: tabController,
                physics: NeverScrollableScrollPhysics(),
                children: widget.status.map((e) {
                  print('here_TabBarView: $e , arrayIndex: ${widget.status.indexOf('$e')}');

                  return getPage(e.toLowerCase());
                }).toList(),
              ))
        ],
      ),
    );
  }

  Widget getPage(String status) {
    print('here_getPage: $status , currentIndex ${tabController.index}, ${widget.status[tabController.index].toLowerCase()}');
    print('here_getPage: data.length, ${data.length}');
    List<Widget> items = [];

    if(status == widget.status[tabController.index].toLowerCase())
      // if (data[status] != null) {
      //   for (var pageIndex in data[status].keys) {
      for (var item in data) {
        print('here_loop: $item');
        items.add(createOrderItem(item));
      }
    //   }
    // }

    if (data.isEmpty && isLoading) {
      return Container(
        alignment: Alignment.center,
        child: CustomLoading(),
      );
    } else if (data.isEmpty && data.length == 0) { // items.isEmpty && data[status] != null
      return EmptyPage("orders", 91);
    }
    return NotificationListener(
        child: ScrollConfiguration(
            behavior: CustomBehavior(), child: ListView(children: items)));
  }

  Widget getTabTitle(title, index) {
    print('here_getTabTitle: title: $title, index: $index');

    // if (data[widget.status[index].toLowerCase()] == null) {
    //   load(index: index);
    // }
    return Expanded(
      child: InkWell(
          onTap: () {
            setState(() {
              print('here_setState: from here 4');
              data.clear();
              tabController.animateTo(index);
            });
          },
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(top: 15, bottom: 2),
                  child: Text(
                    LanguageManager.getText(title),
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: tabController.index == index
                            ? Converter.hexToColor("#2094CD")
                            : Converter.hexToColor("#707070")),
                    textAlign: TextAlign.center,
                  )),
              Container(
                height: 1.5,
                color: tabController.index == index
                    ? Converter.hexToColor("#2094CD")
                    : Colors.transparent,
                margin: EdgeInsets.only(left: 15, right: 15),
              )
            ],
          )),
    );
  }

  Widget createOrderItem(item) {
    print('here_createOrderItem: ${item["service_name"].toString().length}');

    double size = 90;
    return InkWell(
      onTap: () async {
        var results = await Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetails(item)));
        print('here_1: $results');

        if (results == true) {
          setState(() {
            print('here_setState: from here 1');
            // pages = {};
            data = [];
            load();
          });
        }
      },
      child: Container(
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
        child: Row(
          textDirection: LanguageManager.getTextDirection(),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: size,
              height: size,
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Converter.hexToColor("#F2F2F2"),
                image: DecorationImage(
                    // fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(Globals.correctLink(item['service_icon'])))

              ),
              // child: ,
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
                        child: item["service_name"].toString().length < 25 &&
                                item["service_name"].toString().length > 18
                            ? FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  item["service_name"].toString(),
                                  textDirection:
                                      LanguageManager.getTextDirection(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Converter.hexToColor("#2094CD")),
                                ),
                              )
                            : Text(
                                item["service_name"].toString(),
                                textDirection:
                                    LanguageManager.getTextDirection(),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Converter.hexToColor("#2094CD")),
                              ),
                      ),
                      Container(
                        width: LanguageManager.getDirection()? 5 : 10,
                      ),
                      Row(
                        children: [
                          Container(
                            // height: 30,
                            // width: 60,
                            padding: EdgeInsets.only(left: 5, right: 7.5, top:2.5, bottom: 2.5),
                            margin: EdgeInsets.only(top: 5),
                            alignment: Alignment.center,
                            child: Text(
                              getStatusText(item["status"]),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            decoration: BoxDecoration(
                                color: Converter.hexToColor(
                                    item["status"] == 'CANCELED'
                                        ? "#f00000"
                                        : item["status"] == 'WAITING'
                                          ? "#0ec300"
                                          : "#2094CD"),
                                borderRadius: LanguageManager.getDirection()
                                    ? BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15))
                                    : BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15))),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    height: 4,
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
                        width: 10,
                      ),
                      Container(
                        child: Row(
                          textDirection: LanguageManager.getTextDirection(),
                          children: [
                            Text(
                              item["price"].toString(),
                              textDirection: LanguageManager.getTextDirection(),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Converter.hexToColor("#2094CD")),
                            ),
                            Container(
                              width: 5,
                            ),
                            Text(
                              item["unit"].toString(),
                              textDirection: LanguageManager.getTextDirection(),
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
                        item['name'].toString(),
                        style: TextStyle(
                            color: Converter.hexToColor("#707070"),
                            fontWeight: FontWeight.normal,
                            fontSize: 14),
                        textDirection: LanguageManager.getTextDirection(),
                      )
                    ],
                  ),
                  Container(
                    height: 7,
                  ),
                  InkWell(
                    onTap: () {
                      // Call Action
                      Navigator.push(context, MaterialPageRoute(builder: (_) => LiveChat(item['provider_id'].toString())));
                    },
                    child: Container(
                      width: (LanguageManager.getText(117).length * (LanguageManager.getDirection()? 15 : 10)).toDouble(),
                      height: 34,
                      alignment: Alignment.center,
                      child: Row(
                        textDirection: LanguageManager.getTextDirection(),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LanguageManager.getDirection()? FlutterIcons.message_text_mco:FlutterIcons.message_reply_text_mco,
                            size: 18,
                            color: Colors.white,
                          ),
                          Container(width: 7.5),
                          Text(
                            LanguageManager.getText(117),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
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
                  Container(
                    height: 10,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String getStatusText(status) {
    print('here_status: $status');
    return LanguageManager.getText({
      'PENDING': 93,
      'WAITING': 92,
      'COMPLETED': 94,
      'CANCELED': 184
    }[status.toString().toUpperCase()] ??
        92);
  }
}
