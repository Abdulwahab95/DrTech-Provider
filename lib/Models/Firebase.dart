import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dr_tech/Config/Globals.dart';
import 'package:dr_tech/Pages/LiveChat.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import 'LocalNotifications.dart';


class MessageHandler extends StatefulWidget {
  final Widget child;
  MessageHandler({this.child});
  @override
  State createState() => MessageHandlerState();
}


class MessageHandlerState extends State<MessageHandler> {

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Globals.logNotification('onMessage', message);
      this.parse(message.data, message.notification);
    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) { // onReusem
      Globals.logNotification('onMessageOpenedApp', message);
      Globals.currentConversationId = message.data["conversation_id"];
      Globals.isOpenFromNotification = true;
      Navigator.of(LocalNotifications.reminderScreenNavigatorKey.currentState.context).pushNamed("LiveChat");
    });


    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message) { // onOpen
      Globals.logNotification('getInitialMessage', message);
      if(message != null) {
        String screen = message.data['screen']; print(screen);
        if (screen.contains("LiveChat")) {
          print('heree: LiveChat');
          Globals.isOpenFromNotification = true;
          Globals.currentConversationId = message.data["conversation_id"];
          // Navigator.of(context).pushNamed("LiveChat");
        }
      }
    });

    // Timer(Duration(seconds: 10), () {
    //   print('here_timer: ');
    //   RemoteMessage message =RemoteMessage.fromMap({
    //     "to": "cGWIGoTDRlunHuhL-UTBRb:APA91bGoDrjEsT8uLq8AqGfCNWfpy2SBsFaiWjKwZrcanQVZWwiNVSPKVfySvsAH10wIBPpO7dFK1sPma9w71Lzbb3MLC8Sm-gyCII4pZjlNitGwoSnU5HRZwb1iasQ0VrFuCFm-xrJm",
    //     "priority": "high",
    //     "url": "",
    //     "title": "title",
    //     "body": "body",
    //     "message": null,
    //     "type": "NOTIC",
    //     "data": {
    //       "title": "message",
    //       "message_txt": "",
    //       "payload_target": "info",
    //       "priority": "high",
    //       "screen": "LiveChat",
    //       "content_available": true,
    //       "click_action": "FLUTTER_NOTIFICATION_CLICK",
    //       "conversation_id": "3",
    //       "payload": {
    //         "type": "seen"
    //       }
    //     }
    //   });
    //   this.parse(message.data, message.notification);
    //   // UserManager.updateSp('not_seen', 0);
    //   // Globals.updateNotificationCount();
    //
    //   // Timer(Duration(seconds: 4), () {
    //   //   print('here_timer: ');
    //   //   UserManager.updateSp('not_seen', 1);
    //   //   Globals.updateNotificationCount();
    //   // });
    //
    // });
  }

  void parse(Map<String, dynamic> data, RemoteNotification notification) {
    print('here_timer: data: $data');
    Map payload = data['payload'].runtimeType == String? json.decode(data['payload']) : data['payload'];
    if (data["conversation_id"] != null) {
      print('here_timer: if 1');
      if (LiveChat.currentConversationId == data["conversation_id"].toString()) {
        print('here_timer: if 2');
        if (LiveChat.callback != null) {
          print('here_timer: if 3');
          if (data['payload'].runtimeType == String)
            LiveChat.callback(data['payload_target'], jsonDecode(data['payload']));
          else
            LiveChat.callback(data['payload_target'], data['payload']);
        }
      } else if (data != null && payload != null && payload['text'] != null && payload['text'] == 'USER_TYPING'){ // USER_TYPING
        // USER_TYPING and user not on screen liveChat => don't show notification
      } else if (data != null && payload != null && payload['type'] != null && payload['type'] == 'seen'){ // seen
        // seen and user not on screen liveChat => don't show notification
      } else if (data != null) {
        print('here_timer: else 2');
        LocalNotifications.send(data['title'],data['message_txt'], payload);
      }
    } else {
      print('here_timer: else 1');
      LocalNotifications.send(notification.title, notification.body, payload);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

}


class FirebaseClass {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FirebaseClass(callBack) {
    LocalNotifications.init();
    Globals.isLocal? callBack(): firebaseCloudMessagingListeners(callBack);
  }

  void firebaseCloudMessagingListeners(Function callBack) {

    _firebaseMessaging.getToken().then((token) {
      Globals.deviceToken = token;
    });

    if (Platform.isIOS)
      iosPermission(callBack);
    else {
      callBack();
    }
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

  }


}




// class Firebase {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   Firebase(callBack) {
//     firebaseCloudMessagingListeners(callBack);
//   }
//   void firebaseCloudMessagingListeners(Function callBack) {
//     _firebaseMessaging.getToken().then((token) {
//       Globals.deviceToken = token;
//     });
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('herer: ${message.data}');
//       this.parse(message.data);
//     });
//     // _firebaseMessaging.configure(
//     //   onMessage: (Map<String, dynamic> message) async {
//     //     this.parse(message);
//     //   },
//     //   onResume: (Map<String, dynamic> message) async {
//     //     UserManager.refrashUserInfo();
//     //   },
//     //   onLaunch: (Map<String, dynamic> message) async {
//     //     UserManager.refrashUserInfo();
//     //   },
//     // );
//
//     if (Platform.isIOS)
//       iosPermission(callBack);
//     else
//       callBack();
//   }
//
//   Future<void> iosPermission(Function callback) async {
//     NotificationSettings settings =  await  _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }
//     callback();
//
//     // _firebaseMessaging.onIosSettingsRegistered
//     //     .listen((IosNotificationSettings settings) {
//     //   callback();
//     // });
//   }
//
//   void parse(Map<String, dynamic> paylaod) {
//     var data = paylaod;
//     if (data["conversation_id"] != null) {
//       if (LiveChat.currentConversationId == data["conversation_id"]) {
//         if (LiveChat.callback != null) {
//           if (data['payload'].runtimeType == String)
//             LiveChat.callback(
//                 data['payload_target'], jsonDecode(data['payload']));
//           else
//             LiveChat.callback(data['payload_target'], data['payload']);
//         }
//       }
//     }
//   }
// }
