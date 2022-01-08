import 'package:dr_tech/Components/CustomLoading.dart';
import 'package:dr_tech/Components/EmptyPage.dart';
import 'package:dr_tech/Components/Recycler.dart';
import 'package:dr_tech/Components/TitleBar.dart';
import 'package:dr_tech/Config/Converter.dart';
import 'package:dr_tech/Config/Globals.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:dr_tech/Models/UserManager.dart';
import 'package:dr_tech/Network/NetworkManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AllTransactions extends StatefulWidget {
  const AllTransactions();

  @override
  _AllTransactionsState createState() => _AllTransactionsState();
}

class _AllTransactionsState extends State<AllTransactions> {
  Map data = {};
  bool isLoading = false;
  var unit;
  int page = 0;

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    NetworkManager.httpGet(Globals.baseUrl + "provider/transactions", context, (r) {
          setState(() {
            isLoading = false;
          });
          if (r['state'] == true) {
            setState(() {
              data[page] = r['data'];
              unit = Globals.getUnit();
            });
          }
        }, cashable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
            textDirection: LanguageManager.getTextDirection(),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleBar(() {Navigator.pop(context);}, 187),
              Expanded(child: getContent()),
              // getOptions()
            ]));
  }

  Widget getContent() {

    if (isLoading == true && data.isEmpty)
      return Center(
        child: CustomLoading(),
      );

    List<Widget> items = [];

    if (data[page].isEmpty) {
      return Column(
        children: items..add(Expanded(child: EmptyPage("wallet", 188))),
      );
    }


    // for (var page in data.keys) {
      for (var item in data[page]) { // (var item in data[page])
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
        decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(color: Colors.grey.withAlpha(30), width: 1))),
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
                    item['type'] == "WITHDRAWAL"
                        ? LanguageManager.getText(302) + " #" + item['order_id'].toString() // تسديد عمولة الطلب رقم
                        : LanguageManager.getText(303) + " #" + item['order_id'].toString() + " " + item['title'], // تنفيذ طلب
                    textDirection: LanguageManager.getTextDirection(),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                  Text(
                    Converter.getRealText(item['created_at']),
                    // textDirection: LanguageManager.getTextDirection(),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Text(
              item['amount'].toString(),
              textDirection: LanguageManager.getTextDirection(),
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Container(
              width: 10,
            ),
            Text(
              unit.toString(),
              textDirection: LanguageManager.getTextDirection(),
              style: TextStyle(
                  color: color, fontWeight: FontWeight.normal, fontSize: 16),
            ),
          ],
        ));
  }

}
