// import 'package:cataract_detector1/Home/controller/home_controller1.dart';
// import 'package:cataract_detector1/doctorScreen/all_doctor_screen.dart';
// import 'package:cataract_detector1/doctorScreen/doctor_screen.dart';
// import 'package:cataract_detector1/media_query.dart';
// import 'package:intl/intl.dart';
// import 'package:cataract_detector1/Home/controller/home_screen_controller.dart';
// import 'package:cataract_detector1/src/consts/consts.dart';
// import 'package:cataract_detector1/profile_screen/profile.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<Map<String, dynamic>> doctors = [];
//   User? user = FirebaseAuth.instance.currentUser;
//   Map<String, dynamic>? userData;
//   var controller = Get.put(HomeController());
//   final PageController _pageController = PageController();
//   final HomeController1 controller1 = Get.put(HomeController1());
//   final ScrollController _scrollController = ScrollController();

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

//   void fetchDoctorData() async {
//     try {
//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance.collection('doctors').get();

//       setState(() {
//         doctors = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
//       });
//     } catch (e) {
//       print("Error fetching doctors: $e");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//     fetchDoctorData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     String currentMonthYear = DateFormat.yMMMM().format(DateTime.now());
//     int currentDay = DateTime.now().day;
//     List<DateTime> weekDays = List.generate(7, (index) => DateTime.now().add(Duration(days: index - DateTime.now().weekday + 1)));

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: userData == null
//           ? Center(child: CircularProgressIndicator())
//           : SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Row(
//                       children: [
//                         Column(
//                           children: [
//                             Text(
//                               'Welcome back,',
//                               style: TextStyle(color: Colors.black, fontSize: getScaledWidth(15.0, context)),
//                             ),
//                             SizedBox(height: getScaledHeight(5.0, context)),
//                             Text(
//                               userData!['name'],
//                               style: TextStyle(color: Colors.black, fontSize: getScaledWidth(25.0, context), fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         Spacer(),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => ProfileScreen()),
//                             );
//                           },
//                           child: CircleAvatar(
//                             backgroundImage: userData!['UserProfilePicture'] != null
//                                 ? NetworkImage(userData!['UserProfilePicture'])
//                                 : AssetImage('images/placeholder.png') as ImageProvider, // Placeholder image
//                             radius: 25,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: getScaledHeight(16.0, context)),
//                     ElevatedButton(
//                       onPressed: () {
//                         controller1.currentNavIndex.value = 1;
//                         _pageController.jumpToPage(1);
//                       },
//                       child: Text(
//                         'Click To GET YOUR EYES\n CHECKED',
//                         style: TextStyle(color: Colors.black, fontSize: getScaledWidth(18.0, context), fontWeight: FontWeight.bold),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: getScaledHeight(20.0, context)),
//                     Row(
//                       children: [
//                         Text(
//                           'Available Doctors',
//                           style: TextStyle(color: Colors.black, fontSize: getScaledWidth(18.0, context), fontWeight: FontWeight.bold),
//                         ),
//                         Spacer(),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => ViewAllDoctorsScreen(doctors: doctors)),
//                             );
//                           },
//                           child: Align(
//                             alignment: Alignment.centerRight,
//                             child: Text(
//                               "View All",
//                               style: TextStyle(color: AppColors.primeryColor, fontSize: AppFontSize.size16),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: getScaledHeight(8.0, context)),
//                     Container(
//                       height: getScaledHeight(200.0, context),
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         scrollDirection: Axis.horizontal,
//                         itemCount: doctors.length,
//                         itemBuilder: (context, index) {
//                           var doctor = doctors[index];
//                           return Container(
//                             width: getScaledWidth(125.0, context),
//                             margin: EdgeInsets.symmetric(horizontal: 10),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(15),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black12,
//                                   blurRadius: 4,
//                                   spreadRadius: 2,
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => DoctorScreen(doctor: doctor),
//                                       ),
//                                     );
//                                   },
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(10),
//                                       topRight: Radius.circular(10),
//                                     ),
//                                     child: Image.network(
//                                       doctor['docProfilePic'],
//                                       height: getScaledHeight(110.0, context),
//                                       width: getScaledWidth(double.infinity, context),
//                                       fit: BoxFit.cover,
//                                       errorBuilder: (context, error, stackTrace) {
//                                         return Image.asset(
//                                           'images/placeholder.png',
//                                           height: getScaledHeight(110.0, context),
//                                           width: getScaledWidth(double.infinity, context),
//                                           fit: BoxFit.cover,
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.all(8.0),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "Dr. " + doctor['docName'],
//                                         style: TextStyle(
//                                           fontSize: getScaledWidth(20, context),
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.black.withOpacity(0.6),
//                                         ),
//                                       ),
//                                       Text(
//                                         doctor['docType'],
//                                         style: TextStyle(
//                                           fontSize: getScaledWidth(10.0, context),
//                                           color: Colors.black.withOpacity(0.6),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     SizedBox(height: getScaledHeight(1.0, context)),
//                     Text(
//                       currentMonthYear,
//                       style: TextStyle(color: Colors.black, fontSize: getScaledWidth(18.0, context), fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: getScaledHeight(8.0, context)),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: weekDays.map((date) {
//                         bool isSelected = date.day == currentDay;
//                         return _calendarDay(
//                           DateFormat('EEE').format(date),
//                           date.day.toString(),
//                           isSelected: isSelected,
//                         );
//                       }).toList(),
//                     ),
//                     SizedBox(height: getScaledHeight(16.0, context)),
//                     Text(
//                       'Confirmed upcoming appointments',
//                       style: TextStyle(color: Colors.black, fontSize: getScaledWidth(18.0, context), fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: getScaledHeight(8.0, context)),
//                     Expanded(
//                       child: StreamBuilder<QuerySnapshot>(
//                         stream: FirebaseFirestore.instance
//                             .collection('users')
//                             .doc(user!.uid)
//                             .collection('Appointments')
//                             .where('status', isEqualTo: 'Confirmed')
//                             .snapshots(),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState == ConnectionState.waiting) {
//                             return Center(child: CircularProgressIndicator());
//                           }
//                           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                             return Center(child: Text('No confirmed appointments.'));
//                           }
//                           return ListView.builder(
//                             itemCount: snapshot.data!.docs.length,
//                             itemBuilder: (context, index) {
//                               var appointment = snapshot.data!.docs[index].data() as Map<String, dynamic>;
//                               return Card(
//                                 elevation: 4,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: ListTile(
//                                   title: Text(
//                                     appointment['doctorName'] ?? 'No Doctor Name',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black.withOpacity(0.7),
//                                     ),
//                                   ),
//                                   subtitle: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text('Date: ${DateFormat('d/MMMM/y').format((appointment['date'] as Timestamp).toDate()) ?? 'No Date'}'),
//                                       Text('Time: ${appointment['time'] ?? 'No Time'}'),
//                                     ],
//                                   ),

