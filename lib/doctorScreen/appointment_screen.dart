// import 'package:cataract_detector1/doctorScreen/doctor_fetch_files.dart';
import 'package:cataract_detector1/Home/Home.dart';
import 'package:cataract_detector1/doctorScreen/all_doctor_screen.dart';
import 'package:cataract_detector1/doctorScreen/appointment_firebase.dart';
// import 'package:cataract_detector1/doctorScreen/schedule_screen.dart';
import 'package:cataract_detector1/media_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentScreen extends StatefulWidget {

  final Map<String, dynamic> doctor;
  final Function(DateTime, String) onBookAppointment;
  AppointmentScreen({Key? key, required this.doctor, required this.onBookAppointment}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  List<Map<String, dynamic>> doctors = [];
  DateTime? _selectedDate;
  String? _selectedTime;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _firstDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _lastDay = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  final user = FirebaseAuth.instance.currentUser;
  // Future<void> _selectDate(BuildContext context) async {
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
    // fetchUserData();
    fetchDoctorData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: 
       SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getScaledHeight(35.0,context),),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Container(
  decoration: BoxDecoration(
    shape: BoxShape.circle, 
    border: Border.all(  
      color: Colors.white,
      width: getScaledWidth(2.0, context)          
    ),
    image: DecorationImage(
      image: NetworkImage(widget.doctor['docProfilePic']),
      fit: BoxFit.cover,
    ),
  ),

  height: getScaledHeight(200.0, context),
  width: getScaledHeight(200.0, context), 
  clipBehavior: Clip.antiAlias,
  child: widget.doctor['docProfilePic'] != null
      ? null 
      : Center( 
          child: Image.asset(
            'images/placeholder.png',
            height: getScaledHeight(80.0, context), 
            width: getScaledHeight(80.0, context), 
          ),
        ),
),
                  SizedBox(height: getScaledHeight(15.0,context),),
                  Text(
                    "Dr."+widget.doctor['docName'],
                    style: TextStyle(fontSize: getScaledWidth(23, context),fontWeight: FontWeight.w500, color: Colors.black54),
                  ),
                  SizedBox(height: getScaledHeight(5.0,context),),
                  Text(
                    widget.doctor['docType'],
                    style: TextStyle(fontSize: getScaledWidth(18, context), fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
                  SizedBox(height: getScaledHeight(10.0,context),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.call,
                          color: Colors.blue.shade700,
                          size: 25,
                        ),
                      ),
                      SizedBox(width: getScaledWidth(20.0, context),),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.chat_bubble,
                          color: Colors.blue.shade700,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: getScaledHeight(20.0,context),),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                  //   style: TextStyle(fontSize: getScaledWidth(15, context), fontWeight: FontWeight.w500, color: Colors.black.withOpacity(0.6)),
                  //   textAlign: TextAlign.justify,
                  // ),
                  Text(
                    "About Doctor",
                    style: TextStyle(
                      fontSize: getScaledWidth(22, context),
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(1),
                    ),
                  ),
                  SizedBox(height: getScaledHeight(5.0,context),),
                  Text(
                    widget.doctor['docAbout'],
                      style: TextStyle(fontSize: getScaledWidth(15, context), fontWeight: FontWeight.w500, color: Colors.black.withOpacity(0.6)),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: getScaledHeight(30.0,context),),
                  Text(
                    "Select Date",
                    style: TextStyle(fontSize: getScaledWidth(18, context), fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: getScaledHeight(10.0,context),),
                  TableCalendar(
                    firstDay: _firstDay,
                    lastDay: _lastDay,
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,titleCentered: true,
                    ),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDate = selectedDay;
                      });
                    },
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDate, day);
                      
                    },
                    
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                  ),
                  SizedBox(height: getScaledHeight(30.0,context),),
                  Text(
                    "Select Time",
                    style: TextStyle(fontSize: getScaledWidth(18, context), fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  // SizedBox(height: 10),
                                 SizedBox(height: getScaledHeight(10.0,context),),
                  Container(
                    height: getScaledHeight(50.0,context),
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        final time = index + 7;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedTime = '$time:00 AM';
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                            decoration: BoxDecoration(
                              color: _selectedTime == '$time:00 AM' ? Colors.blue : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 2,
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '$time:00 AM',
                                  style: TextStyle(fontSize: getScaledWidth(15, context), color: _selectedTime == '$time:00 AM' ? Colors.white : Colors.black.withOpacity(0.6)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: getScaledHeight(50.0,context),
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        final time = index + 2;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedTime = '$time:00 PM';
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                            decoration: BoxDecoration(
                              color: _selectedTime == '$time:00 PM' ? Colors.blue : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 2,
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '$time:00 PM',
                                  style: TextStyle(fontSize: getScaledWidth(15, context), color: _selectedTime == '$time:00 PM' ? Colors.white : Colors.black.withOpacity(0.6)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: getScaledHeight(30.0,context),),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        _showConfirmationDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text(
                        "Book Now",
                        style: TextStyle(color: Colors.white, fontSize: getScaledWidth(18, context), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      )
     
    );
  }

Future<void> _showConfirmationDialog(BuildContext context) async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select date and time."),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Show dialog to confirm appointment
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Appointment"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Date: ${DateFormat.yMMMMd().format(_selectedDate!)}"),
            Text("Time: $_selectedTime"),
            Text("Doctor: " +"Dr."+ widget.doctor['docName'])
          ],
        ),
        actions: [ 
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _showSuccessDialog(context);

            },
            child: Text("Confirm"),
          ),
          
        ],
      ),
    );
  }

    Future<void> _showSuccessDialog(BuildContext context) async {
    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Appointment Booked"),
        content: Text("Your appointment has been successfully booked."),
        actions: [
          TextButton(
            onPressed: () async {
               final appointment = {
                'doctorType' : widget.doctor['docType'],
                'doctorName': "Dr." + widget.doctor['docName'],
                'docProfilePic': widget.doctor['docProfilePic'],
                'date': _selectedDate,
                'time': _selectedTime,
                'status': 'Upcoming',
              };
              await FirestoreService().bookAppointment(user!.uid, appointment); 
              Navigator.of(context).pop(); // Close the dialog
               Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewAllDoctorsScreen(doctors: doctors,)
                                                    ));
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}


