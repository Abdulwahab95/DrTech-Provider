import 'dart:async';
import 'dart:convert';

import 'package:dr_tech/Config/Globals.dart';
import 'package:dr_tech/Models/DatabaseManager.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart' as http_parser;

class NetworkManager {
  static Map<String, int> asyncValidator = {};
  String call(String url, Function callback, {var body, onError, cachable}) {
    String storageKey = url;
    int validatorKey = DateTime.now().microsecondsSinceEpoch;
    asyncValidator[url] = validatorKey;

    if (body != null) {
      for (var key in body.keys) {
        storageKey += key + body[key].toString();
      }
    }

    // callback function builder
    Function callbackBody = (responseBody, payloadStorageKey) {
      if (responseBody == null) return;

      try {
        var jsonData = json.decode(responseBody);
        try {
          return callback(jsonData, payloadStorageKey);
        } catch (e) {
          return callback(jsonData);
        }
      } catch (e) {
        DatabaseManager.unset(storageKey);
        if (onError != null)
          onError('Error trying parsing server responce . ');
        else
          log(e);
      }
    };

    Future serverCall(payloadInfo) async {
      var header = Globals.header();
      var response;

      if (body != null)
        response = await http.post(Uri.parse(url), headers: header, body: body);
      else
        response = await http.get(Uri.parse(url), headers: header);

      if (response == null) {
        if (onError != null) onError("Null Responce");
      }
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) {
        if (onError != null) onError("Error while fetching data");
        throw new Exception("Error while fetching data");
      }

      if (asyncValidator[payloadInfo['url']] != payloadInfo['validatorKey']) {
        return null;
      }

      try {
        // log
        log("----------START---------");
        log('url: $url');
        log('form-data: $body');
        log('header: $header');
        log('response.body: ${response.body}');
        log("-----------END--------");

        if (cachable == true) {
          DatabaseManager.save(payloadInfo['localStorageKey'], response.body);
        }
        return {
          "data": response.body,
          "storageKey": payloadInfo['localStorageKey']
        };
      } catch (e) {
        if (onError != null) onError("Error in the server responce format");
        throw Exception("Error in the server responce format");
      }
    }

    serverCall({
      "validatorKey": validatorKey,
      "localStorageKey": storageKey,
      "url": url
    }).then((payload) {
      if (payload == null) return;
      callbackBody(payload['data'], payload['storageKey']);
    });

    // send The cached Version of the paylaod responce
    // throw the function in thread tp delay , so the cashKey can be returnd before the callback

    if (cachable == true) {
      var cachedData = DatabaseManager.load(storageKey);
      if (cachedData != null && cachedData != "" && cachedData != "null") {
        callbackBody(cachedData, storageKey);
      }
    }

    // callback idenity
    return storageKey;
  }

  void fileUpload(url, List filesData, onProgress, callback, {body}) async {
    final request = MultipartRequest(
      'POST',
      Uri.parse(url),
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print(progress);
        onProgress(progress);
      },
    );
    var header = Globals.header();
    for (var key in header.keys) {
      request.headers[key] = header[key];
    }
    if (body != null)
      for (var key in body.keys) {
        request.fields[key] = body[key];
      }

    for (var fileData in filesData) {
      request.files.add(http.MultipartFile.fromBytes(
          fileData['name'], fileData['file'],
          contentType: http_parser.MediaType(
              fileData["type_name"], fileData["file_type"]),
          filename: fileData['file_name']));
    }

    StreamedResponse streamedResponse = await request.send();
    final responceBody = await streamedResponse.stream.bytesToString();
    try {
      var jsonResponce = json.decode(responceBody);

      log("----------START---------");
      log('url: $url');
      log('form-data: $body');
      log('header: $header');
      log('response.body: $jsonResponce');
      log("-----------END--------");

      callback(jsonResponce);
    } catch (e) {
      print(responceBody);
    }
  }

  static void httpGet(String url, Function callback,
      {cashable = false, onError, Map<String, String> body}) {
    if (body != null) {
      List<String> getData = [];
      for (var key in body.keys) {
        getData.add(key + "=" + Uri.decodeComponent(body[key]));
      }
      url = url + (url.contains("?") ? "&" : "?") + getData.join("&");
    }
    NetworkManager().call(url, callback, onError: onError, cachable: cashable);
  }

  /// Return Cash Key
  static String httpPost(String url, Function callback,
      {var body, onError, cachable}) {
    return NetworkManager()
        .call(url, callback, body: body, onError: onError, cachable: cachable);
  }

  static log(e) {
    print(e);
  }
}

class MultipartRequest extends http.MultipartRequest {
  /// Creates a new [MultipartRequest].
  MultipartRequest(
    String method,
    Uri url, {
    this.onProgress,
  }) : super(method, url);

  final void Function(int bytes, int totalBytes) onProgress;

  /// Freezes all mutable fields and returns a single-subscription [ByteStream]
  /// that will emit the request body.
  http.ByteStream finalize() {
    final byteStream = super.finalize();
    if (onProgress == null) return byteStream;

    final total = this.contentLength;
    int bytes = 0;

    final t = StreamTransformer.fromHandlers(
      handleData: (List<int> data, EventSink<List<int>> sink) {
        bytes += data.length;
        onProgress(bytes, total);
        sink.add(data);
      },
    );
    final stream = byteStream.transform(t);
    return http.ByteStream(stream);
  }
}
