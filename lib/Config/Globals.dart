import 'dart:io';

import 'package:dr_tech/Models/DatabaseManager.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Globals {
  static String deviceToken = "";
  static Map deviceInfo = {};
  static String version = "0.0.1";
  static String buildNumber = "1";
  static var config;
  static String authoKey = "x-autho";
  static String baseUrl = "https://server.drtechapp.com/";
  static String shareUrl = "https://share.drtechapp.com/";
  static String appFont = "Cario";
  static SharedPreferences sharedPreferences;
  static dynamic data = [];
  // Callbacks
  static Function updateInCartCount;
  static var settings;
  // Chat + Notification
  static String currentConversationId = '';
  static bool isOpenFromNotification = false;
  static bool isOpenFromTerminate = false;
  static var pagesRouteFactories;


  static void logNotification(String s, RemoteMessage message) {
    print('---------------Start--logNotification-- $s --------------------');
    if(message != null){
      print("heree: ${message.messageId ?? ''}");
      print("heree: ${message ?? ''}");
      print("heree: notification: ${message.notification ?? ''}");
      print("heree: data: ${message.data ?? ''}");
    }
    print('---------------End--logNotification---------------------------');
  }


  static bool checkUpdate(){
    for (var item in settings) {
      if(item['name'] == 'under_maintenance' && item['value'] == 'true'){
        return true;
      }
    }
    return false;
  }

  static bool showNotOriginal(){
    for (var item in settings) {
      if(item['name'] == 'not_original' && item['value'] == 'true'){
        return true;
      }
    }
    return false;
  }


  static String getWebViewUrl() {
    String url = "";
    for (var item in settings) {
      if(item['name'] == 'webview_url'){
        url = item['value'];
      }
    }

    print('urlImg: $url');

    return url.isNotEmpty ?url: "";
  }

  static Map<String, String> header() {
    Map<String, String> header = {
      authoKey: DatabaseManager.load(authoKey) ?? "",
      "x-os": kIsWeb ? "web" : (Platform.isIOS ? "ios" : "Android"),
      "x-app-version": version,
      "x-build-number": buildNumber,
      "x-token": deviceToken
    };
    if (DatabaseManager.liveDatabase[Globals.authoKey] != null) {
      header[Globals.authoKey] = DatabaseManager.liveDatabase[Globals.authoKey];
    }
    /*
    for (var key in Globals.deviceInfo.keys) {
      header["x-" + key] =  Globals.deviceInfo[key].toString().replaceAll(' ','');
    }
*/
    header.addAll(DatabaseManager.getUserSettinsgAsMap());
    return header;
  }

  static dynamic getConfig(key) {
    if (Globals.config == null) return "";
    return Globals.config[key] ?? "";
  }

  static String mapToGet(Map args) {
    List<String> results = [];
    for (var key in args.keys)
      results.add([key.toString(), args[key].toString()].join("="));
    return results.join('&');
  }

  static String getRealText(item) {
    if (item.runtimeType == String && !item.toString().contains(" "))
      item = int.tryParse(item) ?? item;

    RegExp regExp = new RegExp(
      r'(?<={)(.*)(?=})',
      caseSensitive: false,
      multiLine: true,
    );
    var matches = regExp.allMatches(item.toString());
    if (matches.length > 0) {
      for (var match in matches) {
        String key = match.group(0);
        item = item.toString().replaceAll('{' + key + '}', getRealText(key));
      }
    }

    return item.runtimeType == int
        ? LanguageManager.getText(item)
        : item.toString() ?? "";
  }

}
