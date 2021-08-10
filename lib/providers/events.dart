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
    try {
      var response;
      _auth.token.then((token) async {
        if (token != "") {
          response =
              await http.get(Uri.parse('${config.API_LINK}/events'), headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }).timeout(const Duration(seconds: 20));
        } else {
          response = await http
              .get(Uri.parse('${config.API_LINK}/events'))
              .timeout(const Duration(seconds: 20));
        }

        final events = json.decode(response.body) as Map<String, dynamic>;

        final List<Event> loadedEvents = [];
        events['events'].forEach((data) {
          print(data);
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
        notifyListeners();
        return items;
      });
    } catch (error) {
      print("ERROR:" + error.toString());
      throw error;
    }
  }
}
