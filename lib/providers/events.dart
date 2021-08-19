import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import '../config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './event.dart';
import './auth.dart';
import '../models/api_exception.dart';
import 'package:intl/intl.dart';

class Events with ChangeNotifier {
  Auth? _auth;
  Events(this._auth, this._items);

  List<Event> _items = [];
  List<Event> get items {
    return [..._items];
  }

  Event findById(String id) {
    return _items.firstWhere((event) => event.id == id);
  }

  void update() {
    // just tell them to update
    notifyListeners();
  }

  Future<List<Event>> getEvents() async {
    try {
      var response;

      var token = "";
      // if there is a valid auth object, means user is logged in
      // get the latest token, refresh if it was expired
      if (_auth != null) {
        await _auth!.token.then((value) => token = value);
      }
      if (token != "") {
        response =
            await http.get(Uri.parse('${config.API_LINK}/events'), headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }).timeout(const Duration(seconds: 10));
      } else {
        response = await http
            .get(Uri.parse('${config.API_LINK}/events'))
            .timeout(const Duration(seconds: 10));
      }

      final events = json.decode(response.body) as Map<String, dynamic>;

      final List<Event> loadedEvents = [];
      events['events'].forEach((data) {
        // TODO convert time to local
        DateTime timeNow = DateTime.parse(data['time-full']).toLocal();

        loadedEvents.add(Event(
            id: data['id'],
            name: data['name'],
            description: data['description'],
            image: data['image'] == null ? "null" : data['image'],
            monthD: DateFormat.MMMM().format(timeNow) +
                ', ' +
                timeNow.day.toString(),
            hourM: timeNow.hour.toString() + ":" + timeNow.minute.toString(),
            currentRegistered: data['currentRegistered']));
      });
      _items = loadedEvents;
      // Not needed?
      //notifyListeners();
      return _items;
    } on SocketException {
      throw new ApiException("Server Error", 500);
    } on TimeoutException {
      throw new ApiException("Server not responding", 500);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  //
  Future<bool> addEvent(String title, String description, String location,
      String date, String image) async {
    // Check for the token

    try {
      var response;
      var token = "";
      if (_auth != null) {
        await _auth!.token.then((value) => token = value);
      }
      if (token != "") {
        var jsonBody = jsonEncode({
          'name': title,
          'description': description,
          'location': location,
          'date': date,
          'image': image
        });

        response = await http.post(Uri.parse('${config.API_LINK}/events'),
            body: jsonBody,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            }).timeout(const Duration(seconds: 25));
        final responseBody = json.decode(response.body) as Map<String, dynamic>;
        print(responseBody["success"]);
        if (response.statusCode == 200) {
          return true;
        } else {
          throw new ApiException(
              responseBody['message'].toString(), response.statusCode);
        }
      } else {
        // this might happen when user was logged in but token expired
        // and refreshing the token failed
        throw new ApiException("Please log in and try again :(", 401);
      }
    } on SocketException {
      throw new ApiException("Server Error", 500);
    } on TimeoutException {
      throw new ApiException("Server not responding", 500);
    } catch (error) {
      throw error;
    }
  }
}
