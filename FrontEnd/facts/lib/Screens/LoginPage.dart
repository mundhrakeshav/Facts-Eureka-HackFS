import 'package:facts/Services/Auth.dart';
import 'package:facts/Widgets/AppbarMain.dart';
import 'package:facts/Widgets/SetDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static Widget create(BuildContext context) {
    return Provider<LoginScreen>(
      create: (context) => LoginScreen(),
      child: LoginScreen(),
    );
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  Future<void> _signWithGoogle(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);

      await auth.signInWithGoogle();
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) {
          return SetDialogBox(
            textHeading: 'Sign In Failed',
            textContent: e.message.toString(),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarMain,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black45,
          image: DecorationImage(
              image: ExactAssetImage("assets/Images/NewsBackground.webp"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black54.withOpacity(.7), BlendMode.darken)),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _isLoading
                  ? LoadingBumpingLine.circle(
                      size: 100,
                      backgroundColor: Colors.white,
                    )
                  : GoogleSignInButton(
                      borderRadius: 20,
                      onPressed: () => _signWithGoogle(context),
                      splashColor: Colors.black54,
                      text: "Sign In With Google    ",
                      textStyle: TextStyle(color: Colors.black87),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
