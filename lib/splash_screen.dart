import 'package:cot_vs_dog_detector_app/home.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplash extends StatefulWidget {
  const MySplash({Key key}) : super(key: key);

  @override
  State<MySplash> createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: Home(),
      title: Text(
        "Cat and Dog Classifier",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.yellowAccent),
      ),
      image: Image.asset('assets/2.1 cat_dog_icon.png'),
      backgroundColor: Colors.blueAccent,
      photoSize: 60,
      loaderColor: Colors.redAccent,
    );
  }
}
