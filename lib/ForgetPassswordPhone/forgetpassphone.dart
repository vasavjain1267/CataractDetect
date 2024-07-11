// ignore_for_file: unused_local_variable

import 'package:cataract_detector1/SignUpPage/SignUp.dart';
import 'package:cataract_detector1/media_query.dart';
import 'package:cataract_detector1/src/consts/consts.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPhone extends StatefulWidget {
  const ForgotPasswordPhone({super.key});

  @override
  State<ForgotPasswordPhone> createState() => _ForgotPasswordPhoneState();
}

class _ForgotPasswordPhoneState extends State<ForgotPasswordPhone> {
  Country selectedCountry = Country(phoneCode: "91", countryCode: "IN", e164Sc: 0, geographic: true, level: 1, name:"India", example: "India", displayName: "India", displayNameNoCountryCode: "IN", e164Key: "");
  String phoneNumber = "";
  String verificationId = "";
  TextEditingController phoneController = TextEditingController();
  String smsCode = "";
  TextEditingController smsCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        navigateToSignUp();
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Failed to verify phone number: ${e.message}",
            style: TextStyle(fontSize: getScaledWidth(18, context),),
          ),
        ));
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Verification code sent to $phoneNumber",
            style: TextStyle(fontSize: getScaledWidth(18, context),),
          ),
        ));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          this.verificationId = verificationId;
        });
      },
    );
  }

  verifyCode() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      await FirebaseAuth.instance.signInWithCredential(credential);
      navigateToSignUp();
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Failed to verify code: ${e.message}",
          style: TextStyle(fontSize: getScaledWidth(18, context),),
        ),
      ));
    }
  }

  navigateToSignUp() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignUp(
              // prefilledData: userData,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
          TextPosition(offset: phoneController.text.length,),);//
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                cursorColor: Colors.blue[400],
                controller: phoneController,
              //   onChanged: (value) {
              // setState(() {
              //   phoneController.text = value;
              //   });
              //   },
                style: TextStyle(fontSize: getScaledWidth(18, context), fontWeight: FontWeight.bold,),
                decoration: InputDecoration(  
                  hintText: "Enter Your Phone Number",
                  hintStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: getScaledWidth(15, context), color: Colors.black26,) ,
                  enabledBorder: OutlineInputBorder (
                  borderRadius: BorderRadius.circular (10),
                  borderSide: const BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder (
                  borderRadius: BorderRadius.circular (10),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                prefixIcon: Container(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){
                      showCountryPicker(context: context, 
                      countryListTheme: CountryListThemeData (
                                      bottomSheetHeight: getScaledHeight(500, context)),
                      onSelect : (value) {
                            setState (() {
                          selectedCountry = value;
                      }) ;
                      });
                    },
                    child: Text("${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}", 
                    style: TextStyle(
                    fontSize: getScaledWidth(18, context), 
                    color: Colors.black, fontWeight: FontWeight.bold,
              ), // TextStyle
            ),
                  )
                ),
              suffixIcon : phoneController.text.length > 9
                  ?Container(
                    height: getScaledHeight(30.0,context),
                    width: getScaledWidth(30.0, context),
                    margin:  const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: const Icon(
                      Icons.done,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                  : null,
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    phoneNumber = value;
                  });
                },
              ),
              SizedBox(height: getScaledHeight(20.0,context),),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    verifyPhoneNumber();
                  }
                },
                child: Text("Send Verification Code",style:TextStyle(color: Colors.black,fontSize: getScaledWidth(20, context),fontWeight: FontWeight.w500 ),),
              ),
              SizedBox(height: getScaledHeight(20.0,context),),
              TextFormField(
                cursorColor: Colors.blue[400],
                controller: smsCodeController,
                decoration: InputDecoration(
                  
                  hintText: "Verification Code",
                  enabledBorder: OutlineInputBorder (
                  borderRadius: BorderRadius.circular (10),
                  borderSide: const BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder (
                  borderRadius: BorderRadius.circular (10),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    smsCode = value;
                  });
                },
              ),
              SizedBox(height: getScaledHeight(20.0,context),),
              ElevatedButton(
                onPressed: verifyCode,
                child: Text("Verify Code", style:TextStyle(color: Colors.black,fontSize: getScaledWidth(20, context),fontWeight: FontWeight.w500 ),),
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
                            width:getScaledWidth(5.0, context),
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
                      SizedBox(height: getScaledHeight(70.0,context),),
                   Image.asset(
                  'images/charak.png',
                  height: getScaledHeight(50.0,context),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
