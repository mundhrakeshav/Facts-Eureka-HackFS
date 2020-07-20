import 'dart:convert';
import 'package:facts/Screens/FactDrawer.dart';
import 'package:facts/Screens/PostListItem.dart';
import 'package:facts/Screens/ngrok.dart';
import 'package:facts/Widgets/AppbarMain.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Fact> facts = [];
  bool _isLoading = true;
  getAllPosts() async {
    http.Response response = await http.get(ngrokAddress + "/getallposts");
    var data = jsonDecode(response.body);
    print(data.runtimeType);
    setState(() {
      _isLoading = false;
    });
    for (var fact in data) {
      // Fact(
      //   body: fact["content"],
      // );
    }
  }

  @override
  void initState() {
    getAllPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarMain,
      drawer: FactDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return PostListItem(
                    index: index,
                  );
                },
                itemCount: 50,
                separatorBuilder: (context, index) => Divider(
                  thickness: 2,
                ),
              ),
              padding: EdgeInsets.all(10),
            ),
    );
  }
}

class Fact {
  String publisher;
  String title;
  Image image;
  String body;
  int upvotes;
  int threads;

  Fact({
    @required this.publisher,
    @required this.title,
    @required this.body,
    @required this.image,
    @required this.threads,
    @required this.upvotes,
  });
}
