import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreenProvider extends ChangeNotifier {
  List<Fact> facts = [];
}

class Fact {
  String publisher;
  String title;
  Image image;
  String body;
  int upvotes;
  int threads;
}
