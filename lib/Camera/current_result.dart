// import 'dart:io';
// import 'package:cataract_detector1/Camera/camera.dart';
// import 'package:cataract_detector1/Camera/result_history.dart';
// import 'package:cataract_detector1/Camera/result_history_screen.dart';
// import 'package:cataract_detector1/Home/Home.dart';
// import 'package:cataract_detector1/media_query.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'result.dart';

// class ResultScreen extends StatefulWidget {
//   final File rightEyeImage;
//   final File leftEyeImage;
//   final String righteyeresult;
//   final String lefteyeresult;
//   final List<Result> results;

//   const ResultScreen({
//     Key? key,
//     required this.rightEyeImage,
//     required this.leftEyeImage,
//     required this.righteyeresult,
//     required this.lefteyeresult,
//     required this.results,
//   }) : super(key: key);

//   @override
//   State<ResultScreen> createState() => _ResultScreenState();
// }

// class _ResultScreenState extends State<ResultScreen> {
//   User? user = FirebaseAuth.instance.currentUser;
//   Map<String, dynamic>? userData;
//   bool isResultSaved = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text('Result'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 75,
//               backgroundImage: FileImage(widget.rightEyeImage),
//             ),
//             Text(
//               'Right Eye: ${widget.righteyeresult}',
//               style: TextStyle(fontSize: getScaledWidth(16, context), fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: getScaledHeight(20.0, context)),
//             CircleAvatar(
//               radius: 75,
//               backgroundImage: FileImage(widget.leftEyeImage),
//             ),
//             Text(
//               'Left Eye: ${widget.lefteyeresult}',
//               style: TextStyle(fontSize: getScaledWidth(16, context), fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: getScaledHeight(20.0, context)),
//             ElevatedButton(
//               onPressed: () async {
//                 final newResult = Result(
//                   rightEyeResult: widget.righteyeresult,
//                   leftEyeResult: widget.lefteyeresult,
//                   rightEyeImagePath: '', // Initialize image paths before upload
//                   leftEyeImagePath: '',
//                   dateTime: DateTime.now(),
//                 );

//                 await _uploadImages(newResult); // Upload images first
//                 await _saveResultsToFirebase(newResult); // Save data to Firestore

//                 widget.results.add(newResult); // Update local results list
//                 setState(() {
//                   isResultSaved = true; // Enable view result history button
//                 });
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Your result is saved')),
//                 );
//               },
//               child: Text('Save Result'),
//             ),
//             SizedBox(height: getScaledHeight(20.0, context)),
//             ElevatedButton(
//               onPressed: isResultSaved
//                   ? () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ResultHistoryScreen(),
//                         ),
//                       );
//                     }
//                   : null,
//               child: Text('VIEW RESULT HISTORY'),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => Home()),
//                   );
//                 },
//                 child: Text('HOME PAGE'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => CameraScreen()),
//                   );
//                 },
//                 child: Text('TEST AGAIN'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _saveResultsToFirebase(Result newResult) async {
//     final firestore = FirebaseFirestore.instance;
//     final user = FirebaseAuth.instance.currentUser;

//     if (user != null) {
//       final docRef = firestore
//           .collection('users')
//           .doc(user.uid)
//           .collection('eye_results')
//           .doc(); // Automatically generate a unique document ID
//       await docRef.set(newResult.toMap());
//     } else {
//       print('No authenticated user found');
//     }
//   }

//   fetchUserData() async {
//     if (user != null) {
//       try {
//         DocumentSnapshot userDoc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user!.uid)
//             .get();
//         if (userDoc.exists) {
//           setState(() {
//             userData = userDoc.data() as Map<String, dynamic>;
//           });
//         } else {
//           print("User document does not exist");
//         }
//       } catch (e) {
//         print("Error fetching user data: $e");
//       }
//     } else {
//       print("No authenticated user found");
//     }
//   }

