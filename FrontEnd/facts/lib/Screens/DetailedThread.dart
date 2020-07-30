import 'package:auto_size_text/auto_size_text.dart';
import 'package:facts/Providers/homeScreenProvider.dart';
import 'package:facts/Screens/DonateBottomSheets.dart';
import 'package:flutter/material.dart';

class DetailedThread extends StatelessWidget {
  final Thread thread;
  final int postID;
  DetailedThread({
    @required this.postID,
    @required this.thread,
  });

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
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Center(
                child: Column(
              children: [
                AutoSizeText(
                  thread.title,
                  style: TextStyle(fontSize: 30),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 40),
                  child: Image.memory(thread.image),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 40),
                  child: AutoSizeText(
                    thread.body,
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
                                    threadID: thread.threadID,
                                    postID: postID,
                                  ),
                                  onClosing: () => {Navigator.pop(context)},
                                ));
                      },
                      icon: Icon(Icons.payment),
                      label: Text("Donate to Thread"),
                    ),
                  ],
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
