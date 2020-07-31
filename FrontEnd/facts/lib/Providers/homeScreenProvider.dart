import 'dart:convert';
import 'dart:typed_data';
import 'package:facts/Screens/ngrok.dart';
import 'package:facts/Services/CurrentUser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreenProvider extends ChangeNotifier {
  List<Fact> facts = [];

  String userEthereumAddress;

  int balance;

  bool isLoading = true;

  HomeScreenProvider() {
    getAllPosts();
    getUserDetails();
  }

  getAllPosts() async {
    facts.clear();

    http.Response response = await http.get(ngrokAddress + "/getallposts");
    var data = jsonDecode(response.body);

    for (var fact in data) {
      List<int> image = [];
      List tempImage = jsonDecode(fact["image"]);

      for (var item in tempImage) {
        image.add(item);
      }

      Fact _fact = Fact(
        upvotes: fact["upvotes"],
        body: fact["content"],
        publisher: fact["user"],
        threads: fact["threads"],
        title: fact["title"],
        donations: fact["donations"],
        postID: fact["postId"],
        image: Uint8List.fromList(image),
      );
      facts.add(_fact);
    }
    isLoading = false;
    facts = facts.reversed.toList();
    print(facts.length);
    notifyListeners();
  }

  getUserDetails() async {
    http.Response response = await http
        .get(ngrokAddress + "/getaccountdetails/" + CurrentUser.user.uid);
    var data = jsonDecode(response.body);

    CurrentUser.balance = data["balance"];
    CurrentUser.userAddress = data["userAddress"];
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
  int donations;
  List<dynamic> threads;

  Fact({
    @required this.publisher,
    @required this.title,
    @required this.body,
    this.image,
    @required this.upvotes,
    @required this.threads,
    @required this.donations,
    @required this.postID,
  });
}

class Thread {
  int postID;
  int threadID;
  String publisher;
  String title;
  Uint8List image;
  String body;
  int donations;
  int upvotes;
  List<dynamic> threads;

  Thread({
    @required this.publisher,
    @required this.title,
    @required this.body,
    this.image,
    @required this.upvotes,
    @required this.threadID,
    @required this.threads,
    @required this.donations,
    @required this.postID,
  });
}
