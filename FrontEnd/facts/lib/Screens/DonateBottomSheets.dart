import 'dart:convert';

import 'package:facts/Screens/ngrok.dart';
import 'package:facts/Services/CurrentUser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class DonateToPostBottomSheet extends StatefulWidget {
  final int postID;

  DonateToPostBottomSheet({@required this.postID});

  @override
  _DonateToPostBottomSheetState createState() =>
      _DonateToPostBottomSheetState();
}

class _DonateToPostBottomSheetState extends State<DonateToPostBottomSheet> {
  bool _isLoading = false;

  final TextEditingController t1 = TextEditingController();

  Future<String> donate() async {
    http.Response response = await http.post(
        "$ngrokAddress/donatetofact/${widget.postID}/${CurrentUser.user.uid}",
        body: {
          "amount": t1.text,
        });

    var data = jsonDecode(response.body);
    return data["txHash"];
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("How many tokens you wanna donate?"),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .3),
                  child: TextFormField(
                    controller: t1,
                    keyboardType: TextInputType.number,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      color: Colors.white,
                      child: Text(
                        "PAY",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        String txHash = await donate();
                        Navigator.pop(context);
                        setState(() {
                          _isLoading = false;
                        });

                        Scaffold.of(context).showBottomSheet(
                          (context) => BottomSheet(
                            onClosing: () {},
                            builder: (context) => Container(
                              color: Colors.black54,
                              padding: EdgeInsets.all(30),
                              height: MediaQuery.of(context).size.height * .6,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                      "The Transaction has been made. Balance transfer will reflect after the tx has been confirmed."),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      RaisedButton(
                                        color: Colors.white,
                                        child: Text(
                                          "OK",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      RaisedButton(
                                        color: Colors.white,
                                        child: Text(
                                          "Check your transaction",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: () {
                                          launch(
                                              "https://goerli.etherscan.io/tx/$txHash",
                                              enableJavaScript: true,
                                              forceWebView: true);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );

                        t1.clear();
                      },
                    ),
                    RaisedButton(
                      color: Colors.red,
                      child: Text("CANCEL"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
            color: Colors.black54,
            height: MediaQuery.of(context).size.height * .6,
          );
  }
}

class DonateToThreadBottomSheet extends StatefulWidget {
  final int postID, threadID;

  DonateToThreadBottomSheet({@required this.postID, @required this.threadID});
  @override
  _DonateToThreadBottomSheetState createState() =>
      _DonateToThreadBottomSheetState();
}

class _DonateToThreadBottomSheetState extends State<DonateToThreadBottomSheet> {
  bool _isLoading = false;

  final TextEditingController t1 = TextEditingController();

  Future<String> donate() async {
    http.Response response = await http.post(
        "$ngrokAddress/donatetothread/${widget.postID}/${widget.threadID}/${CurrentUser.user.uid}",
        body: {
          "amount": t1.text,
        });
    print(response.body);
    var data = jsonDecode(response.body);

    return data["txHash"];
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("How many tokens you wanna donate?"),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .3),
                  child: TextFormField(
                    controller: t1,
                    keyboardType: TextInputType.number,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      color: Colors.white,
                      child: Text(
                        "PAY",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        String hash = await donate();
                        Navigator.pop(context);
                        t1.clear();

                        setState(() {
                          _isLoading = false;
                        });

                        Scaffold.of(context).showBottomSheet(
                          (context) => BottomSheet(
                            onClosing: () {},
                            builder: (context) => Container(
                              color: Colors.black54,
                              padding: EdgeInsets.all(30),
                              height: MediaQuery.of(context).size.height * .6,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                      "The Transaction has been made. Balance transfer will reflect after the tx has been confirmed."),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      RaisedButton(
                                        color: Colors.white,
                                        child: Text(
                                          "OK",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      RaisedButton(
                                        color: Colors.white,
                                        child: Text(
                                          "Check your transaction",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: () {
                                          launch(
                                              "https://goerli.etherscan.io/tx/$hash",
                                              enableJavaScript: true,
                                              forceWebView: true);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    RaisedButton(
                      color: Colors.red,
                      child: Text("CANCEL"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
            color: Colors.black54,
            height: MediaQuery.of(context).size.height * .6,
          );
  }
}
