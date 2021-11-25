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

class AddServices extends StatefulWidget {
  final data;
  AddServices({this.data});

  @override
  _AddServicesState createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices>
    with TickerProviderStateMixin {
  Map<String, String> body = {}, selectedTexts = {}, errors = {};
  Map selectOptions = {}, selectSubcategoriesOptions = {}, selectSub2Options = {},
      selectSub3Options = {},selectSub4Options = {}, config, data;
  List images = [], removedImagesUpdate = [], removedOffers = [];
  Map<String, TextEditingController> controllers = {};
  Map<String, TabController> tabControllers = {};
  bool isLoading = false, isHas3Child = false;
  bool showSelectCountry = false, showSelectCity = false, showSelectStreet = false;
  List<Map> selectedFiles = [], offers = [];

  @override
  void initState() {
    loadConfig();
    super.initState();
  }

  void loadConfig() {
        // setState(() {

          // config = {
          //   "service": [
          //     {
          //       "id": "1",
          //       "service_id": "1",
          //       "name": "اصلاح الجولات",
          //       "name_en": "",
          //       "icon": "0",
          //       "children": [
          //         {
          //           "id": "2",
          //           "service_id": "0",
          //           "name": "تغير الشاشة",
          //           "name_en": "",
          //           "icon": "0",
          //         }
          //       ]
          //     }
          //   ],
          //   "unit": "ريال"
          // };


          // config = {
          //   "service": [
          //     {
          //       "id": 2,
          //       "name": "صيانة الكمبيوترات",
          //       "status": 1,
          //       "categories": []
          //     },
          //     {
          //       "id": 3,
          //       "name": "صيانة الماك",
          //       "status": 1,
          //       "categories": []
          //     },
          //     {
          //       "id": 4,
          //       "name": "الانظمة و التقنية",
          //       "status": 1,
          //       "categories": []
          //     },
          //     {
          //       "id": 5,
          //       "name": "المتجر",
          //       "status": 1,
          //       "categories": []
          //     },
          //     {
          //       "id": 6,
          //       "name": "خدمات الاعمال",
          //       "status": 1,
          //       "categories": []
          //     },
          //     {
          //       "id": 7,
          //       "name": "خدمات الصيانة",
          //       "status": 1,
          //       "categories": [
          //         {
          //           "id": 1,
          //           "name": "صيانة الهواتف",
          //           "status": 1,
          //           "subcategories": [
          //             {
          //               "id": 1,
          //               "name": "هواتف هواوي",
          //               "status": 1
          //             }
          //           ]
          //         },
          //         {
          //           "id": 2,
          //           "name": "صيانة السيارات",
          //           "status": 1,
          //           "subcategories": []
          //         }
          //       ]
          //     }
          //   ],
          //   "unit": "ريال"
          // };

        //   if (widget.id != null) {
        //     load();
        //   } else {
        //     isLoading = false;
        //   }
        // });
    setState(() { isLoading = true; });

    NetworkManager.httpGet(Globals.baseUrl + "services",  context, (r) { // services/configuration
      if (r['state'] == true) {
        setState(() {
          config = r['data'];
          if (widget.data != null) {
            load();
          } else {
            isLoading = false;
          }
        });
      }
    }, cashable: true);

  }

  void load() {
    setState(() {isLoading = true;});
    // NetworkManager.httpGet(Globals.baseUrl + "user/service?id=${widget.id}",  context, (r) {
    //   if (r['state'] == true) {
        setState(() {
          data = widget.data;
          initBodyData();
          isLoading = false;
        });
    //   } else if (r['message'] != null) {
    //     Alert.show(context, Converter.getRealText(r['message']));
    //   }
    // }, cashable: true);
  }



  void initBodyData() {
    print('here_data: $data');
    offers = [];
    selectedFiles = [];

    if(data['service_id'] != null) {
      body["service_id"] = data['service_id'].toString();
      selectedTexts["service_id"] = getNameFromId(config['service'], data['service_id'].toString());
      selectOptions["categories"] = config['service'][getIndexFromId(config['service'],data['service_id'].toString())]['categories'];
      List CCS= (config['service'][getIndexFromId(config['service'],data['service_id'].toString())]['is_country_city_street'] as String).split('-').toList();
      if(CCS[0] == '1') {
        showSelectCountry = true;
        selectedTexts["country_id"] =  getNameFromId(config['countries'], data['country_id'].toString());
        body["country_id"] = data['country_id'].toString();
        selectOptions["cities"] = config['countries'][getIndexFromId(config['countries'],data['country_id'].toString())]['cities'];
      } else {
        (config['countries'] as List<dynamic>).forEach((element) {
          if((element as Map)['id'].toString() == UserManager.currentUser('country_id')) {
            selectOptions["cities"] = element['cities'];
          }
        });
      }
      if(CCS[1] == '1') {
        showSelectCity = true;
        selectedTexts["city_id"] = getNameFromId(selectOptions["cities"], data['city_id'].toString());
        body["city_id"] = data['city_id'].toString();
        selectOptions["street"] = selectOptions["cities"][getIndexFromId(selectOptions["cities"],data['city_id'].toString())]['street'];
      }
      if(CCS[2] == '1') {
        showSelectStreet = true;
        selectedTexts["street_id"] = getNameFromId(selectOptions["street"], data['street_id'].toString());
        body["street_id"] = data['street_id'].toString();
      }

    }

    if(data['service_categories_id'] != null) {
      body["service_categories_id"] = data['service_categories_id'].toString();
      selectedTexts["service_categories_id"] = getNameFromId(selectOptions["categories"], data['service_categories_id'].toString());
      selectSubcategoriesOptions["subcategories"] = selectOptions["categories"][getIndexFromId(selectOptions["categories"],data['service_categories_id'].toString())]['subcategories'];
    }

    if(data['service_subcategories_id'] != null) {
      body["service_subcategories_id"] = data['service_subcategories_id'].toString();
      selectedTexts['service_subcategories_id'] = getNameFromId(selectSubcategoriesOptions["subcategories"], data['service_subcategories_id'].toString());
      selectSub2Options["service_sub_2"] = selectSubcategoriesOptions["subcategories"][getIndexFromId(selectSubcategoriesOptions["subcategories"],data['service_subcategories_id'].toString())]['service_sub_2'];
    }

    if(data['sub2_id'] != null) {
      body["sub2_id"] = data['sub2_id'].toString();
      selectedTexts['sub2_id'] = getNameFromId(selectSub2Options["service_sub_2"], data['sub2_id'].toString());
      selectSub3Options["service_sub_3"] = selectSub2Options["service_sub_2"][getIndexFromId(selectSub2Options["service_sub_2"],data['sub2_id'].toString())]['service_sub_3'];
    }

    if(data['sub3_id'] != null) {
      body["sub3_id"] = data['sub3_id'].toString();
      selectedTexts['sub3_id'] = getNameFromId(selectSub3Options["service_sub_3"], data['sub3_id'].toString());
      selectSub4Options["service_sub_4"] = selectSub3Options["service_sub_3"][getIndexFromId(selectSub3Options["service_sub_3"],data['sub3_id'].toString())]['service_sub_4'];
    }

    if(data['sub4_id'] != null) {
      body["sub4_id"] = data['sub4_id'].toString();
      selectedTexts['sub4_id'] = getNameFromId(selectSub4Options["service_sub_4"], data['sub4_id'].toString());
    }

    print('here_body: $body');

    body['title'] = data["name"];
    body['description'] = data["about"];
    for (var item in data['offers']) {
      offers.add({"details": item['description'], "price": item['price']});
    }

    for (var item in (data['images'] as String).split('||').toList() ) {
      print('here_item: $item');
      selectedFiles.add({"id": '1', "name": Globals.correctLink(item)});
    }

    controllers['title'] = TextEditingController(text: body['title'] ?? "");
    controllers['description'] = TextEditingController(text: body['description'] ?? "");
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          TitleBar(() {Navigator.pop(context);}, widget.data == null ? 253 : 254),
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
    // items.add(createInput("title", 255, maxInput: 60, maxLines: 2));

    if (widget.data == null || body['service_id'] != null)
      items.add(createSelectInput("service_id", 283, config['service'], onSelected: (v) {
      setState(() {
        selectOptions["categories"] = v['categories'];

        selectedTexts["service_id"] = v['name'];
        body["service_id"] = v['id'].toString();

        selectedTexts['service_categories_id'] = null;
        body["service_categories_id"] = null;

        List CCS= (v['is_country_city_street'] as String).split('-').toList();
        if(CCS[0] == '1') showSelectCountry = true; else {selectedTexts["country_id"] = null; body["country_id"] = null; showSelectCountry = false;}
        if(CCS[1] == '1') showSelectCity    = true; else {selectedTexts["city_id"]    = null; body["city_id"]    = null; showSelectCity    = false;}
        if(CCS[2] == '1') showSelectStreet  = true; else {selectedTexts["street_id"]  = null; body["street_id"]  = null; showSelectStreet  = false;}

        selectedTexts["country_id"] = null;
        body["country_id"]          = null;
        selectedTexts['city_id']    = null;
        body["city_id"]             = null;
        selectedTexts['street_id']  = null;
        body["street_id"]           = null;
        selectOptions["cities"]     = null;
        selectOptions["street"]     = null;

        if(selectSubcategoriesOptions.containsKey('subcategories')) selectSubcategoriesOptions.remove('subcategories');
        if(selectSub2Options.containsKey('service_sub_2')) selectSub2Options.remove('service_sub_2');
        if(selectSub3Options.containsKey('service_sub_3')) selectSub3Options.remove('service_sub_3');
        if(selectSub4Options.containsKey('service_sub_4')) selectSub4Options.remove('service_sub_4');

      });
    }));

    if (widget.data == null || data['service_categories_id'] != null)
    items.add(createSelectInput("service_categories_id", 256, selectOptions["categories"], onEmptyMessage: LanguageManager.getText(257), onSelected: (v) {
      setState(() {
        selectSubcategoriesOptions["subcategories"] = v['subcategories'];

        selectedTexts['service_categories_id'] = v['name'];
        body["service_categories_id"] = v['id'].toString();

        body['title'] = v['name'];

        selectedTexts["service_subcategories_id"] = null;
        body["service_subcategories_id"] = null;
        body["sub2_id"] = null;
        body["sub3_id"] = null;
        body["sub4_id"] = null;

        if(selectSub2Options.containsKey('service_sub_2')) selectSub2Options.remove('service_sub_2');
        if(selectSub3Options.containsKey('service_sub_3')) selectSub3Options.remove('service_sub_3');
        if(selectSub4Options.containsKey('service_sub_4')) selectSub4Options.remove('service_sub_4');
        //
        // items.removeWhere((element) {
        //   return (!(items.indexOf(element) == 0 || items.indexOf(element) == 1)) ? true :  false;
        // });
      });
    }));

   // if (widget.data == null || data['service_subcategories_id'] != null)
    items.add(selectSubcategoriesOptions.containsKey("subcategories") && selectSubcategoriesOptions["subcategories"].length > 0 ?
        createSelectInput("service_subcategories_id", 256, selectSubcategoriesOptions["subcategories"], onEmptyMessage: LanguageManager.getText(257), onSelected: (v) {
            setState(() {
              selectedTexts["service_subcategories_id"] = v['name'];
              body["service_subcategories_id"] = v['id'].toString();

              selectSub2Options["service_sub_2"] = v['service_sub_2'];

              selectedTexts["sub2_id"] = null;
              body["sub2_id"] = null;
              body["sub3_id"] = null;
              body["sub4_id"] = null;


              if(selectSub3Options.containsKey('service_sub_3')) selectSub3Options.remove('service_sub_3');
              if(selectSub4Options.containsKey('service_sub_4')) selectSub4Options.remove('service_sub_4');
            });
          })
        : Container());

    //if (widget.data == null || data['sub2_id'] != null)
      items.add(selectSub2Options.containsKey("service_sub_2") && selectSub2Options["service_sub_2"].length > 0 ?
      createSelectInput("sub2_id", 256, selectSub2Options["service_sub_2"], onEmptyMessage: LanguageManager.getText(257), onSelected: (v) {
        setState(() {
          selectedTexts["sub2_id"] = v['name'];
          body["sub2_id"] = v['id'].toString();

          selectSub3Options["service_sub_3"] = v['service_sub_3'];

          selectedTexts["sub3_id"] = null;
          body["sub3_id"] = null;
          body["sub4_id"] = null;

          if(selectSub4Options.containsKey('service_sub_4')) selectSub4Options.remove('service_sub_4');
        });
      })
          : Container());

    //if (widget.data == null || data['sub3_id'] != null)
      items.add(selectSub3Options.containsKey("service_sub_3") && selectSub3Options["service_sub_3"].length > 0 ?
      createSelectInput("sub3_id", 256, selectSub3Options["service_sub_3"], onEmptyMessage: LanguageManager.getText(257), onSelected: (v) {
        setState(() {
          selectedTexts["sub3_id"] = v['name'];
          body["sub3_id"] = v['id'].toString();

          selectSub4Options["service_sub_4"] = v['service_sub_4'];

          selectedTexts["sub4_id"] = null;
          body["sub4_id"] = null;
        });
      })
          : Container());

    //if (widget.data == null || data['sub4_id'] != null)
      items.add(selectSub4Options.containsKey("service_sub_4") && selectSub4Options["service_sub_4"].length > 0 ?
      createSelectInput("sub4_id", 256, selectSub4Options["service_sub_4"], onEmptyMessage: LanguageManager.getText(257), onSelected: (v) {
        setState(() {
          selectedTexts["sub4_id"] = v['name'];
          body["sub4_id"] = v['id'].toString();
        });
      })
          : Container());

    items.add(createInput("description", 258, maxInput: 500, maxLines: 4));


    items.add(Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Text(
        LanguageManager.getText(259),
        textDirection: LanguageManager.getTextDirection(),
        style: TextStyle(
            color: Converter.hexToColor("#2094CD"),
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
    ));
    items.add(createImagesPicker());

    // items.add(InkWell(
    //   onTap: () {
    //     Alert.show(context, getAddOfferForm(), type: AlertType.WIDGET);
    //   },
    //   child: Row(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     textDirection: LanguageManager.getTextDirection(),
    //     children: [
    //       Container(
    //         margin: EdgeInsets.only(right: 10, left: 10),
    //         width: 20,
    //         height: 20,
    //         decoration: BoxDecoration(
    //             color: Converter.hexToColor("#344F64"),
    //             borderRadius: BorderRadius.circular(10)),
    //         child: Icon(
    //           Icons.add,
    //           color: Colors.white,
    //           size: 20,
    //         ),
    //       ),
    //       Container(
    //         child: Text(
    //           LanguageManager.getText(260),
    //           textDirection: LanguageManager.getTextDirection(),
    //           style: TextStyle(
    //               color: Converter.hexToColor("#2094CD"),
    //               fontSize: 16,
    //               fontWeight: FontWeight.bold),
    //         ),
    //       ),
    //     ],
    //   ),
    // ));
    // items.add(offers.length == 0
    //     ? Container(
    //         margin: EdgeInsets.all(10),
    //         decoration: BoxDecoration(
    //             border: Border.all(color: Colors.grey.withAlpha(50), width: 1),
    //             borderRadius: BorderRadius.circular(15)),
    //         padding: EdgeInsets.all(25),
    //         child: Text(
    //           LanguageManager.getText(263),
    //           textAlign: TextAlign.center,
    //         ),
    //       )
    //     : Container(
    //         child: Column(
    //           textDirection: LanguageManager.getTextDirection(),
    //           mainAxisSize: MainAxisSize.min,
    //           children: offers.map((e) {
    //             return Container(
    //               margin: EdgeInsets.all(5),
    //               padding: EdgeInsets.all(10),
    //               decoration: BoxDecoration(
    //                   color: Colors.white,
    //                   boxShadow: [
    //                     BoxShadow(
    //                         color: Colors.black.withAlpha(15),
    //                         blurRadius: 2,
    //                         spreadRadius: 2)
    //                   ],
    //                   borderRadius: BorderRadius.circular(15)),
    //               child: Column(
    //                 textDirection: LanguageManager.getTextDirection(),
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Row(
    //                     textDirection: LanguageManager.getTextDirection(),
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Text(
    //                         e["price"].toString() + " " + UserManager.currentUser("unit"),
    //                         textDirection: LanguageManager.getTextDirection(),
    //                         style: TextStyle(
    //                             color: Converter.hexToColor("#2094CD"),
    //                             fontSize: 16,
    //                             fontWeight: FontWeight.bold),
    //                       ),
    //                       InkWell(
    //                         onTap: () {
    //                           setState(() {
    //                             offers.remove(e);
    //                           });
    //                         },
    //                         child: Icon(
    //                           Icons.delete,
    //                           color: Colors.red,
    //                           size: 20,
    //                         ),
    //                       )
    //                     ],
    //                   ),
    //                   Text(
    //                     e["details"].toString(),
    //                     textDirection: LanguageManager.getTextDirection(),
    //                     style: TextStyle(
    //                         color: Converter.hexToColor("#727272"),
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.normal),
    //                   ),
    //                 ],
    //               ),
    //             );
    //           }).toList(),
    //         ),
    //       ));

    if (showSelectCountry) {
      items.add(createSelectInput("country_id", 312, config['countries'], onSelected: (v) {
        setState(() {
          selectOptions["cities"] = v['cities'];

          selectedTexts["country_id"] = v['name'];
          body["country_id"] = v['id'].toString();

          selectedTexts['city_id'] = null;
          body["city_id"] = null;
          body["street_id"] = null;
        });
      }));
    } else if(showSelectCity){
      (config['countries'] as List<dynamic>).forEach((element) {
        if((element as Map)['id'].toString() == UserManager.currentUser('country_id')) {
          print('here_element: $element');
          selectOptions["cities"] = element['cities'];
        }
      });

    }

    if ((widget.data == null  || data['city_id'] != null) && showSelectCity)
      items.add(Row(
        textDirection: LanguageManager.getTextDirection(),
        children: [
          Expanded(
            child: createSelectInput("city_id", 107, selectOptions["cities"], onEmptyMessage: LanguageManager.getText(311), onSelected: (v) {
              setState(() {
                selectOptions["street"] = v['street'];

                selectedTexts["city_id"] = v['name'];
                body["city_id"] = v['id'].toString();

                selectedTexts['street_id'] = null;
                body["street_id"] = null;
              });
            }),
          ),
          showSelectStreet?
          Expanded(
            child: createSelectInput("street_id", 108, selectOptions["street"], onEmptyMessage: LanguageManager.getText(113),onSelected: (v) {
              setState(() {
                selectedTexts["street_id"] = v['name'];
                body["street_id"] = v['id'].toString();
              });
            }),
          ):Container()
        ],
      ));

    items.add(Container(height: 10,));
    items.add(InkWell(
      onTap: widget.data == null ? send : update,
      child: Container(
        margin: EdgeInsets.all(10),
        height: 45,
        alignment: Alignment.center,
        child: Text(
          LanguageManager.getText(widget.data == null ? 262 : 254),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
    ));
    return items;
  }

  Widget getAddOfferForm() {
    List<Widget> items = [];
    items.add(Container(
      padding: EdgeInsets.all(10),
      child: Row(
        textDirection: LanguageManager.getTextDirection(),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Text(
            LanguageManager.getText(260),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: () {
              Alert.publicClose();
            },
            child: Container(
              child: Icon(Icons.close),
            ),
          ),
        ],
      ),
    ));
    items.add(createInput("offer_price", 95, textType: TextInputType.number));
    items.add(createInput("offer_details", 261, maxLines: 4, maxInput: 200));
    items.add(InkWell(
      onTap: () {
        if (body['offer_price'] == null ||
            body['offer_details'] == null ||
            body['offer_price'].isEmpty ||
            body['offer_details'].isEmpty) {
          Alert.show(context, LanguageManager.getText(264));
          return;
        }
        setState(() {
          offers.add({
            "price": body["offer_price"],
            "details": body["offer_details"],
          });
        });
        body['offer_price'] = "";
        body['offer_details'] = "";
        controllers["offer_price"].text = "";
        controllers["offer_details"].text = "";
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.all(10),
        height: 45,
        alignment: Alignment.center,
        child: Text(
          LanguageManager.getText(260),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
    ));
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items,
      ),
    );
  }

  Widget createImagesPicker() {
    if (tabControllers["images"] == null ||
        tabControllers["images"].length != selectedFiles.length) {
      tabControllers["images"] =
          TabController(length: selectedFiles.length, vsync: this);
      tabControllers["images"].addListener(() {
        setState(() {});
      });
      if (selectedFiles.length > 0)
        tabControllers["images"].index = selectedFiles.length - 1;
    }
    double size = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: size,
              height: size * 0.5,
              child: TabBarView(
                controller: tabControllers["images"],
                children: selectedFiles.map((e) {
                  if (e["id"] != null) {
                    return CachedNetworkImage(imageUrl: e["name"]);
                  } else
                    return Image.memory(e["data"]);
                }).toList(),
              ),
              decoration: BoxDecoration(
                color: Converter.hexToColor(
                    errors["images"] != null ? "#E9B3B3" : "#F2F2F2"),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: LanguageManager.getTextDirection(),
                children: [
                  Container(
                    width: 50,
                  ),
                  Row(
                    children: selectedFiles.map((e) {
                      bool selected = tabControllers["images"].index ==
                          selectedFiles.indexOf(e);
                      return Container(
                        margin: EdgeInsets.only(left: 2, right: 2),
                        width: selected ? 10 : 7,
                        height: 7,
                        decoration: BoxDecoration(
                            color: selected
                                ? Colors.white
                                : Converter.hexToColor("#344F64"),
                            borderRadius: BorderRadius.circular(20)),
                      );
                    }).toList(),
                  ),
                  Row(
                    textDirection: LanguageManager.getTextDirection(),
                    children: [
                      InkWell(
                        onTap: () async {
                          await pickImage(ImageSource.gallery);
                        },
                        child: Container(
                            width: 24,
                            height: 24,
                            child: Icon(
                              Icons.upload_sharp,
                              size: 24,
                            )),
                      ),
                      Container(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            int index = tabControllers['images'].index;
                            if (selectedFiles.isNotEmpty) {
                              if (selectedFiles[index]['id'] != null)
                                removedImagesUpdate.add(selectedFiles[index]['name']);
                              selectedFiles.removeAt(index);
                            }
                          });
                        },
                        child: Container(
                            width: 24,
                            height: 24,
                            child: Icon(Icons.delete, size: 22)),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
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
                        CachedNetworkImage(imageUrl: e['name']),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                images.remove(e);
                                removedImagesUpdate.add(e["name"]);
                                body["removed_images"] = jsonEncode(removedImagesUpdate);
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

  Widget createSelectInput(key, titel, options, {onEmptyMessage, onSelected}) {
    return GestureDetector(
      onTap: () {
        hideKeyBoard();
        if (options == null) {
          Alert.show(context, onEmptyMessage);
          return;
        }
        Alert.show(context, options, type: AlertType.SELECT, onSelected: onSelected);
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
                  : LanguageManager.getText(titel),
              textDirection: LanguageManager.getTextDirection(),
              style: TextStyle(
                  fontSize: 16,
                  color: selectedTexts[key] != null ? Colors.black : Colors.grey),
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

  Widget createInput(key, titel,
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
            hintText: LanguageManager.getText(titel),
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
            hintTextDirection: LanguageManager.getTextDirection(),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0)),
      ),
    );
  }

  Future<void> pickImage(ImageSource source) async {
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

  void hideKeyBoard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild.unfocus();
    }
  }

  void send() {

    setState(() { errors = {}; });
    print('here_body: selectSubcategoriesOptions: ${selectSubcategoriesOptions.isNotEmpty}, $body');
    List validateKeys = ["service_id","service_categories_id", "description"]; // ,"service"

    if(showSelectCountry == true)
      validateKeys.add('country_id');

    if(showSelectCity == true)
      validateKeys.add('city_id');

    if(showSelectStreet == true)
      validateKeys.add('street_id');

    if(selectSubcategoriesOptions.isNotEmpty && selectSubcategoriesOptions["subcategories"].length > 0)
      validateKeys.add('service_subcategories_id');

    if(selectSub2Options.isNotEmpty && selectSub2Options["service_sub_2"].length > 0)
      validateKeys.add('sub2_id');

    if(selectSub3Options.isNotEmpty && selectSub3Options["service_sub_3"].length > 0)
      validateKeys.add('sub3_id');

    if(selectSub4Options.isNotEmpty && selectSub4Options["service_sub_4"].length > 0)
      validateKeys.add('sub4_id');


    for (var key in validateKeys) {
      if (body[key] == null || body[key].isEmpty)
        setState(() {
          errors[key] = "_";
        });
    }
	
    if (selectedFiles.length == 0 && images.length == 0) {
      errors["images"] = "_";
    }

    print('here_errors: $errors');
    if (errors.keys.length > 0) return;

    var isCountryCityStreet = config['service'][getIndexFromId(config['service'],body['service_id'].toString())]['is_country_city_street'];
    if(isCountryCityStreet.toString().contains('1') && ((body.containsKey('country_id') && body["country_id"] == null) || (!body.containsKey('country_id')))){
      body["country_id"] = UserManager.currentUser('country_id');
    }

    List files = [];

    var i = 0;
    for (var item in selectedFiles) {
      if (item['id'] == null) {
        files.add({
          "name": "image_$i",
          "file": item['data'],
          "type_name": "image",
          "file_type": item['type'],
          "file_name": "${DateTime.now().toString().replaceAll(' ', '_')}.${item['type']}"
        });
        i++;
      }
    }
    body["images_length"] = files.length.toString();

    body['offers'] = jsonEncode(offers);

    // body.containsValue(null);
    body['service_subcategories_id'] == null? body.remove('service_subcategories_id') : null;

    print('here_body: $body');

    body.removeWhere((key, value) {
      return value == null ? true :  false;
    });

    Alert.startLoading(context);
    NetworkManager().fileUpload(Globals.baseUrl + "provider/service/create", files, (p) {},  (r) { // services/add
      Alert.endLoading();
      if (r['state'] == true) {
        Navigator.of(context).pop(true);
      } else if (r["message"] != null) {
        Alert.show(context, Converter.getRealText(r["message"]));
      }
    }, body: body);

  }

  void update() {

    setState(() { errors = {}; });

    List validateKeys = ["service_id","service_categories_id", "description"]; // ,"service"

    if(showSelectCountry == true)
      validateKeys.add('country_id');

    if(showSelectCity == true)
      validateKeys.add('city_id');

    if(showSelectStreet == true)
      validateKeys.add('street_id');

    if(selectSubcategoriesOptions.isNotEmpty && selectSubcategoriesOptions["subcategories"].length > 0)
      validateKeys.add('service_subcategories_id');

    if(selectSub2Options.isNotEmpty && selectSub2Options["service_sub_2"].length > 0)
      validateKeys.add('sub2_id');

    if(selectSub3Options.isNotEmpty && selectSub3Options["service_sub_3"].length > 0)
      validateKeys.add('sub3_id');

    if(selectSub4Options.isNotEmpty && selectSub4Options["service_sub_4"].length > 0)
      validateKeys.add('sub4_id');

    for (var key in validateKeys) {
      if (body[key] == null || body[key].isEmpty)
        setState(() {
          errors[key] = "_";
        });
    }

    if (selectedFiles.length == 0 && images.length == 0) {
      errors["images"] = "_";
    }

    print('here_errors: $errors');
    if (errors.keys.length > 0) return;

    var isCountryCityStreet = config['service'][getIndexFromId(config['service'],body['service_id'].toString())]['is_country_city_street'];
    if(isCountryCityStreet.toString().contains('1') && ((body.containsKey('country_id') && body["country_id"] == null) || (!body.containsKey('country_id')))){
      body["country_id"] = UserManager.currentUser('country_id');
    }

    List files = [];

    var i = 0;
    for (var item in selectedFiles) {
      if (item['id'] == null) {
        files.add({
          "name": "image_$i",
          "file": item['data'],
          "type_name": "image",
          "file_type": item['type'],
          "file_name": "${DateTime.now().toString().replaceAll(' ', '_')}.${item['type']}"
        });
        i++;
      }
    }
    body["images_length"] = files.length.toString();

    body['offers'] = jsonEncode(offers);
    body['removed_images'] = jsonEncode(removedImagesUpdate);

    body.forEach((key, value) {
      if(value == null)
        body[key] = value.toString().toUpperCase();
    });

    // body.removeWhere((key, value) {
    //   return value == null ? true :  false;
    // });

    Alert.startLoading(context);
    NetworkManager().fileUpload(Globals.baseUrl + "provider/service/update/${widget.data['id']}", files, (p) {},   (r) { // services/add
      Alert.endLoading();
      if (r['state'] == true) {
        Navigator.of(context).pop(true);
      } else if (r["message"] != null) {
        Alert.show(context, Converter.getRealText(r["message"]));
      }
    }, body: body);
  }

  getNameFromId(List config, String id) {
    var name = '';
    config.forEach((element) {
      if((element as Map)['id'].toString() == id){
        name =  (element as Map)['name'];
        return name;
      }
    });
    return name;
  }

  getIndexFromId(List config, String id) {
    var index = 0, i = 0;
    config.forEach((element) {
      if((element as Map)['id'].toString() == id){
        index =  i;
        return index;
      }
      i++;
    });
    return index;
  }

}
