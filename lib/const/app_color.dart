import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/theme_data.dart';

const Color darkModePrimaryColor = Color(0xff4B39EF);
const Color lightModePrimaryColor = Color(0xff459EBC);

const Color darkModeScaffoldColor = Color(0xff14181B);
//const Color lightModeScaffoldColor = Color(0xffD9D9D9);
const Color lightModeScaffoldColor = Color(0xffF5F5F5);

const Color darkModeBottomBarColor = Color(0xff1E1E1E);
Color whiteColor = Colors.white;
const Color lightModeGreyColor = Color(0xffF0EFEB);

const Color blackColor = Colors.black;

const Color greyColor = Colors.grey;
Color lightGreyColor = Colors.grey.withOpacity(0.6);

Color greyTextColor = Theme.of(Get.context!).brightness == Brightness.dark
    ? Colors.white60
    : lightModeGreyTextColor;
//const Color lightModeGreyTextColor = Color(0xff808487);
const Color lightModeGreyTextColor = Color(0xff898E92);
const Color darkWhiteColor = Colors.white70;

const Color darkModeRedColor = Color(0xffBE515A);
const Color lightModeRedColor = Color(0xffE44D6B);

const Color darkModeGreenColor = Color(0xff397E74);
const Color lightModeGreenColor = Color(0xff63C4A6);

const Color greyPopUpColor = Color(0xff424242);
