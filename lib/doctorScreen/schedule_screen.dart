import 'package:cataract_detector1/doctorScreen/widgets/cancelled_appointments.dart';
import 'package:cataract_detector1/doctorScreen/widgets/scheduled_appointments.dart';
import 'package:cataract_detector1/doctorScreen/widgets/upcoming_appointment.dart';
import 'package:cataract_detector1/media_query.dart';
import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _buttonIndex = 0;
  final _scheduleWidgets = [
    UpcomingAppointment(),
    ScheduledAppointments(),
    CancelledAppointments(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Appointments",
          style: TextStyle(
            height: 5, fontSize: getScaledWidth(25.0, context), fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // child: SingleChildScrollView(
        body:  Padding(
          padding: EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Appointments",
                  style: TextStyle(
                    fontSize: getScaledWidth(25, context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),  
              SizedBox(height: getScaledHeight(20, context)),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.symmetric(horizontal: getScaledWidth(20, context)),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(getScaledWidth(10, context)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _buttonIndex = 0;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: getScaledHeight(12, context),
                          horizontal: getScaledWidth(22, context),
                        ),
                        decoration: BoxDecoration(
                          color: _buttonIndex == 0 ? Colors.blue : Colors.transparent,
                          borderRadius: BorderRadius.circular(getScaledWidth(10, context)),
                        ),
                        child: Text(
                          "Upcoming",
                          style: TextStyle(
                            fontSize: getScaledWidth(16, context),
                            fontWeight: FontWeight.w500,
                            color: _buttonIndex == 0 ? Colors.white : Colors.black38,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _buttonIndex = 1;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: getScaledHeight(12, context),
                          horizontal: getScaledWidth(22, context),
                        ),
                        decoration: BoxDecoration(
                          color: _buttonIndex == 1 ? Colors.blue : Colors.transparent,
                          borderRadius: BorderRadius.circular(getScaledWidth(10, context)),
                        ),
                        child: Text(
                          "Scheduled",
                          style: TextStyle(
                            fontSize: getScaledWidth(16, context),
                            fontWeight: FontWeight.w500,
                            color: _buttonIndex == 1 ? Colors.white : Colors.black38,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _buttonIndex = 2;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: getScaledHeight(12, context),
                          horizontal: getScaledWidth(22, context),
                        ),
                        decoration: BoxDecoration(
                          color: _buttonIndex == 2 ? Colors.blue : Colors.transparent,
                          borderRadius: BorderRadius.circular(getScaledWidth(10, context)),
                        ),
                        child: Text(
                          "Cancelled",
                          style: TextStyle(
                            fontSize: getScaledWidth(16, context),
                            fontWeight: FontWeight.w500,
                            color: _buttonIndex == 2 ? Colors.white : Colors.black38,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              _scheduleWidgets[_buttonIndex],
            ],
          ),
        ),
      // ),
    );
  }
}
