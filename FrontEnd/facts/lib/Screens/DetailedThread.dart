import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:facts/Providers/homeScreenProvider.dart';
import 'package:facts/Screens/DonateBottomSheets.dart';
import 'package:facts/Screens/ngrok.dart';
import 'package:facts/Services/CurrentUser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailedThread extends StatefulWidget {
  final Thread thread;
  final int postID;
  DetailedThread({
    @required this.postID,
    @required this.thread,
  });

  @override
  _DetailedThreadState createState() => _DetailedThreadState();
}

class _DetailedThreadState extends State<DetailedThread> {
  bool _isLoading = false;
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
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Builder(
              builder: (context) => SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                      child: Column(
                    children: [
                      AutoSizeText(
                        widget.thread.title,
                        style: TextStyle(fontSize: 30),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 40),
                        child: Image.memory(widget.thread.image),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 40),
                        child: AutoSizeText(
                          widget.thread.body,
                          minFontSize: 20,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.thumb_up),
                            label: Text("Upvote"),
                          ),
                          FlatButton.icon(
                            onPressed: () {
                              Scaffold.of(context)
                                  .showBottomSheet((context) => BottomSheet(
                                        enableDrag: true,
                                        builder: (context) =>
                                            DonateToThreadBottomSheet(
                                          threadID: widget.thread.threadID,
                                          postID: widget.postID,
                                        ),
                                        onClosing: () =>
                                            {Navigator.pop(context)},
                                      ));
                            },
                            icon: Icon(Icons.payment),
                            label: Text("Donate to Thread"),
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
                              "$ngrokAddress/upvotethread/${widget.postID}/${widget.thread.threadID}/${CurrentUser.user.uid}",
                            );

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
            ),
    );
  }
}
