import 'package:facts/Screens/FactDrawer.dart';
import 'package:facts/Services/Auth.dart';
import 'package:facts/Widgets/AppbarMain.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      body: Container(),
    );
  }
}
