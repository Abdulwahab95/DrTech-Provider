import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dr_tech/Components/Alert.dart';
import 'package:dr_tech/Components/CustomBehavior.dart';
import 'package:dr_tech/Config/Converter.dart';
import 'package:dr_tech/Config/Globals.dart';
import 'package:dr_tech/Models/DatabaseManager.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:dr_tech/Network/NetworkManager.dart';
import 'package:dr_tech/Pages/EnterCode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:vibration/vibration.dart';

import 'ExtraPages/Terms.dart';

class Login extends StatefulWidget {
  const Login();

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Map selectedCountrieCode = {}, body = {}, errors = {};
  double logoSize = 0.3;
  List countries = [];
  bool accepted = true;

  @override
  void initState() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {logoSize = visible ? 0.2 : 0.3;});
      },
    );
    selectedCountrieCode["code"] = DatabaseManager.liveDatabase["country"];
    selectedCountrieCode["phone_code"] = "+966";
    var countries = Globals.getConfig("countries");
    if (countries != "") {
      for (var item in countries) {
        if (item["code"].toString().toLowerCase() ==
            selectedCountrieCode["code"].toString().toLowerCase()) {
          selectedCountrieCode["phone_code"] = item["country_code"];
        }
        this.countries.add({
          "code": item["code"],
          "id": item["id"],
          "phone_code": item["country_code"],
          "text": item["name"],
          "icon": Globals.baseUrl + "storage/flags/" + item["code"].toString().toLowerCase(),
        });
      }
    }
    body["country"] = selectedCountrieCode["code"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 70,
        title: Container(
          margin: EdgeInsets.only(top: 15),
          child: Text(
              LanguageManager.getText(276), // أدخل رقم هاتفك
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        elevation: 1.5,
        backgroundColor: Converter.hexToColor("#2094cd"),
      ),

      body: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 150),
            alignment: Alignment.center,
            padding: EdgeInsets.all(
                MediaQuery.of(context).size.width * logoSize * 0.25),
            height: MediaQuery.of(context).size.height * logoSize,
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.asset("assets/images/logo.png"),
            ),
          ),

          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: ScrollConfiguration(
                behavior: CustomBehavior(),
                child: ListView(
                  // physics: logoSize > 0.15 ? NeverScrollableScrollPhysics() : null,
                  children: [
                    AnimatedContainer(
                        duration: Duration(milliseconds: 250),
                        decoration: BoxDecoration(
                            color: Converter.hexToColor(errors["phone"] == true
                                ? "#f59d97"
                                : "#f2f2f2"),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          textDirection: LanguageManager.getTextDirection(),
                          children: [
                            Container(
                              width: 45,
                              alignment: Alignment.center,
                              child: Icon(FlutterIcons.phone_iphone_mdi,
                                  size: 22,
                                  color: Converter.hexToColor("#858585")),
                            ),
                            Expanded(
                                child: TextField(
                                  onChanged: (v) {
                                    body["phone"] = v;
                                    setState(() {errors['phone'] = false;});
                                  },
                                  keyboardType: TextInputType.phone,
                                  textDirection: LanguageManager.getTextDirection(),
                                  textAlign: LanguageManager.getDirection()
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(fontSize: 14),
                                      hintText: LanguageManager.getText(6)), // رقم الهاتف
                                )),
                            InkWell(
                              onTap: () {
                                hideKeyBoard();
                                Alert.show(context, countries, onSelected: (selcted) {
                                  setState(() {
                                    selectedCountrieCode = selcted;
                                    body["country"] = selectedCountrieCode["code"];
                                  });
                                }, type: AlertType.SELECT);
                              },
                              child: Row(
                                textDirection:
                                LanguageManager.getTextDirection(),
                                children: [
                                  Container(
                                    child: Text(selectedCountrieCode["phone_code"]),
                                  ),
                                  Container(
                                    width: 6,
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(5),
                                          width: 35,
                                          height: 24,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(2),
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: CachedNetworkImageProvider(
                                                      Globals.baseUrl +
                                                          "storage/flags/" +
                                                          selectedCountrieCode[
                                                          "code"]))),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 12,
                            )
                          ],
                        )),
                    Container(height: MediaQuery.of(context).size.height * 0.02),

                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      padding: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: Converter.hexToColor(errors['accepted'] == true
                              ? "#ffd1ce"
                              : "#ffffff00"),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(

                        textDirection: LanguageManager.getTextDirection(),
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(value: accepted, onChanged: (v) {setState(() {accepted = v;});}),
                          Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  LanguageManager.getText(8),//من خلال النقر على التالي فإنك تقر بانك قد قرأت سياسة الخصوصية و توافق على شروط التطبيق
                                  textDirection: LanguageManager.getTextDirection(),
                                  style: TextStyle(
                                      fontSize: 13,
                                      height: 1.5,
                                      color: Converter.hexToColor("#20313e")),
                                ),
                              ))
                        ],
                      ),
                    ),

                    Container(height: MediaQuery.of(context).size.height * 0.02),

                    InkWell(
                      onTap: login,
                      child: Container(
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Converter.hexToColor("#344f64"),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          LanguageManager.getText(3), // التالي
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Container(height: logoSize > 0.15 ? MediaQuery.of(context).size.height * 0.20 : 20),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: InkWell(
                        onTap: goToTerms,
                        child: Text(
                            LanguageManager.getText(59),//سياسة الخصوصية
                            style: TextStyle(fontSize: 14,color: Converter.hexToColor("#344f64")),
                            textAlign: TextAlign.center
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void goToTerms() {Navigator.push(context, MaterialPageRoute(builder: (_) => Terms()));}

  void login() {
    hideKeyBoard();
    setState(() {errors = {};});

    if (body['phone'].toString().length < 9) {
      setState(() {errors['phone'] = true;});
    }

    if (errors.keys.length > 0) {
      vibrate();
      return;
    }

    if (!accepted) {
      errors['accepted'] = true;
      Timer(Duration(milliseconds: 500), () {
        if (errors.containsKey("accepted")) {
          setState(() {errors.remove("accepted");});
        }
      });
      vibrate();
      return;
    }

    Alert.startLoading(context);

    body["type"] = 'USER';
    NetworkManager.httpPost(Globals.baseUrl + "user/login", (r) {
      Alert.endLoading();
      if (r['status'] == true) {
        DatabaseManager.liveDatabase[Globals.authoKey] = r['token'];
        Navigator.push(context, MaterialPageRoute(builder: (_) => EnterCode()))
            .then((value) {
          print('heree: back_here $value');

        });
      } else if (r['message'] != null) {
        Alert.show(context, Converter.getRealText(r['message']));
      }
    }, body: body);
  }

  void hideKeyBoard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild.unfocus();
    }
  }

  void vibrate() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate();
    }
  }


}
