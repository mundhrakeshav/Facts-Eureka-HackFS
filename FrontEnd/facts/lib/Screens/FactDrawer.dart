import 'package:auto_size_text/auto_size_text.dart';
import 'package:facts/Screens/AddPost.dart';
import 'package:facts/Screens/ngrok.dart';
import 'package:facts/Services/Auth.dart';
import 'package:facts/Services/CurrentUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

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
    TextEditingController t1 = TextEditingController();

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
            ListTile(
              title: Text(
                "Get More Tokens",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              onTap: () => {
                Navigator.pop(context),
                Scaffold.of(context).showBottomSheet((context) => BottomSheet(
                      enableDrag: true,
                      builder: (context) => Container(
                        height: MediaQuery.of(context).size.height * .6,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black54,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("How many tokens you wanna purchase?"),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width * .3),
                                child: TextFormField(
                                  controller: t1,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  RaisedButton(
                                    color: Colors.white,
                                    child: Text(
                                      "PURCHASE",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () {
                                      http.post(
                                        ngrokAddress +
                                            "/buytokens/" +
                                            CurrentUser.user.uid,
                                        body: {"amount": t1.text},
                                      );
                                    },
                                  ),
                                  RaisedButton(
                                    color: Colors.red,
                                    child: Text("CANCEL"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                  "*this is just a mockup actual payment APIs haven't been integrated"),
                            ],
                          ),
                        ),
                      ),
                      onClosing: () => {Navigator.pop(context)},
                    )),
              },
              trailing: Icon(
                Icons.add,
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
