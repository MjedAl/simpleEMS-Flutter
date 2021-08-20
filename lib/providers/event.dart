import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Event with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final String image;
  final String monthD;
  final String hourM;
  final int currentRegistered;
  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.monthD,
    required this.hourM,
    required this.currentRegistered,
  });
}
