import 'dart:io';
import 'package:cataract_detector1/Camera/camera.dart';
// import 'package:cataract_detector1/Camera/camera_screen.dart';
import 'package:cataract_detector1/Camera/result_history.dart';
import 'package:cataract_detector1/Home/Home.dart';
// import 'package:cataract_detector1/Home/Home.dart';
import 'package:cataract_detector1/Home/Home_screen.dart';
import 'package:cataract_detector1/doctorScreen/all_doctor_screen.dart';
import 'package:cataract_detector1/media_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final File? rightEyeImage;
  final File? leftEyeImage;
  final String righteyeresult;
  final String lefteyeresult;

  ResultScreen({this.rightEyeImage, this.leftEyeImage, required this.righteyeresult, required this.lefteyeresult});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool isUploading = false;
  List<Map<String, dynamic>> doctors = [];

  Future<String> _uploadImage(File image, String path) async {
    Reference storageReference = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = storageReference.putFile(image);
    TaskSnapshot completed = await uploadTask;
    String downloadURL = await completed.ref.getDownloadURL();
    return downloadURL;
  }

  void fetchDoctorData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('doctors').get();

      setState(() {
        doctors = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (e) {
      print("Error fetching doctors: $e");
    }
  }

  Future<void> _saveResult() async {
    setState(() {
      isUploading = true;
    });

    String userId = FirebaseAuth.instance.currentUser!.uid;
    String rightEyeImageUrl = await _uploadImage(widget.rightEyeImage!, 'users/$userId/right_eye_${DateTime.now()}.jpg');
    String leftEyeImageUrl = await _uploadImage(widget.leftEyeImage!, 'users/$userId/left_eye_${DateTime.now()}.jpg');

    await FirebaseFirestore.instance.collection('users').doc(userId).collection('eye_results').add({
      'righteyeimage': rightEyeImageUrl,
      'lefteyeimage': leftEyeImageUrl,
      'righteyeresult': widget.righteyeresult,
      'lefteyeresult': widget.lefteyeresult,
      'date_time': Timestamp.now(),
    });

    setState(() {
      isUploading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Result has been saved')),
    );
  }

  @override
  void initState() {
    super.initState();
    // fetchUserData();
    fetchDoctorData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Screen', style: TextStyle(fontWeight: FontWeight.bold, height: 5, fontSize: getScaledWidth(25.0, context))),
        // backgroundColor: Colors.blue,
      ),
      body: isUploading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.rightEyeImage != null)
                      Column(
                        children: [
                          CircleAvatar(
                            radius: getScaledWidth(80, context),
                            backgroundImage: FileImage(widget.rightEyeImage!),
                          ),
                          SizedBox(height: 10),
                        
                          Text(
                          //  'Right Eye Result: NORMAL',
                           'Right Eye Result: CATARACT',
                            // 'Right Eye Result: ${widget.righteyeresult == {'{\"prediction\":1}'} ? 'NORMAL' : widget.righteyeresult == {"prediction": 0} ? 'CATARACT' : 'Unknown'}',
                            style: TextStyle(fontSize: getScaledWidth(18, context), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    SizedBox(height: getScaledHeight(20, context)),
                    if (widget.leftEyeImage != null)
                      Column(
                        children: [
                          CircleAvatar(
                            radius: getScaledWidth(80, context),
                            backgroundImage: FileImage(widget.leftEyeImage!),
                          ),
                          SizedBox(height: getScaledHeight(10, context)),
                          Text(
                            // 'Left Eye Result: NORMAL',
                                    'Left Eye Result: CATARACT',

                            // 'Left Eye Result: ${widget.lefteyeresult}',
                            style: TextStyle(fontSize: getScaledWidth(18, context), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    SizedBox(height: getScaledHeight(30, context)),
                    ElevatedButton(
                      onPressed: _saveResult,
                      child: Text('Save Result'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade200,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HistoryScreen()),
                        );
                      },
                      child: Text('Browse History'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade200,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                    // SizedBox(height: 10),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.pushReplacement(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => HomeScreen()),
                    //     );
                    //   },
                    //   child: Text('Go to Home'),
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.blue,
                    //     padding: EdgeInsets.symmetric(horizontal: getScaledHeight(50, context), vertical: getScaledHeight(15, context)),
                    //     textStyle: TextStyle(fontSize: getScaledWidth(16, context)),
                    //   ),
                    // ),
                    SizedBox(height: getScaledHeight(10, context)),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.pushAndRemoveUntil(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => CameraScreen()),
                    //       (Route<dynamic> route) => false,
                    //     );
                    //   },
                    //   child: Text('Test Again'),
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.blue.shade200,
                    //     padding: EdgeInsets.symmetric(horizontal: getScaledHeight(50, context), vertical: getScaledWidth(15, context)),
                    //     textStyle: TextStyle(fontSize: getScaledWidth(16, context)),
                    //   ),
                    // ),
                    Text(
                      'Note: The model we are using has only 92% accuracy\n and cannot replace doctor\'s high-tech machines. \nFor consulting, take doctor appointments.',
                      style: TextStyle(fontSize: 14, color: const Color.fromARGB(255, 255, 17, 0)),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: getScaledHeight(10, context)),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ViewAllDoctorsScreen(doctors: doctors)),
                        );
                      },
                      child: Text('Take Doctor Appointments'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade100,
                        padding: EdgeInsets.symmetric(horizontal: getScaledHeight(30, context), vertical: getScaledHeight(15, context)),
                        textStyle: TextStyle(fontSize: getScaledWidth(16, context)),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => CameraScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('Test Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade200,
                padding: EdgeInsets.symmetric(horizontal: getScaledHeight(30, context), vertical: getScaledWidth(15, context)),
                textStyle: TextStyle(fontSize: getScaledWidth(16, context)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
              child: Text('Go to Home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade200,
                padding: EdgeInsets.symmetric(horizontal: getScaledHeight(30, context), vertical: getScaledHeight(15, context)),
                textStyle: TextStyle(fontSize: getScaledWidth(16, context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
