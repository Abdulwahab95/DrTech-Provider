import 'package:dr_tech/Config/Globals.dart';
import 'package:dr_tech/Models/DatabaseManager.dart';
import 'package:dr_tech/Network/NetworkManager.dart';

class UserManager {
  static bool checkLogin() {
    return DatabaseManager.load(Globals.authoKey).isNotEmpty;
  }

  static void proccess(dynamic data) {
    DatabaseManager.save("user_keys", data.keys.toList());
    for (var key in data.keys) {
      DatabaseManager.save(key, data[key]);
    }
  }

  static String currentUser(key) {
    if (!UserManager.checkLogin()) return "";
    var v = DatabaseManager.load(key).toString();
    return v ?? "";
  }

  static String nameUser(key) {
    var v = DatabaseManager.load(key).toString();
    print('nameUser: key: $key, value: $v');
    return v ?? "";
  }

  static void logout() {
    DatabaseManager.unset("current_panel");
    DatabaseManager.unset(Globals.authoKey);
    var dbData = DatabaseManager.load('user_keys');
    List userKeys = dbData != "" ? dbData : [];
    for (var key in userKeys) {
      DatabaseManager.unset(key);
    }
  }

  static void refrashUserInfo({callBack}) {
    if (!UserManager.checkLogin()) return;
    NetworkManager.httpGet(Globals.baseUrl + "user/info", (userInfo) {
      try {
        if (userInfo['status'] == true) {
          UserManager.proccess(userInfo['user']);
          if (callBack != null) callBack();
        } else
          UserManager.logout();
      } catch (e) {
        // error loading info log the user out ..
      }
    });
  }

  static void update(key, value, callback) {
    Map<String, String> body = {"key": key, key: value};

    NetworkManager.httpPost(Globals.baseUrl + "user/update", (r) {
      callback(r['status']);
      if (r['status'] == true) {
        UserManager.proccess(r['user']);
      }
    }, body: body);
  }
}
