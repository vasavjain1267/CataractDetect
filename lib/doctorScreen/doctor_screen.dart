import 'package:cataract_detector1/doctorScreen/appointment_screen.dart';
import 'package:cataract_detector1/media_query.dart';
import 'package:cataract_detector1/src/consts/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DoctorScreen extends StatelessWidget {
  final Map<String, dynamic> doctor;

  DoctorScreen({required this.doctor});
Future<void> _bookAppointment(DateTime selectedDate, String selectedTime) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      await firestore.collection('doctors').doc(doctor['docId']).collection('appointments').add({
        'userName': 'User Name', // Replace with actual user name
        'appointmentDate': formattedDate,
        'appointmentTime': selectedTime,
      });

      // Show success message
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Appointment booked successfully')),
      // );
    } catch (e) {
      print('Error booking appointment: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 130, 196, 250),
      body: SafeArea(child: 
       SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getScaledHeight(10.0,context),),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10,),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                       
Container(
  decoration: BoxDecoration(
    shape: BoxShape.circle, 
    border: Border.all(  
      color: Colors.white,
      width: 2.0,          
    ),
    image: DecorationImage(
      image: NetworkImage(doctor['docProfilePic']),
      fit: BoxFit.cover,
    ),
  ),

  height: getScaledHeight(100.0, context),
  width: getScaledHeight(100.0, context), 
  clipBehavior: Clip.antiAlias,
  child: doctor['docProfilePic'] != null
      ? null 
      : Center( 
          child: Image.asset(
            'images/placeholder.png',
            height: getScaledHeight(80.0, context), 
            width: getScaledHeight(80.0, context), 
          ),
        ),
),

              //           CircleAvatar(
              //       radius: 50,
              //       // backgroundImage: doctor['docProfilePic'] != null 
              //       //   ? NetworkImage(doctor['docProfilePic'])
              //       //   : AssetImage('images/placeholder.png') as ImageProvider,
              //       child: Image.network(
              //   doctor['docProfilePic'],
              //   // height: getScaledHeight(110.0,context),
              //   // width: double.infinity,
              //   // fit: BoxFit.cover,
              //   errorBuilder: (context, error, stackTrace) {
              //     return Image.asset(
              //       'images/placeholder.png', // Placeholder image asset path
              //       // height: getScaledHeight(110.0,context),
              //       // width: double.infinity,
              //       // fit: BoxFit.cover,
              //     );
              //   },
              // ),
              //     ),
                        SizedBox(height: getScaledHeight(5.0,context),),
                        Text(
                          "Dr."+ doctor['docName'] ,
                          style: TextStyle(
                            fontSize: getScaledWidth(23, context), 
                            fontWeight: FontWeight.w500, 
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: getScaledHeight(5.0,context),),
                        Text(
                          doctor['docType'],
                          style: TextStyle(
                            fontSize: getScaledWidth(20, context),
                            fontWeight: FontWeight.w500, 
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape:  BoxShape.circle,
                              ),
                              child: Icon(Icons.call,
                                color: Colors.blue.shade700,
                                size: 25,
                              ),
                            ),
                            SizedBox(width: getScaledWidth(20.0, context)),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape:  BoxShape.circle,
                              ),
                              child: Icon(
                                CupertinoIcons.chat_bubble_text_fill,
                                color: Colors.blue.shade700,
                                size: 25,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: getScaledHeight(15.0,context),),
            Container(
              height: MediaQuery.of(context).size.height / 1.5,
              width: getScaledWidth(double.infinity, context),
              padding: EdgeInsets.only(
                top: 20, left: 15,
              ),
              decoration: BoxDecoration(
                color:  Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), 
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "About Doctor",
                    style: TextStyle(
                      fontSize: getScaledWidth(22, context),
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: getScaledHeight(5.0,context),),
                  Text(
                    doctor['docAbout'],
                    style: TextStyle(
                      fontSize: getScaledWidth(16, context),
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: getScaledHeight(10.0,context),),
                  Row(
                    children: [
                      Text(
                        "Education :-", 
                        style: TextStyle(
                          fontSize: getScaledWidth(20, context),
                          fontWeight: FontWeight.w500, 
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(width: getScaledWidth(10.0, context)),
                      Text(
                        doctor['docEducation'],
                        style: TextStyle(
                          fontSize: getScaledWidth(16, context),
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getScaledHeight(10.0,context),),
                  Row(
                    children: [
                      Text(
                        "Reviews", 
                        style: TextStyle(
                          fontSize: getScaledWidth(20, context),
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(width: getScaledWidth(10.0, context)),
                      Icon(Icons.star, color: Colors.amber,),
                      Text("4.9", style: TextStyle(fontWeight: FontWeight.w500, fontSize: getScaledWidth(16, context),),),
                      SizedBox(width: getScaledWidth(5.0, context)),
                      Text("(124)", style: TextStyle(fontWeight: FontWeight.w500, color:Colors.blue.shade700, fontSize: getScaledWidth(16, context),),),
                    ],
                  ),
                  SizedBox(height: getScaledHeight(10.0,context),),
                  Text(
                    "Address", 
                    style: TextStyle(
                      fontSize: getScaledWidth(20, context),
                      fontWeight: FontWeight.w500, 
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                  ListTile(
                    leading:  Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:Color(0xFFF0EEFA),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.location_on, color:Colors.blue.shade700, size:20,),
                    ),
                    title: Text(
                      doctor['docAddressTitle'] ,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                    subtitle: Text(doctor['docAddressSubtitle']),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
     
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(15),
        height: getScaledHeight(140.0,context),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12, blurRadius: 4, spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Consultation Fee", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),),
                Text("\₹"+doctor['docConsultFee'], style: TextStyle(fontSize: getScaledWidth(20, context), color: Colors.blue.withOpacity(0.8), fontWeight: FontWeight.bold,),)
              ],
            ),
            SizedBox(height: getScaledHeight(10.0,context),),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentScreen(doctor: doctor,onBookAppointment: _bookAppointment),
                  ),
                );
              },
              child:  Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color:  Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Book Appointment", 
                    style: TextStyle(color: Colors.white, fontSize: getScaledWidth(18, context),fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
