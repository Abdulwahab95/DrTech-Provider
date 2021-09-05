import 'package:dr_tech/Components/CustomBehavior.dart';
import 'package:dr_tech/Components/CustomLoading.dart';
import 'package:dr_tech/Components/EmptyPage.dart';
import 'package:dr_tech/Components/NotificationIcon.dart';
import 'package:dr_tech/Config/Converter.dart';
import 'package:dr_tech/Config/Globals.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:dr_tech/Network/NetworkManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dr_tech/Pages/OrderDetails.dart';

class Orders extends StatefulWidget {
  final status = ['PENDING', 'COMPLETED', 'CANCELED'];
  final bool noheader;
  Orders({this.noheader = false});

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> with TickerProviderStateMixin {
  TabController tabController;
  Map<String, Map<int, List>> data = {};
  Map<String, int> pages = {};
  bool isLoading = false;
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    load();
    super.initState();
  }

  void load({index}) {
    setState(() {
      isLoading = true;
    });
    var status = widget.status[index != null ? index : tabController.index]
        .toLowerCase();
    int page = 0;
    if (pages.containsKey(status)) {
      page = pages[status] + 1;
    }
    Function callback = (r) {
      setState(() {
        isLoading = false;
      });
      if (r['status'] == true) {
        setState(() {
          pages[r['filter']] = r['page'];
          if (!data.containsKey(r['filter'])) {
            data[r['filter']] = {r["page"]: r['data']};
          } else {
            data[r['filter']][r["page"]] = r['data'];
          }
        });
      }
    };
    NetworkManager.httpGet(
        Globals.baseUrl + "orders/load?page=$page&status=$status", callback,
        cashable: true);
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
              getTabTitel(88, 0),
              getTabTitel(89, 1),
              getTabTitel(90, 2),
            ],
          ),
          Expanded(
              child: TabBarView(
            controller: tabController,
            children: widget.status.map((e) {
              return getPage(e.toLowerCase());
            }).toList(),
          ))
        ],
      ),
    );
  }

  Widget getPage(String status) {
    List<Widget> items = [];
    if (data[status] != null) {
      for (var pageIndex in data[status].keys) {
        for (var item in data[status][pageIndex]) {
          items.add(createOrderItem(item));
        }
      }
    }

    if (items.isEmpty && isLoading) {
      return Container(
        alignment: Alignment.center,
        child: CustomLoading(),
      );
    } else if (items.isEmpty && data[status] != null) {
      return EmptyPage("orders", 91);
    }
    return NotificationListener(
        child: ScrollConfiguration(
            behavior: CustomBehavior(), child: ListView(children: items)));
  }

  Widget getTabTitel(titel, index) {
    if (data[widget.status[index].toLowerCase()] == null) {
      load(index: index);
    }
    return Expanded(
      child: InkWell(
          onTap: () {
            setState(() {
              tabController.animateTo(index);
            });
          },
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(top: 15, bottom: 2),
                  child: Text(
                    LanguageManager.getText(titel),
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
    double size = 120;
    return InkWell(
      onTap: () async {
        var results = await Navigator.push(
            context, MaterialPageRoute(builder: (_) => OrderDetails(item)));

        if (results == true) {
          setState(() {
            pages = {};
            data = {};
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
                  color: Converter.hexToColor("#F2F2F2")),
              child: SvgPicture.network(item['service_icon']),
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
                          item["service_name"].toString(),
                          textDirection: LanguageManager.getTextDirection(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Converter.hexToColor("#2094CD")),
                        ),
                      ),
                      Container(
                        width: 5,
                      ),
                      Container(
                        height: 30,
                        width: 60,
                        margin: EdgeInsets.only(top: 5),
                        alignment: Alignment.center,
                        child: Text(
                          getStatusText(item["status"]),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        decoration: BoxDecoration(
                            color: Converter.hexToColor(
                                item["status"] == 'CANCELED'
                                    ? "#f00000"
                                    : "#2094CD"),
                            borderRadius: LanguageManager.getDirection()
                                ? BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15))
                                : BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15))),
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
                    },
                    child: Container(
                      width: 90,
                      height: 34,
                      alignment: Alignment.center,
                      child: Row(
                        textDirection: LanguageManager.getTextDirection(),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FlutterIcons.phone_faw,
                            size: 18,
                            color: Colors.white,
                          ),
                          Container(
                            width: 5,
                          ),
                          Text(
                            LanguageManager.getText(96),
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
    return LanguageManager.getText({
          'PENDING': 92,
          'PROCESSING': 93,
          'COMPLETED': 94,
          'CANCELED': 184
        }[status] ??
        92);
  }
}
