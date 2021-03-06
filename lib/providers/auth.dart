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
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token = "";
  String _refreshToken = "";
  DateTime _expiryDate = DateTime.now();

  //String? userName;

  // String _userId = "";
  var storage = new FlutterSecureStorage();

  Map<String, dynamic> userData = {};

  Auth() {
    storage.read(key: 'token').then((value) {
      if (value != null) {
        _token = value.toString();
        storage.read(key: "refreshToken").then((valueR) {
          _refreshToken = valueR.toString();
          _expiryDate = JwtDecoder.getExpirationDate(_token);
          loadUser();
          notifyListeners();
        });
      }
    });
  }

  Future<Map<String, dynamic>> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      final extractedUserData =
          json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
      userData = {
        "email": extractedUserData["email"].toString(),
        "emailConfirmed": extractedUserData["email"].toString(),
        "id": extractedUserData["email"].toString(),
        "name": extractedUserData["email"].toString(),
        "picture": extractedUserData["email"].toString(),
      };
      userData = extractedUserData;
    } else {
      logout();
    }
    return userData;
  }

  void logout() async {
    _token = "";
    _refreshToken = "";
    userData = {};
    storage.delete(key: 'token');
    storage.delete(key: 'refreshToken');
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userData");
    notifyListeners();
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      var jsonBody =
          jsonEncode({'name': name, 'email': email, 'password': password});
      final response = await http.post(Uri.parse('${config.API_LINK}/register'),
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
        await storage.write(key: 'refreshToken', value: _refreshToken);
        final prefs = await SharedPreferences.getInstance();
        userData = responseBody['userData'] as Map<String, dynamic>;
        prefs.setString('userData', json.encode(userData));
        notifyListeners();
      } else {
        throw new ApiException(
            responseBody['message'].toString(), response.statusCode);
      }
    } on SocketException {
      throw new ApiException("Server Error", 500);
    } on TimeoutException {
      throw new ApiException("Server not responding", 500);
    }
  }

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
        await storage.write(key: 'refreshToken', value: _refreshToken);
        final prefs = await SharedPreferences.getInstance();
        userData = responseBody['userData'] as Map<String, dynamic>;
        prefs.setString('userData', json.encode(userData));
        notifyListeners();
      } else {
        throw new ApiException(
            responseBody['message'].toString(), response.statusCode);
      }
    } on SocketException {
      throw new ApiException("Server Error", 500);
    } on TimeoutException {
      throw new ApiException("Server not responding", 500);
    }
  }

  // this should be used to get token when you want to use it it API request
  Future<String> get token async {
    if (_token != "") {
      if (JwtDecoder.isExpired(_token)) {
        await refreshToken();
      }
      return _token;
    } else {
      return "";
    }
  }

  // use this just to see if user is logged in or not
  bool get userLoggedIn {
    return _token != "";
  }

  Future<void> refreshToken() async {
    // TODO
    // send request to api to refresh the token
    return;
  }
}
