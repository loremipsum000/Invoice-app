import 'package:flutter/material.dart';
import 'package:generate_invoice_app/const/app_color.dart';
import 'package:get/get.dart';

Widget commonButton({
  final Function()? onPressed,
  final double? height,
  final double? width,
  final double? elevation,
  final Color? color,
  final double? radius,
  final Widget? child,
  final Color? borderColor,
}) {
  final h = Get.height;
  final w = Get.width;
  return MaterialButton(
    elevation: elevation ?? 5,
    onPressed: onPressed,
    height: height ?? h * 0.07,
    minWidth: width ?? double.infinity,
    color: Theme.of(Get.context!).brightness == Brightness.dark ? darkModePrimaryColor : lightModePrimaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius ?? 10),
      side: BorderSide(
        color: borderColor ?? Colors.transparent,
      ),
    ),
    child: child,
  );
}
