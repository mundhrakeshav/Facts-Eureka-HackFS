import 'package:facts/Screens/ngrok.dart';
import 'package:facts/Services/CurrentUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

String baseUrl = "http://77956cf06bd8.ngrok.io";

class User {
  final String uid;
  final String email;
  final String displayName;
  User({@required this.uid, @required this.email, this.displayName});
}

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;
  Future<User> currentUser();
  Future<User> signInWithEmailPassword({String email, String password});
  Future<User> createUserWithEmailPassword({String email, String password});
  Future<bool> resetPassword(String _email);
  Future<void> signOut();
  Future<User> signInWithGoogle();
}

class Auth implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(
        uid: user.uid, email: user.email, displayName: user.displayName);
  }

  @override
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map((firebaseUser) {
      CurrentUser.user = firebaseUser;
      return _userFromFirebase(firebaseUser);
    });
  }

  @override
  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();

    return _userFromFirebase(user);
  }

  @override
  Future<User> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.getCredential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken));
        CurrentUser.user = authResult.user;

        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_ID_TOKEN_MISSING',
          message: 'error token missing',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_SIGNIN_ABORTED',
        message: 'error signingIn',
      );
    }
  }

  @override
  Future<User> signInWithEmailPassword({String email, String password}) async {
    final AuthResult authResult = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    CurrentUser.user = authResult.user;
    print(CurrentUser.user.uid);
// https://beta-api.ethvigil.com/v0.1/contract/0xad62722dba0857a2637bffaaade855773ded78f9',
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> createUserWithEmailPassword(
      {String email, String password}) async {
    final AuthResult authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    CurrentUser.user = authResult.user;
    print(CurrentUser.user.uid);
    http.Response response = await http.get(
      ngrokAddress +
          "/generatekeys/${CurrentUser.user.uid}", //TODO change NGROK URL
    );

    print(response.body);
    return _userFromFirebase(authResult.user);
  }

  Future<bool> resetPassword(String _email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: _email);
    return true;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();

    CurrentUser.user = null;

    final googleSignin = GoogleSignIn();
    googleSignin.signOut();
  }
}
