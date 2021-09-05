import 'package:dr_tech/Components/CustomLoading.dart';
import 'package:dr_tech/Config/initialization.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:dr_tech/Models/UserManager.dart';
import 'package:dr_tech/Pages/Welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      theme: ThemeData(
        fontFamily: "Cario",
        primarySwatch: Colors.blue,
      ),
      home:Welcome()
      // DatabaseManager.load("welcome") != true
      //     ? Welcome()
      //     : Home()
      // UserManager.currentUser("id").isNotEmpty
      //         ? Home()
      //         : Login(),
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
