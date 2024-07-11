import 'package:cataract_detector1/doctorScreen/doctor_screen.dart';
import 'package:cataract_detector1/media_query.dart';
import 'package:flutter/material.dart';

class ViewAllDoctorsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> doctors;

  ViewAllDoctorsScreen({required this.doctors});

  @override
  State<ViewAllDoctorsScreen> createState() => _ViewAllDoctorsScreenState();
}

class _ViewAllDoctorsScreenState extends State<ViewAllDoctorsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('All Doctors'),
        backgroundColor: Color.fromARGB(255, 130, 196, 250),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: widget.doctors.length,
        itemBuilder: (context, index) {
          var doctor = widget.doctors[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorScreen(doctor: doctor),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    // radius: 30,
                    // backgroundImage: doctor['docProfilePic'] != null 
                    //   ? NetworkImage(doctor['docProfilePic'])
                    //   : AssetImage('images/placeholder.png') as ImageProvider,
                    child: Image.network(
                doctor['docProfilePic'],
                height: getScaledHeight(110.0,context),
                width: getScaledWidth(double.infinity, context),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'images/placeholder.png', // Placeholder image asset path
                    height: getScaledHeight(110.0,context),
                    width: getScaledWidth(double.infinity, context),
                    fit: BoxFit.cover,
                  );
                },
              ),
                  ),
                  SizedBox(width: getScaledWidth(10.0, context)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dr. "+doctor['docName'],
                          style: TextStyle(
                            fontSize: getScaledWidth(18, context),
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: getScaledHeight(5.0,context),),
                        Text(
                          doctor['docType'],
                          style: TextStyle(
                            fontSize: getScaledWidth(14, context),
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.black45, size: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}