import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  var station = TextEditingController();
  var camera = TextEditingController();

  File imageFile;
  Future<String> future;

   @override
  void dispose() {
    station.dispose();
    camera.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    Future<String> _upload(File image, String station,String camera ) async {
      String url = "http://192.168.43.59:8080/passenger/upload/$station/$camera";
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(
        await http.MultipartFile.fromPath('image', image.path,
            filename: basename(image.path)),
      );
      var response = await request.send();
      String responseBody = await response.stream.bytesToString();
      print(responseBody);
      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          child: new AlertDialog(
            title: Text("Number of Persons"),
            content: Text(responseBody),
          ),
        );
      });
      return responseBody;
    }

    Future getImage(ImageSource source) async {
      final pickedFile = await ImagePicker()
          .getImage(source: source, maxHeight: 300, maxWidth: 300);
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
          future = _upload(imageFile, station.text.trim(), camera.text.trim());
        });
      }
    }

    void initialize(){
      imageFile = null; 
      future = null;
    }

    // ignore: missing_return
    Future _imageChoiceDialog() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("From where do you want to take the photo?"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      InkWell(
                        child: Text("Gallery"),
                        onTap: () {
                          initialize();
                          getImage(ImageSource.gallery);
                          Navigator.pop(context);
                        },
                      ),
                      Padding(padding: EdgeInsets.all(12.0)),
                      InkWell(
                        child: Text("Camera"),
                        onTap: () {
                          initialize();
                          getImage(ImageSource.camera);
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ));
          });
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _imageChoiceDialog,
        child: Icon(Icons.add_a_photo),
      ),
      body: Center(
          child: Padding(
            padding: EdgeInsets.only(
              top: 30,
        ),
        child: Column(
          children: <Widget>[
            _field("station id", station),
            SizedBox(
              height: 10,
            ),
            _field("camera id", camera),
            SizedBox(
              height: 10,
            ),
            imageFile == null ? Text('Choose Image') : Image.file(imageFile),
            if (imageFile == null || future == null)
              Text('')
            else
              FutureBuilder(
                  future: future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.none) {
                      return Text("");
                    } else if (snapshot.hasError) {
                      return Text("Try Again!");
                    } else if (snapshot.hasData) {
                      return Text("Uploaded Success...!");
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
          ],
        ),
      )),
    );
  }
  Widget _field(String hint, TextEditingController myController) {
    return TextField(
      expands: false,
      controller: myController,
      cursorColor: Colors.blue,
      style: TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black),
      ),
    );
  }
}