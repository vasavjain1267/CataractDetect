
import 'package:cataract_detector1/media_query.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class UpcomingAppointment extends StatelessWidget {
  const UpcomingAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final appointmentsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('Appointments');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getScaledHeight(15, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Upcoming/Confirmed Appointments",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: getScaledHeight(15, context)),
          StreamBuilder<QuerySnapshot>(
            stream: appointmentsRef
                .where('status', whereIn: ['Upcoming', 'Confirmed'])
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No upcoming appointments."));
              }
              final appointments = snapshot.data!.docs;
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  final doctorName = appointment['doctorName'];
                  final doctorType = appointment['doctorType'];
                  final appointmentDate = (appointment['date'] as Timestamp).toDate();
                  final appointmentTime = appointment['time'];
                  final status = appointment['status'];
                  final doctorImage = appointment['docProfilePic'];

                  // Combine the appointment date and time
                  final appointmentDateTime = DateFormat('d/MMMM/y hh:mm a')
                      .parse('${DateFormat('d/MMMM/y').format(appointmentDate)} $appointmentTime');

                  // Check if the appointment date and time have passed
                  final now = DateTime.now();
                  if (now.isAfter(appointmentDateTime) && status != 'Scheduled') {
                    // Update the status to "Scheduled"
                    appointmentsRef.doc(appointment.id).update({'status': 'Scheduled'});
                  }

                  return AppointmentTile(
                    appointmentId: appointment.id,
                    doctorName: doctorName,
                    doctorType: doctorType,
                    appointmentDate: DateFormat('d/MMMM/y').format(appointmentDate),
                    appointmentTime: appointmentTime,
                    status: status,
                    doctorImage: doctorImage,
                    appointmentsRef: appointmentsRef,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class AppointmentTile extends StatelessWidget {
  final String appointmentId;
  final String doctorName;
  final String doctorType;
  final String appointmentDate;
  final String appointmentTime;
  final String status;
  final String doctorImage;
  final CollectionReference appointmentsRef;

  const AppointmentTile({
    required this.appointmentId,
    required this.doctorName,
    required this.doctorType,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    required this.doctorImage,
    required this.appointmentsRef,
  });

  Future<void> _cancelAppointment(BuildContext context) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Cancel Appointment"),
        content: Text("Are you sure you want to cancel this appointment?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Yes"),
          ),
        ],
      ),
    );

    if (confirm) {
      await appointmentsRef.doc(appointmentId).update({'status': 'Cancelled'});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: getScaledHeight(15, context)),
      padding: EdgeInsets.symmetric(vertical: getScaledHeight(5, context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(getScaledHeight(10, context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 2,
            blurRadius: 1,
          ),
        ],
      ),
      child: SizedBox(
        width: getScaledWidth(430, context),
        child: Column(
          children: [
            ListTile(
              title: Text(
                doctorName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(doctorType),
              trailing: CircleAvatar(
                // ignore: unnecessary_null_comparison
                backgroundImage: doctorImage != null
                    ? NetworkImage(doctorImage)
                    : AssetImage('images/placeholder.png') as ImageProvider,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getScaledHeight(15, context)),
              child: Divider(
                thickness: getScaledWidth(1, context),
                height: getScaledHeight(20, context),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month, color: Colors.black54),
                    SizedBox(width: 5),
                    Text(
                      appointmentDate,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time_filled, color: Colors.black54),
                    SizedBox(width: 5),
                    Text(
                      appointmentTime,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: status == "Upcoming"
                            ? Colors.yellow
                            : (status == "Confirmed"
                                ? Colors.green
                                : (status == "Scheduled"
                                    ? Colors.green
                                    : (status == "Cancelled"
                                        ? Colors.red
                                        : Colors.red))),
                        shape: status == "Scheduled"
                            ? BoxShape.rectangle
                            : BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      status,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: getScaledHeight(15, context)),
            if (status == "Upcoming" || status == "Confirmed")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () => _cancelAppointment(context),
                    child: Container(
                      width: getScaledWidth(150, context),
                      padding: EdgeInsets.symmetric(vertical: getScaledHeight(12, context)),
                      decoration: BoxDecoration(
                        color: Color(0XFFF4F6FA),
                        borderRadius: BorderRadius.circular(getScaledWidth(10, context)),
                      ),
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: getScaledWidth(16, context),
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
