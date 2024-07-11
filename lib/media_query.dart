// media_query_helper.dart

import 'package:flutter/material.dart';

class MediaQueryHelper {
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double responsiveHeight(BuildContext context, double factor) {
    return screenHeight(context) * factor;
  }

  static double responsiveWidth(BuildContext context, double factor) {
    return screenWidth(context) * factor;
  }
}
double getScaledWidth(double currentWidth,BuildContext context) {
  double scaleFactor = currentWidth /430.0;
  return MediaQuery.of(context).size.width * scaleFactor;
}
double getScaledHeight(double currentWidth,BuildContext context) {
  double scaleFactor1 = currentWidth /932.0;
  return MediaQuery.of(context).size.height * scaleFactor1;
}