import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wifilink/responsiveui/sizeconfig.dart';
import 'package:wifilink/screens/homepage.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
     Timer(
      Duration(milliseconds: 1500),
      () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (ctx) => MyHomePage()),
            (route) => false);
      },
    );
    return Scaffold(
      body: new Container(
        width: SizeConfig.screenWidth,
        color: Color(0xff31363a),
        child: new Column(
          children: [
            Expanded(
              child: Center(
                child: TyperAnimatedTextKit(
                  text: ["Linky-Fi"],
                  isRepeatingAnimation: false,
                  textStyle: GoogleFonts.josefinSans(
                      fontSize: 6.12*SizeConfig.textMultiplier,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent),
                  speed: new Duration(milliseconds: 100),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/WifiPlansLandscapeGIF_IrelandAndUK_WithoutText.gif",
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
