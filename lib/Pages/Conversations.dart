
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dr_tech/Components/CustomLoading.dart';
import 'package:dr_tech/Components/EmptyPage.dart';
import 'package:dr_tech/Components/NotificationIcon.dart';
import 'package:dr_tech/Components/Recycler.dart';
import 'package:dr_tech/Config/Converter.dart';
import 'package:dr_tech/Config/Globals.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:dr_tech/Network/NetworkManager.dart';
import 'package:dr_tech/Pages/LiveChat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Conversations extends StatefulWidget {
  final bool noheader;
  const Conversations({this.noheader = false});

  @override
  _ConversationsState createState() => _ConversationsState();
}

class _ConversationsState extends State<Conversations> {
  Map<int, List> data = {};
  int page = 0;
  bool isLoading;

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() {
    setState(() { isLoading = true; });

    NetworkManager.httpGet(Globals.baseUrl + "provider/convertations",  context, (r) { // chat/conversations?page=$page

      setState(() { isLoading = false; });

      if (r['state'] == true) {
        setState(() {
          // page++;
          data[page] = r['data'];// data[r['page']] = r['data'];
        });
      }
    }, cashable: true);
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
                            LanguageManager.getText(36),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          NotificationIcon(),
                        ],
                      ))),
          Expanded(
            child: getChatConversations(),
          )
        ],
      ),
    );
  }

  Widget getChatConversations() {
    List<Widget> items = [];
    for (var page in data.keys) {
      for (var item in data[page]) {
        items.add(getConversationItem(item));
      }
    }

    if (items.length == 0 && isLoading) {
      return Container(
        alignment: Alignment.center,
        child: CustomLoading(),
      );
    } else if (data[0].length == 0 && !isLoading) { // items.length > 0 && data[0].length == 0
      return EmptyPage("conversation", 97);
    }

    return Recycler(
      children: items,
      onScrollDown: () {
        // if (!isLoading) {
        //   if (data.length > 0 && data[0].length == 0) return;
        //   load();
        // }
      },
    );
  }

  Widget getConversationItem(item) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => LiveChat(item["user_id"].toString())));
      },
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 3),
                  color: Colors.black.withAlpha(10),
                  spreadRadius: 2,
                  blurRadius: 2)
            ]),
        child: Row(
          textDirection: LanguageManager.getTextDirection(),
          children: [
            Container(
              margin: EdgeInsets.all(10),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  image: DecorationImage(image: CachedNetworkImageProvider(Globals.correctLink(item['user']['image']))),
                  borderRadius: BorderRadius.circular(10)),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: LanguageManager.getTextDirection(),
              children: [
                Text(
                  item['user']['name']??'',
                  textDirection: LanguageManager.getTextDirection(),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Converter.hexToColor("#2094CD")),
                ),
                item['last_chat_date'] == false
                    ? Container()
                    : Text(
                        Converter.getRealTime(item['last_chat_date']),
                        textDirection: LanguageManager.getTextDirection(),
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Converter.hexToColor("#707070")),
                      )
              ],
            )),
            Container(
              child: Icon(
                LanguageManager.getDirection()
                    ? FlutterIcons.chevron_left_fea
                    : FlutterIcons.chevron_right_fea,
                color: Converter.hexToColor("#2094CD"),
                size: 24,
              ),
            ),
            Container(
              width: 15,
            )
          ],
        ),
      ),
    );
  }
}
