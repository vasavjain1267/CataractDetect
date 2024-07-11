// import 'package:cataract_detector1/ForgetPasswordEmail/forgetpassemail.dart';
import 'package:cataract_detector1/SignUpPage/SignUp.dart';
import 'package:cataract_detector1/LoginPage/login.dart';
import 'package:cataract_detector1/media_query.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordEmail extends StatefulWidget {
  const ForgotPasswordEmail({super.key});

  @override
  State<ForgotPasswordEmail> createState() => _ForgotPasswordEmailState();
}

class _ForgotPasswordEmailState extends State<ForgotPasswordEmail> {
  String email = "";
  TextEditingController mailcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool emailSent = false;
  bool _isLoading = false;

  Future<void> resetPassword() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        emailSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Password Reset Email has been sent!",
          style: TextStyle(fontSize: getScaledWidth(20, context),),
        ),
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "No user found for that email.",
            style: TextStyle(fontSize: getScaledWidth(20, context),),
          ),
        ));
      }
    }finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            SizedBox(
             height: getScaledHeight(70.0,context),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: Text(
                "Password Recovery",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: getScaledWidth(30.0, context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
             height: getScaledHeight(10.0,context),
            ),
            Text(
              "Enter your email",
              style: TextStyle(
                color: Colors.black,
                fontSize: getScaledWidth(20, context),
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: ListView(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10.0),
                        decoration: BoxDecoration(

                          border: Border.all(color: Colors.black, width: getScaledWidth(2.0, context)),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Email';
                            }
                            return null;
                          },
                          controller: mailcontroller,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                              fontSize: getScaledWidth(18, context),
                              color: Colors.black,
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 30.0,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: getScaledHeight(40.0,context),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              email = mailcontroller.text;
                            });
                            resetPassword();
                          }
                        },
                        child: Container(
                          width: getScaledWidth(140.0, context),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            :  Text(
                              "Send Email",
                              style: TextStyle(
                                color: Colors.white,
                               fontSize: getScaledWidth(18, context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: getScaledHeight(50.0,context),
                      ),
                      if (emailSent)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LogIn(),
                              ),
                            );
                          },
                          child: Container(
                            width: getScaledWidth(140.0, context),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "PROCEED TO LOGIN",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: getScaledWidth(18, context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: getScaledHeight(50.0,context),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontSize: getScaledWidth(18, context),
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: getScaledWidth(5.0, context),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUp(),
                                ),
                              );
                            },
                            child: Text(
                              "Create",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: getScaledWidth(20, context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                SizedBox(height: getScaledHeight(10.0,context),),
              Image.asset(
                'images/charak.png',
                height: getScaledHeight(50.0,context),
              ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
