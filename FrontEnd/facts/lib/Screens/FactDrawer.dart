import 'package:auto_size_text/auto_size_text.dart';
import 'package:facts/Screens/AddPost.dart';
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
              accountName: Padding(
                padding: EdgeInsets.all(3.0),
                child: AutoSizeText(
                  CurrentUser.userAddress,
                  maxFontSize: 18,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w300,
                  ),
                ),
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
            Container(
              padding: EdgeInsets.fromLTRB(10, 20, 20, 5),
              color: Colors.black54,
              child: Row(
                children: [
                  Text(
                    "Balance:" + CurrentUser.balance.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.height * .09,
              margin: EdgeInsets.symmetric(horizontal: 20),
            ),
            ListTile(
              title: Text(
                "Add New Post",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddPost(),
                ))
              },
              trailing: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
            Spacer(),
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
