import 'dart:io';
import 'dart:typed_data';

import 'package:facts/Widgets/AppbarMain.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _bodyController = TextEditingController();

  String get _title => _titleController.text;

  String get _body => _bodyController.text;

  File file;

  final picker = ImagePicker();

  void _chooseViaGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      file = File(pickedFile.path);
    });
    Uint8List imageBytesList = file.readAsBytesSync();
    print(imageBytesList);
  }

  void _chooseViaCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      file = File(pickedFile.path);
    });
    Uint8List imageBytesList = file.readAsBytesSync();
    print(imageBytesList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarMain,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * .1),
          child: Form(
            child: Column(
              children: [
                Container(
                  child: Text(
                    "Add a new Post",
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w700),
                  ),
                  margin: EdgeInsets.all(20),
                ),
                titleInput(),
                bodyInput(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        FloatingActionButton.extended(
                          heroTag: "uploadImage",
                          backgroundColor: Colors.white.withOpacity(.9),
                          onPressed: _chooseViaGallery,
                          label: Text("Upload Image"),
                          icon: Icon(Icons.image),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FloatingActionButton.extended(
                          heroTag: "ClickImage",
                          backgroundColor: Colors.white.withOpacity(.9),
                          onPressed: _chooseViaCamera,
                          label: Text("Click Image"),
                          icon: Icon(Icons.camera),
                        )
                      ],
                    ),
                    FloatingActionButton(
                      heroTag: "Send",
                      backgroundColor: Colors.white.withOpacity(.9),
                      onPressed: () {
                        print(_title);
                        print(_body);
                      },
                      child: Icon(Icons.send),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextField bodyInput() {
    return TextField(
      controller: _bodyController,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          labelText: "Body",
          labelStyle: TextStyle(color: Colors.white70)),
      maxLength: 1500,
      minLines: 3,
      maxLines: 40,
      style: TextStyle(fontSize: 25),
    );
  }

  TextField titleInput() {
    return TextField(
      controller: _titleController,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          labelText: "Title",
          labelStyle: TextStyle(color: Colors.white70)),
      maxLength: 180,
      maxLines: 5,
      minLines: 1,
      style: TextStyle(fontSize: 25),
    );
  }
}
