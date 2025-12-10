import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSizes {
  AppSizes._();

  // Common Padding
  static EdgeInsets padding = EdgeInsets.symmetric(
    horizontal: 16.w,
    vertical: 16.h,
  );
  static double paddingHorizontal = 16.w;
  static double paddingVertical = 16.h;

  // Common Margins
  static double marginSmall = 8.w;
  static double marginMedium = 16.w;
  static double marginLarge = 24.w;

  // Font Sizes
  static double fontSizeSmall = 12.sp;
  static double fontSizeMedium = 14.sp;
  static double fontSizeLarge = 16.sp;
  static double fontSizeTitle = 20.sp;

  // Icon Sizes
  static double iconSizeSmall = 16.w;
  static double iconSizeMedium = 24.w;
  static double iconSizeLarge = 32.w;

  // Border Radius
  static double radiusSmall = 8.r;
  static double radiusMedium = 12.r;
  static double radiusLarge = 16.r;

  // Button Heights
  static double buttonHeight = 48.h;
  static double buttonHeightSmall = 40.h;
  static double buttonHeightLarge = 56.h;
}