//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _calendarDay(String dayName, String dayNumber, {bool isSelected = false}) {
//     return Container(
//       decoration: isSelected
//           ? BoxDecoration(color: AppColors.primeryColor, borderRadius: BorderRadius.circular(10))
//           : null,
//       padding: EdgeInsets.all(8.0),
//       child: Column(
//         children: [
//           Text(
//             dayName,
//             style: TextStyle(
//               fontSize: AppFontSize.size14,
//               fontWeight: FontWeight.bold,
//               color: isSelected ? Colors.white : Colors.black,
//             ),
//           ),
//           Text(
//             dayNumber,
//             style: TextStyle(
//               fontSize: AppFontSize.size14,
//               fontWeight: FontWeight.bold,
//               color: isSelected ? Colors.white : Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cataract_detector1/Home/controller/home_controller1.dart';
import 'package:cataract_detector1/doctorScreen/all_doctor_screen.dart';
import 'package:cataract_detector1/doctorScreen/doctor_screen.dart';
import 'package:cataract_detector1/media_query.dart';
import 'package:intl/intl.dart';
import 'package:cataract_detector1/Home/controller/home_screen_controller.dart';
import 'package:cataract_detector1/src/consts/consts.dart';
import 'package:cataract_detector1/profile_screen/profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> doctors = [];
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  var controller = Get.put(HomeController());
  final HomeController1 controller1 = Get.put(HomeController1());

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

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchDoctorData();
  }

  @override
  Widget build(BuildContext context) {
    String currentMonthYear = DateFormat.yMMMM().format(DateTime.now());
    int currentDay = DateTime.now().day;
    List<DateTime> weekDays = List.generate(7, (index) => DateTime.now().add(Duration(days: index - DateTime.now().weekday + 1)));

    return Scaffold(
      backgroundColor: Colors.white,
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              'Welcome back,',
                              style: TextStyle(color: Colors.black, fontSize: getScaledWidth(15.0, context)),
                            ),
                            SizedBox(height: getScaledHeight(5.0, context)),
                            Text(
                              userData!['name'],
                              style: TextStyle(color: Colors.black, fontSize: getScaledWidth(25.0, context), fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfileScreen()),
                            );
                          },
                          child: CircleAvatar(
                            backgroundImage: userData!['UserProfilePicture'] != null
                                ? NetworkImage(userData!['UserProfilePicture'])
                                : AssetImage('images/placeholder.png') as ImageProvider, // Placeholder image
                            radius: 25,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: getScaledHeight(16.0, context)),
                    ElevatedButton(
  onPressed: () {
    // controller1.currentNavIndex.value = 1;
    // _pageController.jumpToPage(1);
  },
  child: Text(
    'Click To GET YOUR EYES\n CHECKED',
    style: TextStyle(color: Colors.black, fontSize: getScaledWidth(18.0, context), fontWeight: FontWeight.bold),
  ),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
),
                    SizedBox(height: getScaledHeight(20.0, context)),
                    Row(
                      children: [
                        Text(
                          'Available Doctors',
                          style: TextStyle(color: Colors.black, fontSize: getScaledWidth(18.0, context), fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ViewAllDoctorsScreen(doctors: doctors)),
                            );
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "View All",
                              style: TextStyle(color: AppColors.primeryColor, fontSize: AppFontSize.size16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: getScaledHeight(8.0, context)),
                    Container(
                      height: getScaledHeight(200.0, context),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: doctors.length,
                        itemBuilder: (context, index) {
                          var doctor = doctors[index];
                          return Container(
                            width: getScaledWidth(125.0, context),
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DoctorScreen(doctor: doctor),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: Image.network(
                                      doctor['docProfilePic'],
                                      height: getScaledHeight(110.0, context),
                                      width: getScaledWidth(double.infinity, context),
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          'images/placeholder.png',
                                          height: getScaledHeight(110.0, context),
                                          width: getScaledWidth(double.infinity, context),
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Dr. " + doctor['docName'],
                                        style: TextStyle(
                                          fontSize: getScaledWidth(20, context),
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                      ),
                                      Text(
                                        doctor['docType'],
                                        style: TextStyle(
                                          fontSize: getScaledWidth(10.0, context),
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: getScaledHeight(1.0, context)),
                    Text(
                      currentMonthYear,
                      style: TextStyle(color: Colors.black, fontSize: getScaledWidth(18.0, context), fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: getScaledHeight(8.0, context)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: weekDays.map((date) {
                        bool isSelected = date.day == currentDay;
                        return _calendarDay(
                          DateFormat('EEE').format(date),
                          date.day.toString(),
                          isSelected: isSelected,
                        );
                      }).toList(),
                    ),
                    SizedBox(height: getScaledHeight(16.0, context)),
                    Text(
                      'Confirmed Upcoming Appointments',
                      style: TextStyle(color: Colors.black, fontSize: getScaledWidth(18.0, context), fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: getScaledHeight(8.0, context)),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .collection('Appointments')
                            .where('status', isEqualTo: 'Confirmed')
                            // .where('status', isEqualTo: 'Upcoming')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(child: Text('No confirmed appointments.'));
                          }
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var appointment = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                              return Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Colors.blue, // Card background color
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: appointment['docProfilePic'] != null
                                        ? NetworkImage(appointment['docProfilePic'])
                                        : AssetImage('images/placeholder.png') as ImageProvider, // Placeholder image
                                  ),
                                  title: Text(
                                    appointment['doctorName'] +"("+appointment['doctorType']+")" ?? 'No Doctor Name',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, // Text color
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date: ${DateFormat('d/MMMM/y').format((appointment['date'] as Timestamp).toDate())}',
                                        style: TextStyle(
                                          color: Colors.white, // Text color
                                        ),
                                      ),
                                      Text(
                                        'Time: ${appointment['time'] ?? 'No Time'}',
                                        style: TextStyle(
                                          color: Colors.white, // Text color
                                        ),
                                      ),
                                    ],
                                  ),
                                  // trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white), // Icon color
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _calendarDay(String dayName, String dayNumber, {bool isSelected = false}) {
    return Container(
      decoration: isSelected
          ? BoxDecoration(color: AppColors.primeryColor, borderRadius: BorderRadius.circular(10))
          : null,
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            dayName,
            style: TextStyle(
              fontSize: AppFontSize.size14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          Text(
            dayNumber,
            style: TextStyle(
              fontSize: AppFontSize.size14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
