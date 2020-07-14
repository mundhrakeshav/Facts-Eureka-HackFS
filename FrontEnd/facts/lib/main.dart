import 'package:facts/Screens/LandingPage.dart';
import 'package:facts/Screens/LoginPage.dart';
import 'package:facts/Services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthBase>(create: (context) => Auth()),
      ],
      child: MaterialApp(
        title: 'Facts',
        theme: ThemeData.dark().copyWith(),
        home: SafeArea(child: LandingPage()),
      ),
    );
  }
}
