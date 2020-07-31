import 'package:facts/Services/Auth.dart';
import 'package:facts/Widgets/AppbarMain.dart';
import 'package:facts/Widgets/SetDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

enum FormType { login, register }

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool obscureText = false;
  FormType _formType = FormType.login;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  TextFormField _emailTextField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Colors.white, style: BorderStyle.solid)),
        hintText: 'abc@example.com',
        labelText: 'EMail',
        labelStyle: TextStyle(color: Colors.white54),
      ),
    );
  }

  TextFormField _passwordtextField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !obscureText,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Colors.white, style: BorderStyle.solid)),
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.white54),
        suffixIcon: IconButton(
          icon: obscureText
              ? Icon(
                  Icons.visibility,
                  color: Colors.white,
                )
              : Icon(
                  Icons.visibility_off,
                  color: Colors.white,
                ),
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
        ),
        focusColor: Colors.white,
      ),
    );
  }

  FlatButton flatButton({@required Function onPressed, @required String text}) {
    return FlatButton(
      onPressed: onPressed,
      splashColor: Colors.black38,
      focusColor: Colors.black54,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Abel',
          fontSize: 18,
        ),
      ),
    );
  }

  void _toggleFormType() {
    if (_formType == FormType.login) {
      _formType = FormType.register;
    } else
      _formType = FormType.login;

    _emailController.clear();
    _passwordController.clear();
  }

  void submit() async {
    if (_email == '' || _password == '') {
      showDialog(
        context: context,
        builder: (context) {
          return SetDialogBox(
            textHeading: 'Please fill in complete details.',
            textContent: 'Either Password or Email Field is empty.',
          );
        },
      );
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        final auth = Provider.of<AuthBase>(context, listen: false);
        if (_formType == FormType.login) {
          await auth.signInWithEmailPassword(
              email: _email, password: _password);
        } else {
          await auth.createUserWithEmailPassword(
              email: _email, password: _password);
        }
      } on PlatformException catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return SetDialogBox(
              textHeading: e.code,
              textContent: e.message,
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarMain,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          color: Colors.black45,
          image: DecorationImage(
              image: ExactAssetImage("assets/Images/NewsBackground.webp"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black54.withOpacity(.85), BlendMode.darken)),
        ),
        child: Center(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _emailTextField(),
                _passwordtextField(),
                SizedBox(
                  height: 30,
                ),
                _isLoading
                    ? LoadingBumpingLine.circle(
                        size: 30,
                        backgroundColor: Colors.white,
                      )
                    : RaisedButton(
                        color: Colors.white60,
                        child: Text(
                          _formType == FormType.login ? 'Login' : 'SignUp',
                          style: TextStyle(
                            fontFamily: 'Abel',
                            fontSize: 20,
                          ),
                        ),
                        focusColor: Colors.black54,
                        onPressed: submit,
                        splashColor: Colors.black38,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    flatButton(
                        onPressed: () => {
                              setState(() {
                                _toggleFormType();
                              })
                            },
                        text: _formType == FormType.login ? 'SignUp' : 'Login'),
                    flatButton(
                      onPressed: () => {},
                      text: 'ForgotPassword',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
