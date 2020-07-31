import 'package:auto_size_text/auto_size_text.dart';
import 'package:facts/Screens/DetailedThread.dart';
import 'package:facts/Screens/DonateBottomSheets.dart';
import 'package:flutter/material.dart';
import 'package:facts/Providers/homeScreenProvider.dart';

class ThreadItem extends StatelessWidget {
  final Thread thread;
  final int postID;
  ThreadItem({
    @required this.thread,
    @required this.postID,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailedThread(
                postID: postID,
                thread: thread,
              ),
            ));
      },
      splashColor: Colors.black54,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      flex: 2,
                      child: AutoSizeText(
                        thread.title.toUpperCase(),
                        maxLines: 4,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w500,
                        ),
                        minFontSize: 13,
                      )),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.memory(
                        thread.image,
                        width: MediaQuery.of(context).size.width * .3,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "Total Donations: " + thread.donations.toString(),
                        style: TextStyle(
                          fontFamily: "Abel",
                        ),
                      ),
                      Text(
                        "Total Upvotes: " + thread.upvotes.toString(),
                        style: TextStyle(
                          fontFamily: "Abel",
                        ),
                      ),
                    ],
                  ),
                  FlatButton.icon(
                    onPressed: () {
                      Scaffold.of(context)
                          .showBottomSheet((context) => BottomSheet(
                                enableDrag: true,
                                builder: (context) => DonateToThreadBottomSheet(
                                  postID: postID,
                                  threadID: thread.threadID,
                                ),
                                onClosing: () => {Navigator.pop(context)},
                              ));
                    },
                    icon: (Icon(Icons.payment)),
                    label: Text("Donate to this thread"),
                  )
                ],
              )
            ],
          )),
    );
  }
}
