import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import '../config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './event.dart';
import './auth.dart';

class Events with ChangeNotifier {
  Auth? _auth;
  Events(this._auth, this._items);

  void addEvent() {}
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
    //print('getE');
    try {
      var response;

      var token = "";
      if (_auth != null) {
        await _auth!.token.then((value) => token = value);
      }
      //print('kpok');
      //print("tt>" + token);
      if (token != "") {
        response =
            await http.get(Uri.parse('${config.API_LINK}/events'), headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }).timeout(const Duration(seconds: 10));
      } else {
        // print('here');
        response = await http
            .get(Uri.parse('${config.API_LINK}/events'))
            .timeout(const Duration(seconds: 10));
        // print('k');
      }
      //  print('done');

      final events = json.decode(response.body) as Map<String, dynamic>;
      // print('l');
      final List<Event> loadedEvents = [];
      events['events'].forEach((data) {
        loadedEvents.add(Event(
          id: data['id'],
          name: data['name'],
          description: data['description'],
          image: data['image'] == null ? "null" : data['image'],
          //timeTemp: data['time-time'] == null ? "temp" : data['time-time'],
          timeTemp: "temp",
        ));
      });
      _items = loadedEvents;
      //notifyListeners();
      return _items;
    } on SocketException {
      //print('jiojioj');
      throw new Exception("Server Error");
    } on TimeoutException {
      // print('beoijoij');
      throw new Exception("Server not responding");
    } catch (error) {
      //  print('00000');
      //  print("ERROR:" + error.toString());
      throw error;
    }
  }
}
