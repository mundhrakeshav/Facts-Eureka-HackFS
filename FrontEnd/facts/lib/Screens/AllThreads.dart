import 'dart:convert';
import 'dart:typed_data';
import 'package:facts/Providers/homeScreenProvider.dart';
import 'package:facts/Screens/ThreadItem.dart';
import 'package:facts/Screens/ngrok.dart';
import 'package:facts/Widgets/AppbarMain.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AllThreads extends StatefulWidget {
  final int postId;
  AllThreads({@required this.postId});

  @override
  _AllThreadsState createState() => _AllThreadsState();
}

class _AllThreadsState extends State<AllThreads> {
  List<Thread> threads = [];
  bool _isLoading = true;
  getAllThreads() async {
    threads.clear();
    http.Response response = await http.get(
      ngrokAddress + "/getallthreads/" + widget.postId.toString(),
    );

    var data = json.decode(response.body);

    for (var thread in data) {
      print(thread["donations"]);
      List<int> image = [];
      List tempImage = jsonDecode(thread["image"]);

      for (var item in tempImage) {
        image.add(item);
      }

      Thread _thread = Thread(
        upvotes: thread["upvotes"],
        body: thread["content"],
        threadID: thread["threadId"],
        publisher: thread["user"],
        threads: thread["threads"],
        title: thread["title"],
        donations: thread["donations"],
        postID: thread["postId"],
        image: Uint8List.fromList(image),
      );
      threads.add(_thread);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getAllThreads();
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
          : Container(
              child: threads.length == 0
                  ? Center(
                      child: Text("NO THREADS AVAILABLE ON THIS POST"),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await getAllThreads();
                      },
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return ThreadItem(
                            postID: widget.postId,
                            thread: threads[index],
                          );
                        },
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: threads.length,
                      ),
                    ),
            ),
    );
  }
}
