import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:facts/Providers/homeScreenProvider.dart';
import 'package:facts/Screens/AddThread.dart';
import 'package:facts/Screens/AllThreads.dart';
import 'package:facts/Services/CurrentUser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ngrok.dart';

class DetailedThread extends StatelessWidget {
  final Thread thread;

  DetailedThread({this.thread});

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
      body: SingleChildScrollView(
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
            ],
          )),
        ),
      ),
    );
  }
}
