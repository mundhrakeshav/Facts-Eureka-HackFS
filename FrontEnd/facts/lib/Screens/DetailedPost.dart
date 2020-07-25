import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:facts/Providers/homeScreenProvider.dart';
import 'package:facts/Services/CurrentUser.dart';
import 'package:facts/Widgets/AppbarMain.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ngrok.dart';

class DetailedPost extends StatefulWidget {
  final Fact fact;

  DetailedPost({@required this.fact});

  @override
  _DetailedPostState createState() => _DetailedPostState();
}

class _DetailedPostState extends State<DetailedPost> {
  bool hasUserPurchased;
  bool _isLoading = true;

  getHasUserPurchased() async {
    print(widget.fact.postID);
    // print(CurrentUser.user.uid);
    http.Response response = await http.get(ngrokAddress +
        "/haspurchased/" +
        widget.fact.postID.toString() +
        "/" +
        CurrentUser.user.uid);
    var data = jsonDecode(response.body);

    setState(() {
      hasUserPurchased = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getHasUserPurchased();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarMain,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : hasUserPurchased ? postPurchasedWidget() : purchasePostWidget(),
    );
  }

  Widget postPurchasedWidget() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Center(
            child: Column(
          children: [
            AutoSizeText(
              widget.fact.title,
              style: TextStyle(fontSize: 30),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 40),
              child: Image.memory(widget.fact.image),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 40),
              child: AutoSizeText(
                widget.fact.body,
                minFontSize: 20,
              ),
            ),
            ButtonBar(
              children: [
                FlatButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.details),
                  label: Text("View Full Thread"),
                ),
                FlatButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.edit),
                  label: Text("Add new Post"),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }

  purchasePost() async {
    http.Response response = await http
        .post(ngrokAddress + "/purchasePost/" + CurrentUser.user.uid, body: {
      "postId": widget.fact.postID.toString(),
      "publisherAddress": widget.fact.publisher.toString()
    });

    print(response.body);
  }

  Widget purchasePostWidget() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              "You can't view the complete post.Please pay to check complete article."),
          SizedBox(
            height: 20,
          ),
          RaisedButton.icon(
              color: Colors.grey,
              onPressed: purchasePost,
              icon: Icon(Icons.account_balance_wallet),
              label: Text("Pay for Post"))
        ],
      )),
    );
  }
}
