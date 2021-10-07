import 'dart:convert';

import 'package:dr_tech/Config/Globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  static final GlobalKey<NavigatorState> reminderScreenNavigatorKey = GlobalKey();


  static void init() {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectReminderNotification);
  }

  static void send(title, message, Map<String, dynamic> paylaod) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "NOTIC", "NOTIC", "NOTIC",
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, title, message, platformChannelSpecifics, payload: json.encode(paylaod));
  }

  static Future<dynamic> onSelectReminderNotification([String payload]) async {
    print('heree: _onSelectNotification $payload');
    print('heree: reminderScreenNavigatorKey ${reminderScreenNavigatorKey.currentState}');

    Map valueMap = json.decode(payload);

    Globals.currentConversationId = valueMap['conversation_id'];
    Globals.isOpenFromNotification = true;
    Navigator.of(reminderScreenNavigatorKey.currentState.context).pushNamed("LiveChat");

  }

}
