import 'dart:async';
import 'package:cataract_detector1/Home/Home.dart';
import 'package:cataract_detector1/media_query.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ForgotPhone extends StatefulWidget {
  const ForgotPhone({super.key});

  @override
  State<ForgotPhone> createState() => _ForgotPhoneState();
}

class _ForgotPhoneState extends State<ForgotPhone> {
  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: ""
  );

  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String verificationId = "";
  bool otpSent = false;
  bool otpVerified = false;
  Timer? _timer;
  int _start = 60;
  List<Map<String, dynamic>> userAccounts = [];

  sendOTP() async {
    if (phoneController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
        otpSent = false;
        otpVerified = false;
      });
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+${selectedCountry.phoneCode}${phoneController.text}",
          verificationCompleted: (PhoneAuthCredential credential) async {
            await FirebaseAuth.instance.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "Failed to send OTP: ${e.message}",
                style: TextStyle(fontSize: getScaledWidth(18.0, context)),
              ),
            ));
          },
          codeSent: (String verificationId, int? resendToken) {
            setState(() {
              _isLoading = false;
              otpSent = true;
              this.verificationId = verificationId;
              startTimer();
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "OTP sent successfully",
                style: TextStyle(fontSize: getScaledWidth(20, context)),
              ),
            ));
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "An error occurred: $e",
            style: TextStyle(fontSize: getScaledWidth(18.0, context)),
          ),
        ));
      }
    }
  }

  verifyOTP() async {
    if (otpController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otpController.text,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);

        // Fetch user accounts linked to this phone number
        String phoneNumber = "+${selectedCountry.phoneCode}${phoneController.text}";
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('phone', isEqualTo: phoneNumber)
            .get();

        if (querySnapshot.docs.isEmpty) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "No accounts linked with this phone number.",
              style: TextStyle(fontSize: getScaledWidth(18.0, context)),
            ),
          ));
        } else {
          userAccounts = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
          setState(() {
            _isLoading = false;
            otpVerified = true;
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Invalid OTP",
            style: TextStyle(fontSize: getScaledWidth(18.0, context)),
          ),
        ));
      }
    }
  }

  startTimer() {
    setState(() {
      _start = 60;
    });
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: getScaledHeight(20.0, context)),
                  Text("Wait For Few Seconds"),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: screenWidth,
                    child: Image.asset(
                      "images/drishti_logo.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: getScaledHeight(30.0, context)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          buildTextFormFieldPhone(phoneController,
                              "Phone Number", "Please Enter Phone Number"),
                          SizedBox(height: getScaledHeight(20.0, context)),
                          if (otpSent)
                            buildTextFormFieldOTP(otpController,
                                "Enter OTP", "Please Enter OTP"),
                          SizedBox(height: getScaledHeight(20.0, context)),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                otpSent ? verifyOTP() : sendOTP();
                              }
                            },
                            child: otpSent
                                ? buildVerifyOTPButton(screenWidth)
                                : buildSendOTPButton(screenWidth),
                          ),
                          if (otpSent)
                            TextButton(
                              onPressed: _start == 0
                                  ? () {
                                      sendOTP();
                                    }
                                  : null,
                              child: Text(
                                _start == 0
                                    ? "Resend OTP"
                                    : "Resend OTP in $_start seconds",
                                style: TextStyle(
                                  color: _start == 0
                                      ? Colors.blue
                                      : Colors.grey,
                                  fontSize: getScaledWidth(18.0, context),
                                ),
                              ),
                            ),
                          if (otpVerified)
                            Column(
                              children: [
                                Text(
                                  "Select an account to log in",
                                  style: TextStyle(
                                      fontSize: getScaledWidth(18.0, context),
                                      fontWeight: FontWeight.bold),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: userAccounts.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(userAccounts[index]['name']),
                                      subtitle: Text(userAccounts[index]['email']),
                                      onTap: () {
                                        // Set the selected user account here
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Home()),
                                          (route) => false,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: getScaledHeight(20.0, context)),
                  Image.asset(
                    'images/charak.png',
                    height: getScaledHeight(50.0, context),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildTextFormFieldPhone(TextEditingController controller, String hintText,
      String validationMessage,
      {bool isNumber = false, bool obscureText = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
      decoration: BoxDecoration(
        color: Color(0xFFedf0f8),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              showCountryPicker(
                context: context,
                showPhoneCode: true,
                onSelect: (Country country) {
                  setState(() {
                    selectedCountry = country;
                  });
                },
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: Color(0xFFedf0f8),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}",
                style: TextStyle(
                  fontSize: getScaledWidth(18.0, context),
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(width: getScaledWidth(10.0, context)),
          Expanded(
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return validationMessage;
                }
                return null;
              },
              controller: controller,
              keyboardType: isNumber ? TextInputType.number : TextInputType.text,
              obscureText: obscureText,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(
                    color: Color(0xFFb2b7bf),
                    fontSize: getScaledWidth(18.0, context)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextFormFieldOTP(TextEditingController controller, String hintText,
      String validationMessage,
      {bool isNumber = true, bool obscureText = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
      decoration: BoxDecoration(
        color: Color(0xFFedf0f8),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validationMessage;
          }
          return null;
        },
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
              color: Color(0xFFb2b7bf),
              fontSize: getScaledWidth(18.0, context)),
        ),
      ),
    );
  }

  Widget buildSendOTPButton(double screenWidth) {
    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 30.0),
      decoration: BoxDecoration(
        color: Color(0xFF273671),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          "Send OTP",
          style: TextStyle(
              color: Colors.white,
              fontSize: getScaledWidth(22.0, context),
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget buildVerifyOTPButton(double screenWidth) {
    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 30.0),
      decoration: BoxDecoration(
        color: Color(0xFF273671),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          "Verify OTP",
          style: TextStyle(
              color: Colors.white,
              fontSize: getScaledWidth(22.0, context),
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
