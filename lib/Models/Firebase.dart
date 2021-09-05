import 'dart:convert';
import 'dart:io';

import 'package:dr_tech/Config/Globals.dart';
import 'package:dr_tech/Pages/LiveChat.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Firebase {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Firebase(callBack) {
    firebaseCloudMessagingListeners(callBack);
  }
  void firebaseCloudMessagingListeners(Function callBack) {
    _firebaseMessaging.getToken().then((token) {
      Globals.deviceToken = token;
    });

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //
    // });
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     this.parse(message);
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     UserManager.refrashUserInfo();
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     UserManager.refrashUserInfo();
    //   },
    // );

    if (Platform.isIOS)
      iosPermission(callBack);
    else
      callBack();
  }

  Future<void> iosPermission(Function callback) async {
    NotificationSettings settings =  await  _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    callback();

    // _firebaseMessaging.onIosSettingsRegistered
    //     .listen((IosNotificationSettings settings) {
    //   callback();
    // });
  }

  void parse(Map<String, dynamic> paylaod) {
    var data = paylaod['data'];
    if (data["conversation_id"] != null) {
      if (LiveChat.currentConversationId == data["conversation_id"]) {
        if (LiveChat.callback != null) {
          if (data['payload'].runtimeType == String)
            LiveChat.callback(
                data['payload_target'], jsonDecode(data['payload']));
          else
            LiveChat.callback(data['payload_target'], data['payload']);
        }
      }
    }
  }
}
