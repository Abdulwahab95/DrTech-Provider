import 'package:dr_tech/Components/CustomLoading.dart';
import 'package:dr_tech/Config/initialization.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:dr_tech/Models/UserManager.dart';
import 'package:dr_tech/Pages/Welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Config/Globals.dart';
import 'Models/Firebase.dart';
import 'Models/LocalNotifications.dart';
import 'Pages/LiveChat.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  Globals.logNotification('onBackgroundMessage', message);

  // Map dataa = json.decode(message.data['payload']);
  // if (message.data != null && dataa.containsKey('id')) {
  //     LocalNotifications.send('message', message.data['message']);
  // }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Initialization(() {
    UserManager.refrashUserInfo();
    runApp(App());
  });
  runApp(Loading());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Cario", primarySwatch: Colors.blue,),
      navigatorKey: LocalNotifications.reminderScreenNavigatorKey,
      routes: {
        "WelcomePage": (context) => MessageHandler(child: Welcome()),
        "LiveChat": (context) => LiveChat(Globals.currentConversationId),
      },
      initialRoute: "WelcomePage",
    );
  }
}

class Loading extends StatefulWidget {
  const Loading();

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: LanguageManager.getSupportedLocales(),
        locale: LanguageManager.getLocal(),
        home: Scaffold(
            body: Center(
          child: CustomLoading(),
        )));
  }
}
