import 'dart:convert';
import 'dart:io';
import 'package:facts/Screens/ngrok.dart';
import 'package:facts/Services/CurrentUser.dart';
import 'package:facts/Widgets/AppbarMain.dart';
import 'package:facts/Widgets/SetDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  List<String> tags = [];

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _bodyController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String get _title => _titleController.text;

  String get _body => _bodyController.text;

  bool _isLoading = false;

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
      key: _scaffoldKey,
      appBar: appbarMain,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Builder(
              builder: (context) => SingleChildScrollView(
                child: Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * .1),
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
                        _image != null
                            ? Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.image,
                                      size: 20,
                                    ),
                                    Text("   Image Attached"),
                                  ],
                                ),
                              )
                            : Container(),
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
                                setState(() {
                                  _isLoading = true;
                                });

                                http.Response resp = await http.post(
                                  ngrokAddress +
                                      "/addpost/${CurrentUser.user.uid}",
                                  body: {
                                    "title": _title,
                                    "content": _body,
                                    "image":
                                        _image.readAsBytesSync().toString(),
                                  },
                                );
                                var data = jsonDecode(resp.body);
                                _titleController.clear();
                                _bodyController.clear();
                                setState(() {
                                  _image = null;
                                });

                                // print(resp.body);
                                setState(() {
                                  _isLoading = false;
                                });
                                _scaffoldKey.currentState
                                    .showBottomSheet((context) => BottomSheet(
                                          onClosing: () {},
                                          builder: (context) => Container(
                                            color: Colors.black54,
                                            padding: EdgeInsets.all(30),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .6,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                    "The Transaction has been made. Your post will be added in a while."),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    RaisedButton(
                                                      color: Colors.white,
                                                      child: Text(
                                                        "OK",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    RaisedButton(
                                                      color: Colors.white,
                                                      child: Text(
                                                        "Check your transaction",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      onPressed: () {
                                                        launch(
                                                            "https://goerli.etherscan.io/tx/${data["txnId"]}",
                                                            enableJavaScript:
                                                                true,
                                                            forceWebView: true);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ));
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
