import 'dart:io';
import 'package:cataract_detector1/Camera/current_result.dart';
import 'package:cataract_detector1/media_query.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? cameraController;
  File? _rightEyeImage;
  File? _leftEyeImage;
  String? _righteyeresult;
  String? _lefteyeresult;
  bool isRightEyeScanned = false;
  bool isLeftEyeScanned = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      print('No cameras available');
      return;
    }
    final firstCamera = cameras.first;
    cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    await cameraController!.initialize();
    setState(() {});
  }

  void _disposeCamera() {
    cameraController?.dispose();
    cameraController = null;
  }

  void _takePicture(ImageSource source, String eye) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: source,
      maxWidth: getScaledWidth(600.0, context),
    );
    if (pickedImage == null) {
      return;
    }
    final croppedImage = await _cropImage(File(pickedImage.path));
    if (croppedImage != null) {
      setState(() {
        if (eye == 'right') {
          _rightEyeImage = croppedImage;
          isRightEyeScanned = true;
        } else if (eye == 'left') {
          _leftEyeImage = croppedImage;
          isLeftEyeScanned = true;
        }
      });
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Zoom the Photo and place your Eye inside the grid to Crop',
          toolbarColor: Colors.blue[400],
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Zoom the Photo and place your Eye inside the grid to Crop',
          minimumAspectRatio: 1.0,
        ),
      ],
    );
    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return null;
  }

  void _showBottomSheet(String eye) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Upload from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _takePicture(ImageSource.gallery, eye);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Take Picture through Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _takePicture(ImageSource.camera, eye);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCircularImage(File? imageFile) {
    if (imageFile == null) {
      return CircleAvatar(
        radius: 75,
        backgroundColor: Color.fromARGB(255, 211, 211, 211),
        child: Icon(
          Icons.image,
          size: 50,
          color: Colors.grey[600],
        ),
      );
    } else {
      return ClipOval(
        child: Image.file(
          imageFile,
          width: getScaledWidth(150, context),
          height: getScaledHeight(150.0, context),
          fit: BoxFit.cover,
        ),
      );
    }
  }

  Future<void> _navigateToResultPage() async {
    if (_rightEyeImage != null && _leftEyeImage != null) {
      setState(() {
        isLoading = true;
      });

      try {
        var rightEyeRequest = http.MultipartRequest(
          'POST',
          Uri.parse('https://cataract-detection-api-8b89318d0d10.herokuapp.com/predict'),
        )..files.add(await http.MultipartFile.fromPath('file', _rightEyeImage!.path, filename: 'right_eye_image.jpg'));

        var rightEyeResponse = await rightEyeRequest.send();

        var leftEyeRequest = http.MultipartRequest(
          'POST',
          Uri.parse('https://cataract-detection-api-8b89318d0d10.herokuapp.com/predict'),
        )..files.add(await http.MultipartFile.fromPath('file', _leftEyeImage!.path, filename: 'left_eye_image.jpg'));

        var leftEyeResponse = await leftEyeRequest.send();

        if (rightEyeResponse.statusCode == 200 && leftEyeResponse.statusCode == 200) {
          var rightEyeJsonResponse = await rightEyeResponse.stream.bytesToString();
          var rightEyeResult = rightEyeJsonResponse;

          var leftEyeJsonResponse = await leftEyeResponse.stream.bytesToString();
          var leftEyeResult = leftEyeJsonResponse;

          setState(() {
            _righteyeresult = rightEyeResult;
            _lefteyeresult = leftEyeResult;
            isLoading = false;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                rightEyeImage: _rightEyeImage!,
                leftEyeImage: _leftEyeImage!,
                righteyeresult: _righteyeresult!,
                lefteyeresult: _lefteyeresult!,
              ),
            ),
          );
        } else {
          print('Failed to load response.');
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('Both images must be selected before navigating.');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _disposeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Eye Scan', style: TextStyle(fontWeight: FontWeight.bold, height: 5, fontSize: getScaledWidth(25.0, context))
        ),
        // backgroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: getScaledHeight(20.0, context)),
                  Text(
                    'FETCHING RESULTS FROM SERVER',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'YOUR PATIENCE IS HIGHLY OBLIGED',
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCircularImage(_rightEyeImage),
                        _buildCircularImage(_leftEyeImage),
                      ],
                    ),
                    SizedBox(height: getScaledHeight(20.0, context)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showBottomSheet('right');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text('SCAN RIGHT EYE'),
                        ),
                        ElevatedButton(
                          onPressed: isRightEyeScanned
                              ? () {
                                  _showBottomSheet('left');
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text('SCAN LEFT EYE'),
                        ),
                      ],
                    ),
                    SizedBox(height: getScaledHeight(20.0, context)),
                    Text(
                      'Instructions:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '1. Keep your face in front of the camera.\n'
                      '2. Make sure your entire eye is visible in the grid,\n also the flash light  must be on but the reflection must not fall on eye lens\n'
                      '3. Crop the image so that your whole eye is within the grid.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Image.asset(
                      'images/dummy.jpeg',
                      width: getScaledWidth(150, context),
                      height: getScaledHeight(150.0, context),
                    ),
                    SizedBox(height: getScaledHeight(90.0, context)),
                    ElevatedButton(
                      onPressed: isRightEyeScanned && isLeftEyeScanned
                          ? () async {
                              bool? confirmed = await _confirmImagesDialog();
                              if (confirmed == true) {
                                _navigateToResultPage();
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text('NEXT'),
                    ),
                  ],
                ),
              ),
          ),
    );
  }

  Future<bool?> _confirmImagesDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Images'),
          content: Text('Are you sure you want to proceed with these images?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Retake'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
