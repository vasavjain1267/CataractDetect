import 'package:cataract_detector1/doctorScreen/widgets/upcoming_appointment.dart';
import 'package:cataract_detector1/media_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CancelledAppointments extends StatelessWidget {
  const CancelledAppointments({super.key});

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
            "Cancelled Appointments",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: getScaledHeight(15, context)),
          StreamBuilder<QuerySnapshot>(
            stream: appointmentsRef.where('status', isEqualTo: 'Cancelled').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No cancelled appointments."));
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
