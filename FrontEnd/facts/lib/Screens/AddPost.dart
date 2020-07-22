import 'dart:io';
import 'dart:typed_data';

import 'package:facts/Screens/ngrok.dart';
import 'package:facts/Services/CurrentUser.dart';
import 'package:facts/Widgets/AppbarMain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
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

  File _image;

  final picker = ImagePicker();

  void _chooseViaGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
    });

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.ratio5x3
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    print("object");
    print(await croppedFile.length());
    var result = await FlutterImageCompress.compressAndGetFile(
      croppedFile.path,
      _image.path,
      quality: 10,
      rotate: 0,
    );
    setState(() {
      _image = result;
    });
    print(await _image.length());

    // String imageBytesList = _image.readAsStringSync();
    // print(imageBytesList);
  }

  void _chooseViaCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile.path);
    });

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.ratio5x3
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    print("object");
    print(await croppedFile.length());
    var result = await FlutterImageCompress.compressAndGetFile(
      croppedFile.path,
      _image.path,
      quality: 10,
      rotate: 0,
    );
    setState(() {
      _image = result;
    });
    print(await _image.length());
    // String imageBytesList = _image.readAsStringSync();
    // print(imageBytesList);
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
                      onPressed: () async {
                        http.Response resp = await http.post(
                          ngrokAddress + "/addpost/${CurrentUser.user.uid}",
                          //TODO change NGROK URL
                          body: {
                            "title": _title,
                            "content": _body,
                            "image": _image.readAsBytesSync().toString(),
                          },
                        );
                        _titleController.clear();
                        _bodyController.clear();
                        print(_title);
                        print(_body);
                        print(resp.body);
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
