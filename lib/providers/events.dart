import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'dart:convert';
import 'package:http/http.dart' as http;
import './event.dart';
import './auth.dart';

class Events with ChangeNotifier {
  //final String _authToken;
  Auth _auth;

  Events(this._auth, this._items);

  void addEvent() {}
  List<Event> _items = [];
  List<Event> get items {
    return [..._items];
  }

  Event findById(String id) {
    return _items.firstWhere((event) => event.id == id);
  }

  Future<void> getEvents() async {
    //print('ll');

    try {
      //print('ii');

      final response = await http
          .get(Uri.parse('http://192.168.1.102:5000/api/v1/events'))
          .timeout(const Duration(seconds: 20));
      //print('ll');
      // if (_auth.token != "") {}
      // catch
      // TODO check for response code and validate
      final events = json.decode(response.body) as Map<String, dynamic>;

      final List<Event> loadedEvents = [];
      events['events'].forEach((data) {
        //print(data);
        loadedEvents.add(Event(
          id: data['id'],
          name: data['name'],
          description: data['description'],
          image: data['image'] == null ? "null" : data['image'],
          timeTemp: data['time-time'],
        ));
      });
      _items = loadedEvents;
      notifyListeners(); // notify all of new version
      return;
    } catch (error) {
      print("ERROR:" + error.toString());
      throw error;
    }
  }
}
