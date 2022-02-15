import 'package:dr_tech/Components/Alert.dart';
import 'package:dr_tech/Components/CustomLoading.dart';
import 'package:dr_tech/Components/EmptyPage.dart';
import 'package:dr_tech/Components/Recycler.dart';
import 'package:dr_tech/Components/TitleBar.dart';
import 'package:dr_tech/Config/Converter.dart';
import 'package:dr_tech/Config/Globals.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:dr_tech/Models/UserManager.dart';
import 'package:dr_tech/Network/NetworkManager.dart';
import 'package:dr_tech/Pages/AllTransactions.dart';
import 'package:dr_tech/Pages/WebBrowser.dart';
import 'package:dr_tech/Pages/Withdrawal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Transactions extends StatefulWidget {
  const Transactions();

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  // Map<int, List> data = {};
  Map data = {};
  bool isloading = false;
  var balance, unit, commission;
  int page = 0;

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() {
    // if (page > 0 && data.values.last.length == 0) return;
    setState(() {
      isloading = true;
    });
    NetworkManager.httpGet(Globals.baseUrl + "provider/statistics", context, (r) {
          setState(() {
            isloading = false;
          });
          if (r['state'] == true) {
            setState(() {
              data[page] = r['data'];
              balance = r['data']['revenue'];
              commission = r['data']['commission'];
              unit = Globals.getUnit();
              // page++;
            });
          }
        }, cashable: false);
    // NetworkManager.httpGet(Globals.baseUrl + "user/transactions?page=$page",
    //      context, (r) {
    //   setState(() {
    //     isloading = false;
    //   });
    //   if (r['state'] == true) {
    //     setState(() {
    //       data[r["page"]] = r['data'];
    //       balance = r['balance'];
    //       unit = r['unit'];
    //       page++;
    //     });
    //   }
    // }, cashable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
            textDirection: LanguageManager.getTextDirection(),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleBar(() {Navigator.pop(context);}, 301),
              Expanded(child: getContent()),
              // getOptions()
            ]));
  }

  Widget getOptions() {
    if (data.isEmpty) return Container();

    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        textDirection: LanguageManager.getTextDirection(),
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                if (double.parse(balance) <= 0) {
                  Alert.show(context, LanguageManager.getText(241));
                  return;
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Withdrawal(
                            double.parse(balance.toString()), unit)));
              },
              child: Container(
                height: 45,
                alignment: Alignment.center,
                child: Text(
                  LanguageManager.getText(191),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
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
          Container(
            width: 10,
          ),
          Expanded(
            child: InkWell(
              onTap: () async {
                if (double.parse(balance) >= 0) {
                  Alert.show(context, LanguageManager.getText(239));
                  return;
                }
                String url = [
                  Globals.baseUrl,
                  "payment/debit/?user=",
                  UserManager.currentUser(Globals.authoKey)
                ].join();

                var results = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            WebBrowser(url, LanguageManager.getText(228))));
                if (results != null) {
                  if (results["message"] != null) {
                    Alert.show(
                        context, Converter.getRealText(results['message']));
                  }
                  if (results['state'] == true) {
                    page = 0;
                    data = {};
                    load();
                  }
                } else if (results == null) {
                  Alert.show(context, LanguageManager.getText(240));
                  return;
                }
              },
              child: Container(
                height: 45,
                alignment: Alignment.center,
                child: Text(
                  LanguageManager.getText(192),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
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
          )
        ],
      ),
    );
  }

  Widget getContent() {

    if (isloading == true && data.isEmpty)
      return Center(
        child: CustomLoading(),
      );

    List<Widget> items = [];

    items.add(Container(height: 25));

    items.add(getColumn());

    if (balance == 0) {
      return Column(
        children: items..add(Expanded(child: EmptyPage("wallet", 188))),
      );
    }

    items.add(Container(
      padding: EdgeInsets.all(25),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha(15),
                  spreadRadius: 2,
                  blurRadius: 2)
            ]),
        child: Column(
          textDirection: LanguageManager.getTextDirection(),
          children: [
            Container(
              alignment: Alignment.topCenter,
              height: 70,
              width: 110,
              child: Icon(
                FlutterIcons.wallet_faw5s,
                size: 60,
                color: Converter.hexToColor("#344F64"),
              ),
            ),
            Row(
              textDirection: LanguageManager.getTextDirection(),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LanguageManager.getText(304) , // 186 // إجمالي المبيعات
                  textDirection: LanguageManager.getTextDirection(),
                  style: TextStyle(
                      color: Converter.hexToColor("#344F64"),
                      fontWeight: FontWeight.bold,
                      fontSize: 17),//15
                ),
                Container(
                  width: 10,
                ),
                Row(
                  textDirection: LanguageManager.getTextDirection(),
                    children: [
                        Text(
                        Converter.format(balance),
                        textDirection: LanguageManager.getTextDirection(),
                        style: TextStyle(
                            color: Converter.hexToColor("#344F64"),
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                      Container(
                        width: 10,
                      ),
                      Text(
                        unit.toString(),
                        textDirection: LanguageManager.getTextDirection(),
                        style: TextStyle(
                            color: Converter.hexToColor("#344F64"),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      )
                    ]),
              ],
            ),

            Row(
              textDirection: LanguageManager.getTextDirection(),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LanguageManager.getText(305) , // 186 //عمولة التطبيق
                  textDirection: LanguageManager.getTextDirection(),
                  style: TextStyle(
                      color: Converter.hexToColor("#344F64"),
                      fontWeight: FontWeight.bold,
                      fontSize: 17),//15
                ),
                Container(
                  width: 10,
                ),
                Row(
                    textDirection: LanguageManager.getTextDirection(),
                    children: [
                      Text(
                        Converter.format(commission),
                        textDirection: LanguageManager.getTextDirection(),
                        style: TextStyle(
                            color: Converter.hexToColor("#344F64"),
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                      Container(
                        width: 10,
                      ),
                      Text(
                        unit.toString(),
                        textDirection: LanguageManager.getTextDirection(),
                        style: TextStyle(
                            color: Converter.hexToColor("#344F64"),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ]),
              ],
            ),
          ],
        ),
      ),
    ));
    items.add(Row(
      textDirection: LanguageManager.getTextDirection(),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 15, bottom: 3),
          child: Text(
            LanguageManager.getText(187),
            textDirection: LanguageManager.getTextDirection(),
            style: TextStyle(
                color: Converter.hexToColor("#344F64"),
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => AllTransactions()));
          },
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 3),
            child: Text(
              LanguageManager.getText(121),
              textDirection: LanguageManager.getTextDirection(),
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
        ),
      ],
    ));

    // for (var page in data.keys) {
      for (var item in data[0]['transaction']) { // (var item in data[page])
        items.add(createTransactionItem(item));
      }
    // }

    return Recycler(
      children: items,
    );
    // return items[0];
  }

  Widget createTransactionItem(item) {
    Color color = item['type'] == "WITHDRAWAL" ? Colors.blue : Colors.green;
    return Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.withAlpha(30), width: 1))),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: LanguageManager.getTextDirection(),
          children: [
            Container(
              width: 70,
              child: SvgPicture.asset(
                "assets/icons/${item['type'].toString().toLowerCase()}.svg",
                width: 20,
                height: 20,
                color: color,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: LanguageManager.getTextDirection(),
                children: [
                  Text(
                    item['order_id'].toString() == '0'
                        ? LanguageManager.getText( item['type'] == "WITHDRAWAL" ? 302 : 334)
                        : item['type'] == "WITHDRAWAL"
                            ? LanguageManager.getText(302) + " #" + item['order_id'].toString() // تسديد عمولة الطلب رقم
                            : LanguageManager.getText(303) + " #" + item['order_id'].toString() + " " + item['title'], // تنفيذ طلب
                    textDirection: LanguageManager.getTextDirection(),
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                  Text(
                    Converter.getRealText(item['created_at']),
                    // textDirection: LanguageManager.getTextDirection(),
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['amount'].toString(),
                  textDirection: LanguageManager.getTextDirection(),
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  item['commission'].toString(),
                  textDirection: LanguageManager.getTextDirection(),
                  style: TextStyle(
                      color: Converter.hexToColor("#344F64"), fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            Container(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unit.toString(),
                  textDirection: LanguageManager.getTextDirection(),
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.normal, fontSize: 16),
                ),
                Text(
                  unit.toString(),
                  textDirection: LanguageManager.getTextDirection(),
                  style: TextStyle(
                      color: Converter.hexToColor("#344F64"), fontWeight: FontWeight.normal, fontSize: 12),
                ),
              ],
            ),
          ],
        ));
  }

  Widget getColumn() {
    if (isloading == true && data.isEmpty)
      return Center();

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(width: 10,),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.red,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withAlpha(15),
                    spreadRadius: 2,
                    blurRadius: 2)
              ]),
                child:Text('${Converter.getRealText(184)}\n${data[0]['canceled']}', textAlign: TextAlign.center,style: TextStyle(color: Colors.white),)),
          ),
          Container(width: 10,),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.green,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withAlpha(15),
                    spreadRadius: 2,
                    blurRadius: 2)
              ]),
                child:Text('${Converter.getRealText(93)}\n${data[0]['pending']}', textAlign: TextAlign.center,style: TextStyle(color: Colors.white),)),
          ),
          Container(width: 10,),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Converter.hexToColor("#344F64"),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withAlpha(15),
                    spreadRadius: 2,
                    blurRadius: 2)
              ]),
                child:Text('${Converter.getRealText(94)}\n${data[0]['completed']}', textAlign: TextAlign.center,style: TextStyle(color: Colors.white),)),
          ),
          Container(width: 10,),
      ]),
    );
  }
}
