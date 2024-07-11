// ignore_for_file: use_build_context_synchronously

// import 'package:cataract_detector1/Camera/current_result.dart';
import 'package:cataract_detector1/Camera/result.dart';
import 'package:cataract_detector1/Camera/result_history.dart';
import 'package:cataract_detector1/media_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  File? _image;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  fetchUserData() async {
  if (user != null) {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>;
        });
      } else {
        print("User document does not exist");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  } else {
    print("No authenticated user found");
  }
}

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _uploadImage();
    }
  }

Future<void> _uploadImage() async {
  if (_image != null && user != null) {
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('user_images/${user!.uid}.jpg');
      UploadTask uploadTask = storageReference.putFile(_image!);
      await uploadTask;
      String imageUrl = await storageReference.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'UserProfilePicture': imageUrl});
      setState(() {
        userData!['UserProfilePicture'] = imageUrl;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to upload image: $e'),
      ));
    }
  }
}

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Could not launch $url'),
      ));
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('About the App'),
          content: Text(
              'This app was developed by a dedicated team to help users to detect their eyes from cataract, and enable them to contact the Ophthalmologists \nNOTE: This is not a replacement of the doctor\'s machine, it\'s just an art of Artificial Intelligence which tells you the chance of being cataract positive.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            // backgroundColor: Colors.white,
            'Profile',
            style: TextStyle(fontWeight: FontWeight.bold, height: 5, fontSize: getScaledWidth(25.0, context)),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: _showInfoDialog,
            ),
          ],
        ),
        body: userData == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Stack(
  children: [
    CircleAvatar(
      radius: 80,
      backgroundImage: userData!['UserProfilePicture'] != null
          ? NetworkImage(userData!['UserProfilePicture'])
          : AssetImage('images/placeholder.png')
              as ImageProvider,
    ),
    if (userData!['UserProfilePicture'] == null)
      Positioned.fill(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
  ],
),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon: Icon(Icons.camera_alt, size: 30),
                              onPressed: () {
                                _pickImage(ImageSource.gallery);
                              },
                            ),
                          ),
                        ],
                      ),
                     SizedBox(height: getScaledHeight(20.0,context),),
                    itemProfile('Patient Name', userData!['name'] ?? 'Name not available'),
                    SizedBox(height: getScaledHeight(10.0,context),),
                    itemProfile('Email', userData!['email'] ?? 'Email not available'),
                    SizedBox(height: getScaledHeight(10.0,context),),
                    itemProfile('Phone No.', '+91 '+userData!['phone']),
                    SizedBox(height: getScaledHeight(10.0,context),),
                    itemProfile('Age', userData!['age'] ?? 'Age not available'),
                    SizedBox(height: getScaledHeight(10.0,context),),
                    itemProfile('Gender', userData!['gender'] ?? 'Gender not available'),
                   
                      SizedBox(height: getScaledHeight(30.0,context),),
                      SizedBox(
                        width: getScaledWidth(double.infinity,context),
                        child: ElevatedButton(
                          onPressed: (){
                            // final results = await _fetchResultsFromFirebase();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryScreen() ,
                ),
              );
                          },
                          style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                          child: Text('View Result History', style: TextStyle(fontSize: getScaledWidth(20, context), color: Colors.white, fontWeight: FontWeight.bold), ),
                        ),
                      ),
                       SizedBox(height: getScaledHeight(20.0,context),),
                      ElevatedButton(
                        onPressed: _logout,
                        child: Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade100,
                        ),
                      ),
                      
                      SizedBox(height: getScaledHeight(30.0,context),),
                      // Column(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(FontAwesomeIcons.facebook,
                                color: Colors.blue, size: getScaledWidth(30, context)),
                            onPressed: () => _launchURL(
                                'https://www.facebook.com/DrishtiCPS/'),
                          ),
                          IconButton(
        icon: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100), // Optional: Round corners for a better look
        gradient: instagramGradient,
      ),
      child: Icon(
        FontAwesomeIcons.instagram,
        size: getScaledWidth(30, context),
        color: Colors.white, // Set icon color to white to contrast with the gradient
      ),
        ),
        onPressed: () => _launchURL('https://www.instagram.com/p/CmQNQmXo-nI/'),
      ),
      
                          IconButton(
                            icon: Icon(FontAwesomeIcons.linkedin,
                                color: Colors.blue, size: getScaledWidth(30, context)),
                            onPressed: () => _launchURL(
                                'https://www.linkedin.com/company/iiti-drishti-cps-foundation-iit-indore/'),
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.twitter,
                                color: Colors.black, size: getScaledWidth(30, context)),
                            onPressed: () =>
                                _launchURL('https://x.com/DRISHTICPS'),
                          ),
                        ],
                      ),
                     Image.asset(
                  'images/charak.png',
                  height: getScaledHeight(50.0,context),
                ), 
                    ],
                  ),
                ),
              ),
      ),
    );
  }
LinearGradient instagramGradient = LinearGradient(
  colors: [
    Color(0xFFfeda75), // Light yellow
    Color(0xFFfa7e1e), // Orange
    Color(0xFFd62976), // Pink
    Color(0xFF962fbf), // Purple
    Color(0xFF4f5bd5), // Blue
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
  itemProfile(String title, dynamic subtitle) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 2),
              color: Colors.blue.shade100,
              spreadRadius: 1,
              blurRadius: 1,
            )
          ]),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle.toString()),
        // trailing: Icon(Icons.arrow_forward, color: Colors.black),
        tileColor: Colors.white,
),
// ListTile


    );
  }
    Future<List<Result>> _fetchResultsFromFirebase() async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final querySnapshot = await firestore
          .collection('users')
          .doc(user.uid)
          .collection('eye_results')
          .get();

      return querySnapshot.docs
          .map((doc) => Result.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } else {
      print('No authenticated user found');
      return [];
    }
  }
  


}
