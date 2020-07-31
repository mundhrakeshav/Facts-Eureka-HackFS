import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:facts/Providers/homeScreenProvider.dart';
import 'package:facts/Screens/AddThread.dart';
import 'package:facts/Screens/AllThreads.dart';
import 'package:facts/Screens/DonateBottomSheets.dart';
import 'package:facts/Services/CurrentUser.dart';
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
      appBar: AppBar(
        title: Text(
          "TheFacts",
          style: TextStyle(
            fontFamily: "Playfair Display",
            fontSize: 30,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_comment),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddThread(
                    postID: widget.fact.postID,
                  ),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : hasUserPurchased
              ? postPurchasedWidget()
              : purchasePostWidget(context),
    );
  }

  Widget postPurchasedWidget() {
    return Builder(
      builder: (context) => SingleChildScrollView(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllThreads(
                            postId: widget.fact.postID,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.details),
                    label: Text("View Full Thread"),
                  ),
                  FlatButton.icon(
                    onPressed: () {
                      Scaffold.of(context)
                          .showBottomSheet((context) => BottomSheet(
                                enableDrag: true,
                                builder: (context) => DonateToPostBottomSheet(
                                  postID: widget.fact.postID,
                                ),
                                onClosing: () => {Navigator.pop(context)},
                              ));
                    },
                    icon: Icon(Icons.payment),
                    label: Text("Donate to Post"),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                width: double.infinity,
                child: RaisedButton.icon(
                  color: Colors.blueGrey,
                  splashColor: Colors.black87,
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    http.Response response = await http.post(
                        "$ngrokAddress/upvotefact/${widget.fact.postID}/${CurrentUser.user.uid}");

                    var data = jsonDecode(response.body);

                    print(data);
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  icon: Icon(Icons.thumb_up),
                  label: Text("UpVote"),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  Future<void> purchasePost() async {
    http.Response response = await http
        .post(ngrokAddress + "/purchasePost/" + CurrentUser.user.uid, body: {
      "postId": widget.fact.postID.toString(),
      "publisherAddress": widget.fact.publisher.toString()
    });

    print(response.body);
  }

  Widget purchasePostWidget(BuildContext context) {
    return Builder(
      builder: (context) => Container(
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
                onPressed: () {
                  purchasePost();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                      " Your request to purchase post has been made you'll be able to view it in a few seconds.",
                      style: TextStyle(color: Colors.white),
                    ),
                    duration: Duration(seconds: 3),
                    backgroundColor: Colors.black,
                  ));
                },
                icon: Icon(Icons.account_balance_wallet),
                label: Text("Pay for Post"))
          ],
        )),
      ),
    );
  }
}
