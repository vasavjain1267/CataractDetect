import 'package:cataract_detector1/ForgetPassswordPhone/forgetpassphone.dart';
import 'package:cataract_detector1/ForgetPasswordEmail/forgetpassemail.dart';
import 'package:cataract_detector1/Home/Home.dart';
// import 'package:cataract_detector1/service/auth.dart';
import 'package:cataract_detector1/SignUpPage/SignUp.dart';
import 'package:cataract_detector1/media_query.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = "", password = "";
  bool _passwordVisible = false;
  TextEditingController mailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool _isLoading = false;
  final _formkey = GlobalKey<FormState>();

  userLogin() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
        } else if (e.code == 'wrong-password') {
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            "Incorrect Password",
            style: TextStyle(fontSize: getScaledWidth(18.0, context)),
          ),
        ));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "images/drishti_logo.png",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: getScaledHeight(30.0, context),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 30.0),
                          decoration: BoxDecoration(
                              color: Color(0xFFedf0f8),
                              borderRadius: BorderRadius.circular(30)),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter E-mail';
                              }
                              return null;
                            },
                            controller: mailcontroller,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle: TextStyle(
                                    color: Color(0xFFb2b7bf),
                                    fontSize: getScaledWidth(18.0, context))),
                          ),
                        ),
                        SizedBox(
                          height: getScaledHeight(30.0, context),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 30.0),
                          decoration: BoxDecoration(
                              color: Color(0xFFedf0f8),
                              borderRadius: BorderRadius.circular(30)),
                          child: TextFormField(
                            controller: passwordcontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Password';
                              }
                              return null;
                            },
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(
                                color: Color(0xFFb2b7bf),
                                fontSize: getScaledWidth(18.0, context),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Color(0xFFb2b7bf),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: getScaledHeight(30.0, context),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_formkey.currentState!.validate()) {
                              setState(() {
                                email = mailcontroller.text;
                                password = passwordcontroller.text;
                              });
                              userLogin();
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                vertical: 13.0, horizontal: 30.0),
                            decoration: BoxDecoration(
                                color: Color(0xFF273671),
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      "Sign In",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              getScaledWidth(22.0, context),
                                          fontWeight: FontWeight.w500),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: getScaledHeight(10, context)),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          builder: (context) => Container(
                                padding: EdgeInsets.all(30.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Text("Make Selections",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            fontSize: getScaledWidth(
                                                25.0, context))),
                                    // Text("Make Suitable selection to recover/logi your Forgotten password", style: Theme.of(context). textTheme.bodyMedium),
                                    SizedBox(
                                      height: getScaledHeight(
                                          30.0, context),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ForgotPasswordEmail()));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(
                                            20.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(
                                                  10.0),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons
                                                  .mail_outline_rounded,
                                              size: 60,
                                            ),
                                            SizedBox(width: getScaledWidth(10.0, context)),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                              children: [
                                                Text("Email",
                                                    style: Theme.of(
                                                            context)
                                                        .textTheme
                                                        .bodyMedium),
                                                Text(
                                                    "Reset Via Mail Verification",
                                                    style: Theme.of(
                                                            context)
                                                        .textTheme
                                                        .bodySmall),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height: getScaledHeight(
                                            10, context)),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ForgotPhone()));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(
                                            20.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(
                                                  10.0),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons
                                                  .mobile_friendly_outlined,
                                              size: 60,
                                            ),
                                             SizedBox(width: getScaledWidth(10.0, context)),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                              children: [
                                                Text("Phone No.",
                                                    style: Theme.of(
                                                            context)
                                                        .textTheme
                                                        .bodyMedium,
                                                    selectionColor:
                                                        const Color
                                                            .fromARGB(
                                                                255,
                                                                83,
                                                                172,
                                                                245)),
                                                Text(
                                                    "Login Via Phone Verification",
                                                    style: Theme.of(
                                                            context)
                                                        .textTheme
                                                        .bodySmall),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ));
                    },
                    child: Text("Forgot Password?",
                        style: TextStyle(
                            color: Color(0xFF8c8e98),
                            fontSize: getScaledWidth(18.0, context),
                            fontWeight: FontWeight.w500)),
                  ),
                ),
                SizedBox(
                  height: getScaledHeight(10, context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?",
                        style: TextStyle(
                            color: Color(0xFF8c8e98),
                            fontSize: getScaledWidth(18.0, context),
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      width: getScaledWidth(5.0, context),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUp()));
                      },
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                            color: Color(0xFF273671),
                            fontSize: getScaledWidth(20, context),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: getScaledHeight(70, context),
                ),
                Image.asset(
                  'images/charak.png',
                  height: getScaledHeight(50.0, context),
                ),
                // Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
