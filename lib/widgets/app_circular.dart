import 'package:flutter/material.dart';
import 'package:generate_invoice_app/const/app_color.dart';
import 'package:get/get.dart';

Widget commonCircular({
  double? height,
  double? width,
}) {
  final h = Get.height;
  final w = Get.width;
  return SizedBox(height: h * 0.03, width: w * 0.055, child: CircularProgressIndicator(color: whiteColor));
}
