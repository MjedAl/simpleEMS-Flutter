import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Event with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final String image;
  final String timeTemp;
  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.timeTemp,
  });
}
