import 'dart:convert';
import 'dart:ffi';

import 'package:facts/Screens/ngrok.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreenProvider extends ChangeNotifier {
  List<Fact> facts = [];
  bool isLoading = true;
  getAllPosts() async {
    http.Response response = await http.get(ngrokAddress + "/getallposts");
    var data = jsonDecode(response.body);
    print(data);
    isLoading = false;
    notifyListeners();
  }
}

class Fact {
  String publisher;
  String title;
  Image image;
  String body;
  int upvotes;
  int threads;
}
