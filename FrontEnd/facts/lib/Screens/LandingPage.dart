import 'package:facts/Screens/HomePage.dart';
import 'package:facts/Screens/LoginPage.dart';
import 'package:facts/Services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return LoginScreen.create(context);
          } else {
            return HomePage();
          }
        } else {
          return SafeArea(
            child: Center(
              child: LoadingBumpingLine.circle(
                size: 100,
                backgroundColor: Colors.white,
              ),
            ),
          );
        }
      },
    );
  }
}
