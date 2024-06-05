import 'package:flutter/material.dart';
import 'package:generate_invoice_app/const/app_color.dart';
import 'package:generate_invoice_app/utils/common_textstyle.dart';
import 'package:get/get.dart';

SnackbarController appSnackBar({String? message, String? title, Color? color, TextStyle? style}) {
  return Get.showSnackbar(
    GetSnackBar(
      title: title,
      backgroundColor: color ?? whiteColor,
      messageText: Text(message ?? "", style: style ?? CommonTextStyle.kBlack15OpenSansRegular),
      duration: const Duration(seconds: 2),
    ),
  );
}
