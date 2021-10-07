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
      this.parse(message.data);
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


  }

  void parse(Map<String, dynamic> paylaod) {
    var data = paylaod;
    Map dataa = json.decode(paylaod['payload']);
    if (data["conversation_id"] != null) {
      if (LiveChat.currentConversationId == data["conversation_id"]) {
        if (LiveChat.callback != null) {
          if (data['payload'].runtimeType == String)
            LiveChat.callback(data['payload_target'], jsonDecode(data['payload']));
          else
            LiveChat.callback(data['payload_target'], data['payload']);
        }
      } else if (dataa != null && dataa.containsKey('id')) {
        LocalNotifications.send('message', dataa['message'], dataa);
      }
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
    firebaseCloudMessagingListeners(callBack);
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
