import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generate_invoice_app/const/app_color.dart';
import 'package:generate_invoice_app/utils/common_textstyle.dart';
import 'package:get/get.dart';

Widget commonTextFeild({
  final String? labelText,
  final String? hintText,
  final TextStyle? labelStyle,
  final TextStyle? hintStyle,
  final int? maxLines,
  final Function(String)? onChanged,
  final void Function()? onTap,
  final TextStyle? textStyle,
  final double? horizontalPadding,
  final double? verticalPadding,
  final TextEditingController? controller,
  final Widget? prefix,
  final Widget? suffix,
  final Color? fillColor,
  final Color? borderColor,
  final dynamic validator,
  final int? maxLength,
  final bool obscure = false,
  final List<TextInputFormatter>? input,
  final double? radius,
  final bool enabled = true,
  final TextInputType? keyboardType,
}) {
  final h = Get.height;
  return TextFormField(
    keyboardType: keyboardType,
    maxLength: maxLength,
    validator: validator,
    autofocus: false,
    inputFormatters: input,
    obscureText: obscure,
    textAlign: TextAlign.start,
    style: textStyle ??
        CommonTextStyle.kWhite15OpenSansSemiBold
            .copyWith(color: Theme.of(Get.context!).brightness == Brightness.dark ? whiteColor : blackColor),
    maxLines: maxLines ?? 1,
    enabled: enabled,
    onChanged: onChanged,
    onTap: onTap,
    controller: controller,
    cursorColor: Theme.of(Get.context!).brightness == Brightness.dark ? darkModePrimaryColor : lightModePrimaryColor,
    decoration: InputDecoration(
      filled: true,
      fillColor: fillColor ?? Colors.transparent,
      prefixIcon: prefix,
      suffixIcon: suffix,
      contentPadding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 10, vertical: verticalPadding ?? h * 0.02),
      labelText: labelText,
      hintText: hintText,
      hintStyle: hintStyle ??
          CommonTextStyle.kGrey15OpenSansRegular
              .copyWith(color: Theme.of(Get.context!).brightness == Brightness.dark ? greyTextColor : lightModeGreyTextColor),
      labelStyle: labelStyle ??
          CommonTextStyle.kGrey15OpenSansRegular
              .copyWith(color: Theme.of(Get.context!).brightness == Brightness.dark ? greyTextColor : lightModeGreyTextColor),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor ?? lightGreyColor),
        borderRadius: BorderRadius.circular(radius ?? 10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(Get.context!).brightness == Brightness.dark ? darkModePrimaryColor : lightModePrimaryColor),
        borderRadius: BorderRadius.circular(radius ?? 10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(Get.context!).brightness == Brightness.dark ? darkModePrimaryColor : lightModePrimaryColor),
        borderRadius: BorderRadius.circular(radius ?? 10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor ?? darkModeRedColor),
        borderRadius: BorderRadius.circular(radius ?? 10),
      ),
    ),
  );
}
