import 'package:auto_size_text/auto_size_text.dart';
import 'package:facts/Providers/homeScreenProvider.dart';
import 'package:facts/Screens/DetailedPost.dart';
import 'package:facts/Screens/DonateBottomSheets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostListItem extends StatelessWidget {
  final int index;

  PostListItem({
    @required this.index,
  });

  @override
  Widget build(BuildContext context) {
    HomeScreenProvider _factProvider = Provider.of<HomeScreenProvider>(context);

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DetailedPost(fact: _factProvider.facts[index]),
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
                        _factProvider.facts[index].title.toUpperCase(),
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
                        _factProvider.facts[index].image,
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
                        "Total Donations: " +
                            _factProvider.facts[index].donations.toString(),
                        style: TextStyle(
                          fontFamily: "Abel",
                        ),
                      ),
                      Text(
                        "Total Threads: " +
                            _factProvider.facts[index].threads.length
                                .toString(),
                        style: TextStyle(fontFamily: "Abel"),
                      ),
                      Text(
                        "Total Upvotes: " +
                            _factProvider.facts[index].upvotes.toString(),
                        style: TextStyle(fontFamily: "Abel"),
                      ),
                    ],
                  ),
                  FlatButton.icon(
                    onPressed: () {
                      Scaffold.of(context)
                          .showBottomSheet((context) => BottomSheet(
                                enableDrag: true,
                                builder: (context) => DonateToPostBottomSheet(
                                  postID: _factProvider.facts[index].postID,
                                ),
                                onClosing: () => {Navigator.pop(context)},
                              ));
                    },
                    icon: (Icon(Icons.payment)),
                    label: Text("Donate to this post"),
                  )
                ],
              )
            ],
          )),
    );
  }
}
