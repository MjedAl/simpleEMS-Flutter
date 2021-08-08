import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:simpleems/models/api_exception.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class Auth with ChangeNotifier {
  // String _token;
  // String _refreshToken;

  // DateTime _expiryDate;

  // bool _freshLogin;
  // String _userId;
  final storage = new FlutterSecureStorage();
  // String value = await storage.read(key: key);

  Future<void> signup() async {}
  Future<void> login(String username, String password) async {
    // try {
    final response = await http.post('${config.API_LINK}/login' as Uri, body: {
      'username': username,
      'password': password,
    });
    print(response);

    // switch (response.statusCode) {
    //   case 200:
    //     // Ok login and do and notify blah blah...
    //     break;
    //   case 401:
    //     throw new ApiException("Server Error", 500);
    //   default:
    //     throw new ApiException("Server Error", 500);
    //     _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
    //     break;
    // }
    // } on SocketException {
    //   throw new ApiException("Server Error", 500);
    // }
    return;
  }

  String get token {
    // TODO check for all
    // If expired refresh
    // If errored throw that error
    return "";
  }

  Future<void> refreshToken() async {}
}
