import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:simpleems/models/api_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../config.dart';
import 'dart:io';
import 'package:jwt_decoder/jwt_decoder.dart';

class Auth with ChangeNotifier {
  String _token = "";
  String _refreshToken = "";
  DateTime _expiryDate = DateTime.now();
  // String _userId = "";
  var storage = new FlutterSecureStorage();

  Auth() {
    print('New auth');
    // construct the object, retreive token from storage,
    // set refresh token and expiry time
    //storage =

    storage.read(key: 'token').then((value) {
      //print(value);
      if (value != null) {
        _token = value.toString();
        storage.read(key: "refreshToken").then((valueR) {
          _refreshToken = valueR.toString();
          _expiryDate = JwtDecoder.getExpirationDate(_token);
          notifyListeners();
        });
      }
    });
  }

  Future<void> signup() async {}
  Future<void> login(String email, String password) async {
    try {
      var jsonBody = jsonEncode({'email': email, 'password': password});
      final response = await http.post(Uri.parse('${config.API_LINK}/login'),
          body: jsonBody,
          headers: {
            "Content-Type": "application/json"
          }).timeout(const Duration(seconds: 30));

      final responseBody = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        _token = responseBody['token'].toString();
        _refreshToken = responseBody['refresh_token'].toString();
        _expiryDate = JwtDecoder.getExpirationDate(_token);
        await storage.write(key: 'token', value: _token);

        print('Stored it ?');
        String tokenS = '';
        await storage
            .read(key: 'token')
            .then((value) => tokenS = value.toString());
        print(tokenS);

        await storage.write(key: 'refreshToken', value: _refreshToken);
        notifyListeners();
        return Future.value();
      } else {
        throw new ApiException(
            responseBody['message'].toString(), response.statusCode);
      }
    } on SocketException {
      throw new ApiException("Server Error", 500);
    } on TimeoutException {
      throw new ApiException("Server not responding", 500);
    }
    return;
  }

  Future<String> get token async {
    // print('g token');
    if (_token != "") {
      if (JwtDecoder.isExpired(_token)) {
        await refreshToken();
      }
      return _token;
    } else {
      //  print('empt');
      return "";
    }
  }

  Future<void> refreshToken() async {
    // send request to api to refresh the token
    return;
  }
}
