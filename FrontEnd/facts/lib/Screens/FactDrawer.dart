import 'package:facts/Services/Auth.dart';
import 'package:facts/Services/CurrentUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:provider/provider.dart';

class FactDrawer extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    String rawSvg = Jdenticon.toSvg(CurrentUser.user.email);
    return Theme(
      data: ThemeData(canvasColor: Colors.grey[900]),
      child: Drawer(
        elevation: 10,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.black45,
                child: SvgPicture.string(
                  rawSvg,
                  fit: BoxFit.contain,
                  height: 64,
                  width: 64,
                ),
              ),
              decoration: BoxDecoration(color: Colors.black54),
              margin: EdgeInsets.all(10),
              accountName: Text(
                "@" + CurrentUser.user.email.split("@")[0],
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w300,
                    fontSize: 18),
              ),
              accountEmail: Text(
                CurrentUser.user.email != null ? CurrentUser.user.email : "",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w100,
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(child: Container()),
            ListTile(
              title: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              onTap: () => _signOut(context),
              trailing: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}