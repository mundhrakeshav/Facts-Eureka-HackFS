import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:facts/Screens/ngrok.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreenProvider extends ChangeNotifier {
  List<Fact> facts = [];
  bool isLoading = true;

  HomeScreenProvider() {
    getAllPosts();
  }

  getAllPosts() async {
    http.Response response = await http.get(ngrokAddress + "/getallposts");
    var data = jsonDecode(response.body);

    for (var fact in data) {
      List<int> image = [];

      List tempImage = jsonDecode(fact["image"]);

      for (var item in tempImage) {
        image.add(item);
      }

      Fact _fact = Fact(
        body: fact["content"],
        publisher: fact["user"],
        threads: fact["threads"],
        title: fact["title"],
        upvotes: fact["upvotes"],
        postID: fact["postId"],
        image: Uint8List.fromList(image),
      );
      print(_fact.postID);
      facts.add(_fact);
    }
    isLoading = false;
    facts = facts.reversed.toList();

    notifyListeners();
  }
}

class Fact {
  int postID;
  String publisher;
  String title;
  Uint8List image;
  String body;
  int upvotes;
  List<dynamic> threads;

  Fact({
    @required this.publisher,
    @required this.title,
    @required this.body,
    this.image,
    @required this.threads,
    @required this.upvotes,
    @required this.postID,
  });
}
