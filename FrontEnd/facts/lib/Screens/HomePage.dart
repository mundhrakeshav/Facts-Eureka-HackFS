import 'package:facts/Providers/homeScreenProvider.dart';
import 'package:facts/Screens/FactDrawer.dart';
import 'package:facts/Screens/PostListItem.dart';
import 'package:facts/Widgets/AppbarMain.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HomeScreenProvider _factProvider = Provider.of<HomeScreenProvider>(context);
    return Scaffold(
      appBar: appbarMain,
      drawer: FactDrawer(),
      body: _factProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: RefreshIndicator(
                onRefresh: () async {
                  await _factProvider.getAllPosts();
                  await _factProvider.getUserDetails();
                },
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return PostListItem(
                      index: index,
                    );
                  },
                  itemCount: _factProvider.facts.length,
                  separatorBuilder: (context, index) => Divider(
                    thickness: 2,
                  ),
                ),
              ),
              padding: EdgeInsets.all(10),
            ),
    );
  }
}
