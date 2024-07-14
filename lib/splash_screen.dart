import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cataract_detector1/Home/Home.dart';
// import 'package:cataract_detector1/landing_page.dart';
import 'package:cataract_detector1/media_query.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var auth = FirebaseAuth.instance;
  var isLogin = false;
  var isPageLoaded = false;
  checkIfLogin() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Delay navigation to ensure page content is loaded
    Timer(Duration(seconds: 3), () {
      setState(() {
        isPageLoaded = true;
      });
      // Navigate only if login state is determined and page is fully loaded
      if (isPageLoaded && isLogin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    });
    // Check login status
    checkIfLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF63BCFF),
              Color(0xFF97D1FD),
              Color(0xFFFFFFFF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Container(
            width: getScaledWidth(double.infinity, context),
            height: getScaledHeight(double.infinity, context),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF63BCFF),
                  Color(0xFF97D1FD),
                  Color(0xFFFFFFFF),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/drishti_logo.png',
                    fit: BoxFit.cover,
                    // width: getScaledWidth(200.0, context),
                    // height: getScaledHeight(150.0, context),
                  ),
                  Spacer(),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'CataractDetect',
                        textStyle: TextStyle(
                          fontSize: getScaledWidth(34, context),
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                    pause: Duration(seconds: 3),
                    repeatForever: true,
                  ),
                  Spacer(),
                  Image.asset(
                    'images/charak.png',
                    width: getScaledWidth(200.0, context),
                    height: getScaledHeight(150.0, context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}