//   Future<void> _uploadImages(Result newResult) async {
//     if (user != null) {
//       try {
//         Reference rightEyeRef = FirebaseStorage.instance
//             .ref()
//             .child('eye_images/${newResult.dateTime.toIso8601String()}_${user!.uid}_right.jpg');
//         TaskSnapshot uploadTask1 = await rightEyeRef.putFile(widget.rightEyeImage);
//         await uploadTask1;
//         newResult.rightEyeImagePath = await rightEyeRef.getDownloadURL();

//         Reference leftEyeRef = FirebaseStorage.instance
//             .ref()
//             .child('eye_images/${newResult.dateTime.toIso8601String()}_${user!.uid}_left.jpg');
//         TaskSnapshot uploadTask2 = await leftEyeRef.putFile(widget.leftEyeImage);
//         await uploadTask2;
//         newResult.leftEyeImagePath = await leftEyeRef.getDownloadURL();
//       } catch (e) {
//         print('Error uploading images: $e');
//       }
//     }
//   }
// }
// import 'dart:io';

// import 'package:cataract_detector1/Camera/result_history.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ResultScreen extends StatelessWidget {
//   final File rightEyeImage;
//   final File leftEyeImage;
//   final String righteyeresult;
//   final String lefteyeresult;

//   ResultScreen({
//     required this.rightEyeImage,
//     required this.leftEyeImage,
//     required this.righteyeresult,
//     required this.lefteyeresult,
//   });

//   Future<void> _saveResults(BuildContext context) async {
//     FirebaseFirestore firestore = FirebaseFirestore.instance;
//     final user = FirebaseAuth.instance.currentUser;

//     await firestore.collection('users').doc(user?.uid).collection('eye_results').add({
//       'lefteyeimage': leftEyeImage.path,
//       'righteyeimage': rightEyeImage.path,
//       'lefteyeresult': lefteyeresult,
//       'righteyeresult': righteyeresult,
//       'date_time': Timestamp.now(),
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Results saved successfully!')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Result Screen'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Image.file(rightEyeImage, width: 150, height: 150),
//             Text('Right Eye Result: $righteyeresult'),
//             SizedBox(height: 20),
//             Image.file(leftEyeImage, width: 150, height: 150),
//             Text('Left Eye Result: $lefteyeresult'),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _saveResults(context),
//               child: Text('Save Result'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => HistoryScreen()),
//                 );
//               },
//               child: Text('History'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:cataract_detector1/Camera/camera.dart';
// import 'package:cataract_detector1/Camera/camera_screen.dart';
import 'package:cataract_detector1/Camera/result_history.dart';
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
        
        title: Text('Result Screen',style: TextStyle(fontWeight: FontWeight.bold, height: 5, fontSize: getScaledWidth(25.0, context))),
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
                            'Right Eye Result: ${widget.righteyeresult}',
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
                            'Left Eye Result: ${widget.lefteyeresult}',
                            style: TextStyle(fontSize: getScaledWidth(18, context), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    SizedBox(height: getScaledHeight(30, context)),
                    ElevatedButton(
                      onPressed: _saveResult,
                      child: Text('Save Result'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Colors.blue.shade200,
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
                        padding: EdgeInsets.symmetric(horizontal: getScaledHeight(50, context), vertical: getScaledWidth(15, context)),
                        textStyle: TextStyle(fontSize: getScaledWidth(16, context)),
                      ),
                    ),
                    SizedBox(height: getScaledHeight(10, context)),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ViewAllDoctorsScreen(doctors: doctors,)),
                        );
                      },
                      child: Text('Take Doctor Appointments'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade100,
                        padding: EdgeInsets.symmetric(horizontal: getScaledHeight(30, context), vertical: getScaledHeight(15, context)),
                        textStyle: TextStyle(fontSize: getScaledWidth(16, context)),
                      ),
                    ),
                    Text(
                      'Note: The model we are using has only 92% accuracy\n and cannot replace doctor\'s high-tech machines. \nFor consulting, take doctor appointments.',
                      style: TextStyle(fontSize: 14, color: const Color.fromARGB(255, 255, 17, 0)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          ),
    );
  }
}
