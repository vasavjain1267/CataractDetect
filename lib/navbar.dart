import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:cataract_detector1/Home/controller/home_controller1.dart';

class CustomNavBar extends StatelessWidget {
  final PageController pageController;
  final HomeController1 controller1;

  CustomNavBar({required this.pageController, required this.controller1});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
            backgroundColor: Colors.white,
            color: Colors.blue,
            activeColor: Colors.blue,
            tabBackgroundColor: Colors.black,
            gap: 8,
            padding: EdgeInsets.all(16),
            selectedIndex: controller1.currentNavIndex.value,
            onTabChange: (index) {
              controller1.currentNavIndex.value = index;
              pageController.jumpToPage(index);
            },
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.camera_alt_outlined,
                text: 'SCAN',
              ),
              GButton(
                icon: Icons.alarm,
                text: 'Appointments',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
