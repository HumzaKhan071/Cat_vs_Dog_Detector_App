import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    bool _loading = true;
    File _image;
    List _output;
    final picker = ImagePicker();

    detectImage(File image) async {
      var output = await Tflite.runModelOnImage(
          path: image.path,
          numResults: 2,
          threshold: 0.6,
          imageMean: 127.5,
          imageStd: 127.5);

      setState(() {
        _output = output;
        _loading = false;
      });
    }

    loadModel() async {
      await Tflite.loadModel(
          model: "CatVSDogDetectorApp-master/assets/model_unquant.tflite",
          labels: "CatVSDogDetectorApp-master/assets/labels.txt");
    }

    @override
    void initState() {
      super.initState();
      loadModel().then((value) {
        setState(() {});
      });
    }

    @override
    void dispose() {
      super.dispose();
    }

    pickImage() async {
      var image = await picker.getImage(source: ImageSource.camera);
      if (image == null) return;
      setState(() {
        _image = File(image.path);
      });
      detectImage(_image);
    }

    pickGallery() async {
      var image = await picker.getImage(source: ImageSource.gallery);
      if (image == null) return;
      setState(() {
        _image = File(image.path);
      });
      detectImage(_image);
    }

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Coding Cafe",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Cats and Dogs Detector",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 30),
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: _loading
                  ? Container(
                      width: 350,
                      child: Column(children: [
                        Image.asset(
                            "assets/2.1 cat_dog_icon.png"),
                        SizedBox(
                          height: 50,
                        )
                      ]),
                    )
                  : Container(
                      child: Column(
                        children: [
                          Container(
                            height: 250,
                            child: Image.file(_image),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _output != null
                              ? Text(
                                  "${_output[0]["label"]}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                )
                              : Container(),
                          SizedBox(height: 10)
                        ],
                      ),
                    ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        pickImage();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 250,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Capture a Photo",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        pickGallery();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 250,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Select a Photo",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
