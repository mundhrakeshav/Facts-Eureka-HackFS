import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class PostListItem extends StatelessWidget {
  final int index;

  PostListItem({@required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      splashColor: Colors.black54,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                      flex: 2,
                      child: AutoSizeText(
                        "Dolores laudantium fugiat voluptates fugiat esse dolor ea distinctio nam. Sed consequatur dolores dignissimos.",
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
                      child: Image.network(
                        "https://file.mockplus.com/image/2018/11/9314c44f-c653-40a6-8ea5-7e1c903feecf.png",
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
                        "Total Upvotes: 1000",
                        style: TextStyle(
                          fontFamily: "Abel",
                        ),
                      ),
                      Text(
                        "Total Threads: 10",
                        style: TextStyle(fontFamily: "Abel"),
                      ),
                    ],
                  ),
                  FlatButton.icon(
                    onPressed: () {},
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
