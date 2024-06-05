// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../const/app_color.dart';
//
// Widget appDropDown({
//   final ValueChanged? onChanged,
//   final List<DropdownMenuItem<dynamic>>? items,
//   final dynamic value,
//   final Widget? hint,
//   final Color? borderColor,
//   final double? height,
//   void Function()? onTap,
//   TextStyle? style,
//   final double? radius,
//   final Icon? icon,
// }) {
//   final h = Get.height;
//   final w = Get.width;
//   return Container(
//     height: height ?? h * 0.08,
//     width: double.infinity,
//     decoration: BoxDecoration(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(radius ?? 10),
//         border: Border.all(color: borderColor ?? lightGreyColor)),
//     padding: EdgeInsets.only(left: w * 0.02, right: w * 0.02),
//     child: DropdownButton(
//       dropdownColor: darkModeScaffoldColor,
//       padding: EdgeInsets.symmetric(vertical: h * 0.022),
//       isExpanded: true,
//       style: style,
//       value: value,
//       hint: hint,
//       items: items,
//       onChanged: onChanged,
//       underline: const SizedBox(),
//       icon: InkResponse(
//         child: icon ??
//             Icon(
//               Icons.arrow_drop_down_outlined,
//               color: whiteColor,
//             ),
//       ),
//     ),
//   );
// }
