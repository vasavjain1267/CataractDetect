// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cataract_detector1/LoginPage/login.dart';
import 'package:cataract_detector1/media_query.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: 
        Container(
          width: getScaledWidth(double.infinity,context),
          height: getScaledHeight(double.infinity,context),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF63BCFF), Color(0xFF97D1FD), Color(0xFFFFFFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer(),
              Image.asset(
                'images/doctor3bg.png',
                 height: getScaledHeight(400.0,context),
                 width: getScaledWidth(300.0,context),
                // fit: BoxFit.cover,
              ),
              // SizedBox(height: 100),
              Text(
                'See if Cataracts Clouds Your Vision',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: getScaledHeight(30, context),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: getScaledHeight(20.0, context)),
              Text(
                'See Clearly, Live Brightly\n Check for Cataracts Today',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: getScaledHeight(20, context),
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: getScaledHeight(10.0, context)),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     ElevatedButton(
              //         onPressed: () {
              //           // Add your login as doctor action here
              //         },
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: Color(0xFF273671),
              //           padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(10),
              //           ),
              //         ),
              //         child: Text(
              //           'LOGIN AS DOCTOR',
              //           style: TextStyle( color: Colors.white),
              //         ),
              //       ),
                  SizedBox(height: getScaledHeight(20.0, context)),
                   ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => LogIn()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF273671),
                        padding: EdgeInsets.symmetric(horizontal: getScaledHeight(100, context), vertical: getScaledWidth(20, context)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(getScaledWidth(40, context)),
                        ),
                      ),
                      child: Text(
                      // SizedBox: double.infinity,
                        'GET STARTED',
                        style: TextStyle(fontSize: getScaledWidth(20, context), color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  
              //   ],
              // ),
              SizedBox(height: getScaledHeight(90.0, context)),
              // Container(
              //   padding: EdgeInsets.all(20),
              //   decoration: BoxDecoration(
              //     color: Color(0xFF63BCFF),
              //     borderRadius: BorderRadius.circular(30),
              //   ),
              //   child: Icon(
              //     Icons.arrow_forward,
              //     color: Colors.white,
              //     size: 30,
              //   ),
              // ),
              // SizedBox(height: 50),
              Image.asset(
                'images/charak.png', // Make sure to add your image to the assets folder and update the path
                height: getScaledHeight(50, context),
              ),
              SizedBox(height: getScaledHeight(10, context)),
            ],
          ),
        ),
      // ),
    );
  }
}