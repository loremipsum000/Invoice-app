// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../const/app_color.dart';
// import '../utils/common_textstyle.dart';
//
// List popUpList = ["DownLoad", "Mark as Paid", "Share", "Delete"];
//
// Widget commonPopUp({
//   final double? h,
//   final double? w,
//   final int? length,
//   final Widget? child,
//   final void Function()? onTap,
// }) {
//   final h = Get.height;
//   final w = Get.width;
//   return PopupMenuButton(
//     constraints: BoxConstraints(
//       maxHeight: h * 0.45,
//     ),
//     color: greyPopUpColor,
//     offset: const Offset(10, 0),
//     position: PopupMenuPosition.over,
//     child: Icon(Icons.more_vert, color: whiteColor),
//     itemBuilder: (context) {
//       return List.generate(popUpList.length, (index) {
//         return PopupMenuItem(
//           child: Column(
//             children: [
//               InkResponse(
//                 onTap: onTap,
//                 child: child,
//                 // Text("${popUpList[index]}",
//                 //     style: CommonTextStyle.kWhite15OpenSansRegular),
//               ),
//               const Divider(
//                 endIndent: 0,
//                 indent: 0,
//                 color: Colors.grey,
//               ),
//             ],
//           ),
//         );
//       });
//     },
//   );
// }
