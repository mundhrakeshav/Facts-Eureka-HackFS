import 'package:facts/Screens/FactDrawer.dart';
import 'package:facts/Screens/PostListItem.dart';
import 'package:facts/Widgets/AppbarMain.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarMain,
      drawer: FactDrawer(),
      body: Container(
        child: ListView.separated(
          itemBuilder: (context, index) {
            return PostListItem();
          },
          itemCount: 50,
          separatorBuilder: (context, index) => Divider(
            thickness: 2,
          ),
        ),
        padding: EdgeInsets.all(10),
      ),
    );
  }
}
