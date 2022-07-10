import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dr_tech/Components/Alert.dart';
import 'package:dr_tech/Components/CustomBehavior.dart';
import 'package:dr_tech/Components/CustomLoading.dart';
import 'package:dr_tech/Components/TitleBar.dart';
import 'package:dr_tech/Config/Converter.dart';
import 'package:dr_tech/Config/Globals.dart';
import 'package:dr_tech/Models/LanguageManager.dart';
import 'package:dr_tech/Models/UserManager.dart';
import 'package:dr_tech/Network/NetworkManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  final data;
  const AddProduct({this.data});

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  Map<String, String> body = {}, selectedTexts = {}, errors = {};
  Map selectOptions = {};
  List images = [], removedImagesUpdate = [];
  Map<String, TextEditingController> controllers = {};
  bool isLoading = true, showExtraOptions = true;
  List<Map> selectedFiles = [];
  var config;
  @override
  void initState() {
    // body["guarantee"] = "0";
    // body["used"] = "0";
    Future.delayed(Duration.zero, () {
      loadConfig();
    });
    super.initState();
  }

  void loadConfig() {
    setState(() {
      isLoading = true;
    });
    var r = {
      "state": true,
      "catigories": [
        {
          "id": "1",
          "name": "قسم الجوالات",
          "name_en": "",
          "parent_id": "0",
          "icon": "https:\/\/server.drtechapp.com\/storage\/images\/camera.svg",
          "created_at": "2021-07-12 08:09:42",
          "children": [
            {
              "id": "3",
              "name": "ايفون",
              "name_en": "",
              "parent_id": "1",
              "icon": "https:\/\/server.drtechapp.com\/storage\/images\/camera.svg",
              "created_at": "2021-07-12 08:09:42",
              "children": [
                {
                  "id": "6",
                  "name": "iphone 5S",
                  "name_en": "",
                  "parent_id": "3",
                  "icon": "https:\/\/server.drtechapp.com\/storage\/images\/",
                  "created_at": "2021-07-12 08:09:42",
                  "children": []
                }
              ]
            },
            {
              "id": "4",
              "name": "سامسونج",
              "name_en": "",
              "parent_id": "1",
              "icon": "https:\/\/server.drtechapp.com\/storage\/images\/camera.svg",
              "created_at": "2021-07-12 08:09:42",
              "children": []
            },
            {
              "id": "5",
              "name": "هواوي",
              "name_en": "",
              "parent_id": "1",
              "icon": "https:\/\/server.drtechapp.com\/storage\/images\/camera.svg",
              "created_at": "2021-07-12 08:09:42",
              "children": []
            }
          ],
          "extra_options": true
        },
        {
          "id": "2",
          "name": "قسم الاكسسوارات ",
          "name_en": "",
          "parent_id": "0",
          "icon": "https:\/\/server.drtechapp.com\/storage\/images\/camera.svg",
          "created_at": "2021-07-12 08:09:42",
          "children": []
        }
      ],
      "cities": [
        {
          "id": "8363",
          "name": "مكة",
          "name_en": "",
          "country_id": "191",
          "text": "مكة",
          "children": [
            {
              "id": "633",
              "name": "الرياض",
              "name_en": "",
              "city_id": "8363",
              "text": "الرياض"
            }
          ]
        },
        {
          "id": "8364",
          "name": "جدة",
          "name_en": "",
          "country_id": "191",
          "text": "جدة",
          "children": [
            {
              "id": "634",
              "name": "المدينة المنورة",
              "name_en": "",
              "city_id": "8364",
              "text": "المدينة المنورة"
            }
          ]
        }
      ],
      "colors": [
        {
          "id": "1",
          "name": "احمر",
          "name_en": "",
          "created_at": "2021-07-12 13:55:45"
        },
        {
          "id": "2",
          "name": "اسود",
          "name_en": "",
          "created_at": "2021-07-12 13:55:45"
        }
      ],
      "store_product_duration": [
        {
          "id": "1",
          "name": "3 ايام",
          "name_en": "",
          "days": "3",
          "created_at": "2022-06-12 00:00:00"
        },
        {
          "id": "2",
          "name": "شهر",
          "name_en": "",
          "days": "30",
          "created_at": "2022-06-12 00:00:00"
        }
      ]
    };
    NetworkManager.httpPost(Globals.baseUrl + "store/configuration", context, (r) { //
      // product/configuration
      isLoading = false;
      setState(() {});
    if (r['state'] == true) {
      setState(() {
        config = r['data'];
      });
      if(widget.data != null)
        fillData(widget.data);
    }
    }, cachable: false, body: {'provider_id': UserManager.currentUser('id')});
  }


  void fillData(data) {
    body["id"] = data['id'].toString();
    body["title"] = data['name'];
    body["title_en"] = data['name_en'];
    body["catigory"] = data['product_category_id'].toString();
    body["city"] = data['city_id'].toString();
    body["type"] = data['product_type_id'].toString();
    // body["brand"] = data['product_type_id'];
    // // body["model"] = data['product_model_id'];
    body["color"] = data['color'];
    body["duration_of_use"] = data['duration_of_use'];
    body["disk_info"] = data['disk_info'].toString();
    body["guarantee"] = data['guarantee'].toString();
    body["status"] = data['status'].toString().toUpperCase();
    body["isOffer"] = data['is_offer'].toString();
    body["offer_price"] = data['offer_price'].toString();
    body["price"] = data['price'].toString();
    body["description"] = data['description'];
    body["payment_method"] = jsonEncode(data['payment_method']);

    images = data['images'];
    selectedTexts["title"] = data['name'];
    selectedTexts["title_en"] = data['name_en'];

    if(isArrayNotEmpty(LanguageManager.getDirection() ? 'name' : 'name_en', map: data['category']))
      selectedTexts["catigory"] = data['category'][LanguageManager.getDirection() ? 'name' : 'name_en'];

    if(isArrayNotEmpty(LanguageManager.getDirection() ? 'name' : 'name_en', map: data['city']))
      selectedTexts["city"] = data['city'][LanguageManager.getDirection()? 'name' : 'name_en'];

    if(isArrayNotEmpty(LanguageManager.getDirection() ? 'name' : 'name_en', map: data['type']))
      selectedTexts["type"] = data['type'][LanguageManager.getDirection()? 'name' : 'name_en'];

    // selectedTexts["brand"] = data['brand'];
    // selectedTexts["model"] = data['model'];
    selectedTexts["color"] = data['color'];
    selectedTexts["duration_of_use"] = data['duration_of_use'];
    selectedTexts["disk_info"] = data['disk_info'].toString();
    selectedTexts["offer_price"] = data['offer_price'] == null? '' :data['offer_price'].toString() ;
    selectedTexts["price"] = data['price'].toString();
    selectedTexts["description"] = data['description'];

    if(data['product_category_id'] != null){
      selectOptions['type'] = (config['catigories'] as List).firstWhere((e) => e['id'] == data['product_category_id'])['children'];
    }
  }


  void send() {
    print('here_body: $body');
    setState(() {
      errors = {};
    });
    List validateKeys = [
      "title",
      "title_en",
      "catigory",
      "type",
      "city",
      "color",
      "price",
      "description",
    ];
    // isOffer
    // offer_price

    if (selectedTexts["catigory"] == 'قسم الجوالات' || selectedTexts["catigory"] == 'Mobiles department')
      validateKeys.add("disk_info");
    else
      validateKeys.remove("disk_info");

    if (body['status'] == 'USED') {
      validateKeys.add("duration_of_use");
      body['status'] = 'USED';
    }else
      validateKeys.remove("duration_of_use");

    if (body["isOffer"] == "1")
      validateKeys.add("offer_price");
    else
      validateKeys.remove("offer_price");

    for (var key in validateKeys) {
      if (!isArrayNotEmpty(key, map: body))
        setState(() {
          errors[key] = "_";
        });
    }

    if (selectedFiles.length == 0 && images.length == 0) {
      errors["images"] = "_";
    }

    print('here_body: $body');
    print('here_errors: $errors');
    if (errors.keys.length > 0) return;

    if(!isArrayNotEmpty('id', map: body))
      body['user_id'] = UserManager.currentUser('id');

    List files = [];
    // body["images_length"] = selectedFiles.length.toString();
    //
    for (var i = 0; i < selectedFiles.length; i++) {
      var item = selectedFiles[i];
      files.add({
        "name": "image_$i",
        "file": item['data'],
        "type_name": "image",
        "file_type": item['type'],
        "file_name": "${DateTime.now().toString().replaceAll(' ', '_')}.${item['type']}"
      });
    }

    List toRemove  = [];
    body.forEach((key, value) {
      if(value == null || value.toString() == 'null')
        toRemove .add(key);
    });
    print('here_body_filter_before: $body');
    body.removeWhere((key, value) => toRemove.contains(key));
    print('here_body_filter_after: $body');


    Alert.startLoading(context);
    Globals.hideKeyBoard(context);
    NetworkManager().fileUpload(
        Globals.baseUrl + "product/" + (!isArrayNotEmpty('id', map: body)? 'create' : 'update/${body['id']}')
          , files, (p) {}, (r) {
          Alert.endLoading();
          if (r["state"] == true) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        }, body: body);
  }

  void pickImage(ImageSource source) async {
    try {
      ImagePicker _picker = ImagePicker();

      PickedFile pickedFile = await _picker.getImage(
          source: source, maxWidth: 1024, imageQuality: 50);
      if (pickedFile == null) return;
      var extantion = pickedFile.path.split(".").last;
      Uint8List data = await pickedFile.readAsBytes();
      setState(() {
        selectedFiles.add({"type": extantion, "data": data});
      });
    } catch (e) {
      Alert.show(context, LanguageManager.getText(27));
      // error
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          TitleBar(() {Navigator.pop(context);}, isArrayNotEmpty('id', map: widget.data)? 176 : 144),
          isLoading
              ? Expanded(child: Center(child: CustomLoading()))
              : Expanded(
              child: ScrollConfiguration(
                behavior: CustomBehavior(),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  children: getFormInputs(),
                ),
              ))
        ]));
  }

  List<Widget> getFormInputs() {

    List<Widget> items = [];

    items.add(createInput("title", 145));
    items.add(createInput("title_en", 468));
    items.add(createSelectInput("catigory", 146, config['catigories'],
        onSelected: (v) {
          setState(() {
            selectedTexts["catigory"] = v['name'];
            body["catigory"] = v['id'].toString();
            selectOptions["type"] = v['children'];
            showExtraOptions = v['extra_options'] == true;
            print('here_selectOptions: $selectOptions');

            // clear
            // selectedTexts.remove("brand");
            // body.remove("brand");
            // selectOptions.remove("type");
            body.remove("type");
            selectedTexts.remove("type");

            selectedTexts.remove("disk_info");
            body.remove("disk_info");
          });
        }));
    items.add(createSelectInput("type", 147, selectOptions["type"],
        onEmptyMessage: LanguageManager.getText(160), onSelected: (v) {
          setState(() {
            selectedTexts["type"] = v['name'];
            body["type"] = v['id'].toString();
          });
        }));
    items.add(createSelectInput("city", 107, config['provider_citis'], onSelected: (v) {
      setState(() {
        selectedTexts["city"] = v[LanguageManager.getDirection()? 'name' : 'name_en'];
        body["city"] = v['id'].toString();
      });
    }));
    // items.add(createSelectInput("brand", 147, selectOptions["brand"],
    //     onEmptyMessage: LanguageManager.getText(160), onSelected: (v) {
    //       setState(() {
    //         selectedTexts["brand"] = v['name'];
    //         body["brand"] = v['id'];
    //         selectOptions["model"] = v['children'];
    //       });
    //     }));
    items.add(createInput("color", 149));

    if (selectedTexts["catigory"] == 'قسم الجوالات' || selectedTexts["catigory"] == 'Mobiles department')
      items.add(createInput("disk_info", 151));

    // items.add(createSelectInput(
    //     "store_product_duration", 152, config["store_product_duration"],
    //     onSelected: (v) {
    //       setState(() {
    //         selectedTexts["store_product_duration"] = v['name'];
    //         body["store_product_duration"] = v['id'];
    //       });
    //     }));

    items.add(createDuleOptions("guarantee", 153, 155, 156, body["guarantee"] == "1"));
    items.add(createDuleOptions("status", 154, 142, 143, body["status"] == 'NEW'));
    items.add(createDuleOptions("payment_method", 126, 140, 135, body["payment_method"], other: 134 ));
    if (body["status"] == 'USED') items.add(createInput("duration_of_use", 150));

    items.add(createInput("price", 95, textType: TextInputType.number));
    items.add(createInput("description", 159, textType: TextInputType.text, maxLines: 4));
    items.add(Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: Row(
          textDirection: LanguageManager.getTextDirection(),
          children: [
            Expanded(
                child: Text(LanguageManager.getText(157),
                    textDirection: LanguageManager.getTextDirection(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Converter.hexToColor("#2094CD"),
                    ))),
            Switch(
                value: body["isOffer"] == "1",
                onChanged: (v) {
                  setState(() {
                    body["isOffer"] = v ? "1" : "0";
                  });
                })
          ],
        )));
    if(body["isOffer"] == "1")
      items.add(createInput("offer_price", 158, textType: TextInputType.number));
    items.add(Container(
      height: 5,
    ));
    items.add(createImagesUploaded());
    items.add(createImagesPicker());
    items.add(Container(
      height: 5,
    ));

    items.add(Row(
      textDirection: LanguageManager.getTextDirection(),
      children: [
        Expanded(
          child: InkWell(
            onTap: (!isArrayNotEmpty('id', map: body))? send : confirmUpdate,
            child: Container(
              margin: EdgeInsets.all(10),
              height: 45,
              alignment: Alignment.center,
              child: Text(
                LanguageManager.getText(isArrayNotEmpty('id', map: widget.data) ? 177 : 161),
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(15),
                        spreadRadius: 2,
                        blurRadius: 2)
                  ],
                  borderRadius: BorderRadius.circular(8),
                  color: Converter.hexToColor("#344f64")),
            ),
          ),
        ),
      ],
    ));
    return items;
  }

  Widget createImagesPicker() {
    double size = (MediaQuery.of(context).size.width - 20) * 0.25;
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Converter.hexToColor(
              errors["images"] != null ? "#E9B3B3" : "#ffffff")),
      child: Wrap(
        textDirection: LanguageManager.getTextDirection(),
        children: selectedFiles.map((e) {
          return Container(
              width: size,
              height: size,
              padding: EdgeInsets.all(10),
              child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withAlpha(25),
                            spreadRadius: 2,
                            blurRadius: 2)
                      ],
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  child: Stack(
                    children: [
                      Image.memory(e["data"]),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedFiles.remove(e);
                            });
                          },
                          child: Container(
                              width: 24,
                              height: 24,
                              color: Colors.white,
                              child: Icon(
                                Icons.delete,
                                size: 22,
                              )),
                        ),
                      )
                    ],
                  )));
        }).toList()
          ..add(Container(
            width: size,
            height: size,
            padding: EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                pickImage(ImageSource.gallery);
              },
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(25),
                      spreadRadius: 2,
                      blurRadius: 2)
                ], borderRadius: BorderRadius.circular(5), color: Colors.white),
                alignment: Alignment.center,
                child: Icon(
                  FlutterIcons.upload_faw,
                  size: 25,
                ),
              ),
            ),
          )),
      ),
    );
  }

  Widget createImagesUploaded() {
    double size = (MediaQuery.of(context).size.width - 20) * 0.25;
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Converter.hexToColor("#ffffff")),
      child: Wrap(
          textDirection: LanguageManager.getTextDirection(),
          children: images.map((e) {
            print('here_images: e: $e, images: $images');
            return Container(
                width: size,
                height: size,
                padding: EdgeInsets.all(10),
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withAlpha(25),
                              spreadRadius: 2,
                              blurRadius: 2)
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    child: Stack(
                      children: [
                        CachedNetworkImage(imageUrl: Globals.correctLink(e)),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                images.remove(e);
                                removedImagesUpdate.add(e);
                                body["removed_images"] =
                                    jsonEncode(removedImagesUpdate);
                              });
                            },
                            child: Container(
                                width: 24,
                                height: 24,
                                color: Colors.white,
                                child: Icon(
                                  Icons.delete,
                                  size: 22,
                                )),
                          ),
                        )
                      ],
                    )));
          }).toList()),
    );
  }

  Widget createDuleOptions(key, title, yesOption, noOption, isActive, {other}) {

    if(!(isActive is bool)&& (!body.containsKey('payment_method')))
      body["payment_method"] = isActive = jsonEncode(["myfatoorah","cash"]);

    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Wrap(
        textDirection: LanguageManager.getTextDirection(),
        children: [
          Row(
              textDirection: LanguageManager.getTextDirection(),
              mainAxisSize: other != null ? MainAxisSize.max : MainAxisSize.min,
              children: [
                Text(
                  LanguageManager.getText(title),
                  textDirection: LanguageManager.getTextDirection(),
                  style: TextStyle(
                      fontSize: 16,
                      color: Converter.hexToColor("#2094CD"),
                      fontWeight: FontWeight.bold),
                ),
                Container(width: 20),
              ]),
          if(other != null)
          Container(height: 10,),
          GestureDetector(
            onTap: () {
              setState(() {
                body[key] = "1";
                print('here_remove_duration_of_use');
                if(key == 'status') {
                  body.remove("duration_of_use");
                  body[key] = "NEW";
                }
                if(!(isActive is bool))
                  body["payment_method"] = jsonEncode(["myfatoorah","cash"]);
              });
            },
            child: Row(
              textDirection: LanguageManager.getTextDirection(),
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(width: 2, color: Colors.grey)),
                    child: (isActive is bool? isActive : body["payment_method"] == jsonEncode(["myfatoorah","cash"]))
                        ? Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey),
                    )
                        : null,
                  ),
                ),
                Container(
                  width: 10,
                ),
                Text(
                  LanguageManager.getText(yesOption),
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          Container(
            width: 30,
          ),
          InkWell(
            onTap: () {
              setState(() {
                body[key] = "0";
                if(key == 'status') {
                  body[key] = "USED";
                }
                if(!(isActive is bool))
                  body["payment_method"] = jsonEncode(["myfatoorah"]);
              });
            },
            child: Row(
              textDirection: LanguageManager.getTextDirection(),
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(width: 2, color: Colors.grey)),
                    child: (isActive is bool? !isActive : body["payment_method"]== jsonEncode(["myfatoorah"]))
                        ? Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey),
                    )
                        : null,
                  ),
                ),
                Container(
                  width: 10,
                ),
                Text(
                  LanguageManager.getText(noOption),
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          if(other != null)
          Container(
            width: 30,
          ),
          if(other != null)
          InkWell(
            onTap: () {
              setState(() {
                body[key] = "0";
                if(key == 'status') {
                  body[key] = "USED";
                }
                if(!(isActive is bool))
                  body["payment_method"] = jsonEncode(["cash"]);
              });
            },
            child: Row(
              textDirection: LanguageManager.getTextDirection(),
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(width: 2, color: Colors.grey)),
                    child: (isActive is bool? !isActive : body["payment_method"]== jsonEncode(["cash"]))
                        ? Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey),
                    )
                        : null,
                  ),
                ),
                Container(
                  width: 10,
                ),
                Text(
                  LanguageManager.getText(other),
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget createSelectInput(key, title, options, {onEmptyMessage, onSelected}) {
    return GestureDetector(
      onTap: () {
        hideKeyBoard();
        if (options == null) {
          Alert.show(context, onEmptyMessage);
          return;
        }
        Alert.show(context, options,
            type: AlertType.SELECT, onSelected: onSelected);
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        padding: EdgeInsets.only(left: 7, right: 7),
        decoration: BoxDecoration(
            color: Converter.hexToColor(
                errors[key] != null ? "#E9B3B3" : "#F2F2F2"),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          textDirection: LanguageManager.getTextDirection(),
          children: [
            Expanded(
                child: Text(
                  selectedTexts[key] != null
                      ? selectedTexts[key]
                      : LanguageManager.getText(title),
                  textDirection: LanguageManager.getTextDirection(),
                  style: TextStyle(
                      fontSize: 16,
                      color:
                      selectedTexts[key] != null ? Colors.black : Colors.grey),
                )),
            Icon(
              FlutterIcons.chevron_down_fea,
              color: Converter.hexToColor("#727272"),
              size: 22,
            )
          ],
        ),
      ),
    );
  }

  Widget createInput(key, title,
      {maxInput, TextInputType textType: TextInputType.text, maxLines}) {
    if (controllers[key] == null) {
      controllers[key] = TextEditingController(
          text: selectedTexts[key] != null ? selectedTexts[key] : "");
    }
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      padding: EdgeInsets.only(left: 7, right: 7),
      decoration: BoxDecoration(
          color:
          Converter.hexToColor(errors[key] != null ? "#E9B3B3" : "#F2F2F2"),
          borderRadius: BorderRadius.circular(12)),
      child: TextField(
        onChanged: (t) {
          body[key] = t;
        },
        keyboardType: textType,
        maxLength: maxInput,
        maxLines: maxLines,
        controller: controllers[key],
        textDirection: LanguageManager.getTextDirection(),
        decoration: InputDecoration(
            hintText: LanguageManager.getText(title),
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
            hintTextDirection: LanguageManager.getTextDirection(),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0)),
      ),
    );
  }

  void hideKeyBoard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild.unfocus();
    }
  }

  bool isArrayNotEmpty(String s, {Map map}) {
    if(map != null)
      return map.containsKey(s)
          && map[s] != null
          && map[s].toString().toLowerCase() != 'null'
          && map[s].toString().length > 0;

    return selectOptions.containsKey(s)
        && selectOptions[s] != null
        && selectOptions[s].toString().toLowerCase() != 'null'
        && selectOptions[s].length > 0;
  }

  void confirmUpdate() {
    if( widget.data['revision_status'].toString().toUpperCase() != 'ACCEPTED') {send(); return;}
    Alert.show(
        context,
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            textDirection: LanguageManager.getTextDirection(),
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                textDirection: LanguageManager.getTextDirection(),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      FlutterIcons.x_fea,
                      size: 24,
                    ),
                  )
                ],
              ),
              Container(
                child: Icon(
                  FlutterIcons.info_fea,
                  size: 60,
                  color: Converter.hexToColor("#2094CD"),
                ),
              ),
              Container(
                height: 30,
              ),
              Text(
                LanguageManager.getText(471), //  سيتم تحويل المنتج إلى المراجعة من قبل الإدارة هل أنت متأكد من إرسال طلب التعديل؟
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Converter.hexToColor("#707070"),
                    fontWeight: FontWeight.bold),
              ),
              Container(
                height: 30,
              ),
              Row(
                textDirection: LanguageManager.getTextDirection(),
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Alert.publicClose();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: 45,
                      alignment: Alignment.center,
                      child: Text(
                        LanguageManager.getText(172),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withAlpha(15),
                                spreadRadius: 2,
                                blurRadius: 2)
                          ],
                          borderRadius: BorderRadius.circular(8),
                          color: Converter.hexToColor("#344f64")),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      send();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: 45,
                      alignment: Alignment.center,
                      child: Text(
                        LanguageManager.getText(170),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withAlpha(15),
                                spreadRadius: 2,
                                blurRadius: 2)
                          ],
                          borderRadius: BorderRadius.circular(8),
                          color: Converter.hexToColor("#2094CD")),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        type: AlertType.WIDGET);
  }
}
