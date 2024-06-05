import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:generate_invoice_app/const/app_color.dart';
import 'package:generate_invoice_app/const/app_image.dart';
import 'package:generate_invoice_app/ui/auth_screen/auth_screen.dart';
import 'package:generate_invoice_app/utils/common_textstyle.dart';
import 'package:generate_invoice_app/utils/preference_manager.dart';
import 'package:generate_invoice_app/widgets/common_appbar.dart';
import 'package:get/get.dart';
import 'controller/profile_controller.dart';
import 'edit_payment_details/edit_payment_detail_screen.dart';
import 'edit_profile/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController profileController = Get.put(ProfileController());

  //final FlutterLocalization localization = FlutterLocalization.instance;
  // late AppLanguageProvider appLanguage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      //  backgroundColor: darkModeScaffoldColor,
      appBar: CommonAppBar(
        title: "Profile".tr,
        //AppString.profileText,
      ),
      body: GetBuilder<ProfileController>(builder: (controller) {
        return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("User").where("UserId", isEqualTo: PreferenceManager.getUserId()).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var userData = snapshot.data?.docs;
                // log('userData?[0]["ProfileImage"]==========>>>>>${userData?[0]["ProfileImage"]}');
                String? imageUrl = userData?[0]["ProfileImage"] ?? "";
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                  child: Column(
                    children: [
                      Center(
                        child: InkResponse(
                          onTap: () {
                            pickPhotoBottomSheet(
                              context: context,
                              w: w,
                              galleryOnTap: () {
                                Get.back();
                                controller.pickGalleryImage();
                                setState(() {});
                              },
                              cameraOnTap: () {
                                Get.back();
                                controller.pickCameraImage();
                                setState(() {});
                              },
                            );
                            setState(() {});
                            if (profileController.pickedImage != null) {
                              profileController.editProfileImage();
                            }
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: h * 0.22,
                                width: w * 0.22,
                                decoration: BoxDecoration(
                                  color: Theme.of(Get.context!).brightness == Brightness.dark ? darkWhiteColor : lightGreyColor,
                                  shape: BoxShape.circle,
                                  image: imageUrl!.isNotEmpty
                                      ? DecorationImage(image: NetworkImage("${userData?[0]["ProfileImage"]}"), fit: BoxFit.cover)
                                      : controller.pickedImage != null
                                          ? DecorationImage(
                                              image: FileImage(File("${controller.pickedImage?.path}")),
                                              fit: BoxFit.cover,
                                            )
                                          : const DecorationImage(image: AssetImage(AppImage.personImage), scale: 1.5),
                                ),
                              ),
                              Positioned(
                                bottom: h * 0.05,
                                right: w * -0.01,
                                child: CircleAvatar(
                                  backgroundColor: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                  radius: 15,
                                  child: Icon(
                                    Icons.edit,
                                    color: Theme.of(context).brightness == Brightness.dark ? blackColor : whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                          //"shreyachovatiya171@gmail.com",
                          "${PreferenceManager.getEmail()}",
                          //"${userData?[0]["Email"]}",
                          style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                            color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                          )),
                      SizedBox(height: h * 0.02),
                      Divider(
                        color: lightGreyColor,
                        thickness: 2,
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("PaymentDetail")
                              .where("UserId", isEqualTo: PreferenceManager.getUserId())
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var paymentData = snapshot.data?.docs;
                              return Column(
                                children: [
                                  SizedBox(height: h * 0.02),
                                  InkResponse(
                                    onTap: () {
                                      Get.to(const EditProfileScreen(), arguments: {
                                        "Name": userData?[0]["Full Name"] ?? "",
                                        "Email": userData?[0]["Email"] ?? "",
                                        "PhoneNumber": userData?[0]["PhoneNumber"] ?? "",
                                        "Address": userData?[0]["Address"] ?? "",
                                        "City": userData?[0]["City"] ?? "",
                                        "CountryCode": userData?[0]["CountryCode"] ?? "",
                                        "Country": userData?[0]["Country"] ?? "",
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.account_balance_wallet,
                                          color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                        ),
                                        SizedBox(width: w * 0.03),
                                        Text('Account'.tr,
                                            style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                                              color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                            )),
                                        const Spacer(),
                                        Icon(Icons.arrow_forward_ios,
                                            color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor, size: 15),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: h * 0.02),
                                  InkResponse(
                                    onTap: () {
                                      paymentData!.isEmpty
                                          ? Get.to(
                                              const EditPaymentDetailScreen(),
                                              arguments: {
                                                "FirstName": "",
                                                "LastName": "",
                                                "CompanyName": "",
                                                "AccountNumber": "",
                                                "BankName": "",
                                                "BankAddress": "",
                                                "Country": "SelectCountry".tr,
                                                "IBAN": "",
                                                "BIC": "",
                                                "PanNumber": "",
                                                "PaymentId": "",
                                              },
                                            )
                                          : Get.to(
                                              const EditPaymentDetailScreen(),
                                              arguments: {
                                                "FirstName": paymentData[0]["FirstName"] ?? "",
                                                "LastName": paymentData[0]["LastName"] ?? "",
                                                "CompanyName": paymentData[0]["CompanyName"] ?? "",
                                                "AccountNumber": paymentData[0]["AccountNumber"] ?? "",
                                                "BankName": paymentData[0]["BankName"] ?? "",
                                                "BankAddress": paymentData[0]["BankAddress"] ?? "",
                                                "Country": paymentData[0]["Country"] ?? "",
                                                "IBAN": paymentData[0]["IBAN"] ?? "",
                                                "BIC": paymentData[0]["BIC"] ?? "",
                                                "PanNumber": paymentData[0]["PanNumber"] ?? "",
                                                "PaymentId": snapshot.data?.docs[0].id ?? ""
                                              },
                                            );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.payment_outlined,
                                          color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                        ),
                                        SizedBox(width: w * 0.03),
                                        Text('PaymentDetails'.tr,
                                            style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                                              color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                            )),
                                        const Spacer(),
                                        Icon(Icons.arrow_forward_ios,
                                            color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor, size: 15),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: h * 0.02),
                                  InkResponse(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  Theme.of(context).brightness == Brightness.dark ? darkModeBottomBarColor : whiteColor,
                                              content: SizedBox(
                                                height: h * 0.09,
                                                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                  InkResponse(
                                                    onTap: () {
                                                      controller.selectLanguage(0);
                                                      Get.updateLocale(const Locale('en', 'US'));
                                                      PreferenceManager.setLanguage('en');
                                                      setState(() {});
                                                      Get.back();
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          "English".tr,
                                                          style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                                                              color: Theme.of(context).brightness == Brightness.dark
                                                                  ? whiteColor
                                                                  : blackColor),
                                                        ),
                                                        controller.selectedLanguageIndex == 0
                                                            ? const Icon(
                                                                Icons.check,
                                                                color: greyColor,
                                                              )
                                                            : const SizedBox(),
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(height: h * 0.01, color: greyColor),
                                                  InkResponse(
                                                    onTap: () {
                                                      controller.selectLanguage(1);
                                                      Get.updateLocale(const Locale('hr', 'HR'));
                                                      PreferenceManager.setLanguage('hr');
                                                      setState(() {});
                                                      Get.back();
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Croatian".tr,
                                                          style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                                                              color: Theme.of(context).brightness == Brightness.dark
                                                                  ? whiteColor
                                                                  : blackColor),
                                                        ),
                                                        controller.selectedLanguageIndex == 1
                                                            ? const Icon(
                                                                Icons.check,
                                                                color: greyColor,
                                                              )
                                                            : const SizedBox(),
                                                      ],
                                                    ),
                                                  ),
                                                ]

                                                    // List.generate(
                                                    //   controller
                                                    //       .languageList.length,
                                                    //   (index) => Column(
                                                    //     mainAxisAlignment:
                                                    //         MainAxisAlignment
                                                    //             .center,
                                                    //     children: [
                                                    //
                                                    //
                                                    //       InkWell(
                                                    //         onTap: () {
                                                    //           controller
                                                    //               .selectLanguage(
                                                    //                   index);
                                                    //           if (controller
                                                    //                   .selectedLanguageIndex ==
                                                    //               0) {
                                                    //             Get.updateLocale(
                                                    //                 const Locale(
                                                    //                     'en',
                                                    //                     'US'));
                                                    //             PreferenceManager
                                                    //                 .setLanguage(
                                                    //                     'en');
                                                    //             setState(() {});
                                                    //           } else {
                                                    //             Get.updateLocale(
                                                    //                 const Locale(
                                                    //                     'hr',
                                                    //                     'HR'));
                                                    //             PreferenceManager
                                                    //                 .setLanguage(
                                                    //                     'hr');
                                                    //             setState(() {});
                                                    //           }
                                                    //           Get.back();
                                                    //         },
                                                    //         child: Row(
                                                    //           mainAxisAlignment:
                                                    //               MainAxisAlignment
                                                    //                   .spaceBetween,
                                                    //           children: [
                                                    //             Text(
                                                    //               controller
                                                    //                       .languageList[
                                                    //                   index],
                                                    //               style: CommonTextStyle
                                                    //                   .kWhite15OpenSansSemiBold
                                                    //                   .copyWith(
                                                    //                       color: Theme.of(context).brightness ==
                                                    //                               Brightness.dark
                                                    //                           ? whiteColor
                                                    //                           : blackColor),
                                                    //             ),
                                                    //             controller.selectedLanguageIndex ==
                                                    //                     index
                                                    //                 ? const Icon(
                                                    //                     Icons
                                                    //                         .check,
                                                    //                     color:
                                                    //                         greyColor,
                                                    //                   )
                                                    //                 : const SizedBox(),
                                                    //           ],
                                                    //         ),
                                                    //       ),
                                                    //       Divider(
                                                    //         height: h * 0.01,
                                                    //         color: index == 0
                                                    //             ? greyColor
                                                    //             : Colors
                                                    //                 .transparent,
                                                    //       )
                                                    //     ],
                                                    //   ),
                                                    // ),

                                                    ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.language_outlined,
                                          color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                        ),
                                        SizedBox(width: w * 0.03),
                                        Text('Language'.tr,
                                            style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                                              color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                            )),
                                        const Spacer(),
                                        Icon(Icons.arrow_forward_ios,
                                            color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor, size: 15),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: h * 0.02),
                                  InkResponse(
                                    onTap: () {
                                      PreferenceManager.logOut();
                                      PreferenceManager().googleLogout();
                                      Get.to(const InvoiceView());
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.logout,
                                          color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                        ),
                                        SizedBox(width: w * 0.03),
                                        Text('Logout'.tr,
                                            style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                                              color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                            )),
                                        const Spacer(),
                                        Icon(Icons.arrow_forward_ios,
                                            color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor, size: 15),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                              //   Column(
                              //   children: List.generate(
                              //       4,
                              //       (index) => Padding(
                              //             padding: EdgeInsets.symmetric(
                              //                 vertical: h * 0.015),
                              //             child: InkResponse(
                              //               onTap: () {
                              //                 log('userData?[0]["Full Name"]==========>>>>>${userData?[0]["Full Name"]}');
                              //                 index == 0
                              //                     ? Get.to(
                              //                         const EditProfileScreen(),
                              //                         arguments: {
                              //                             "Name": userData?[0][
                              //                                     "Full Name"] ??
                              //                                 "",
                              //                             "Email": userData?[0]
                              //                                     ["Email"] ??
                              //                                 "",
                              //                             "PhoneNumber": userData?[
                              //                                         0][
                              //                                     "PhoneNumber"] ??
                              //                                 "",
                              //                             "Address": userData?[
                              //                                         0]
                              //                                     ["Address"] ??
                              //                                 "",
                              //                             "City": userData?[0]
                              //                                     ["City"] ??
                              //                                 "",
                              //                             "CountryCode": userData?[
                              //                                         0][
                              //                                     "CountryCode"] ??
                              //                                 "",
                              //                             "Country": userData?[
                              //                                         0]
                              //                                     ["Country"] ?? "",
                              //                           })
                              //                     : index == 1
                              //                         ? paymentData!.isEmpty
                              //                             ? Get.to(
                              //                                 const EditPaymentDetailScreen())
                              //                             : Get.to(
                              //                                 const EditPaymentDetailScreen(),
                              //                                 arguments: {
                              //                                     "AccHolderName":
                              //                                         paymentData[0]
                              //                                                 [
                              //                                                 "AccHolderName"] ??
                              //                                             "",
                              //                                     "AccountNumber":
                              //                                         paymentData[0]
                              //                                                 [
                              //                                                 "AccountNumber"] ??
                              //                                             "",
                              //                                     "BankName":
                              //                                         paymentData[0]
                              //                                                 [
                              //                                                 "BankName"] ??
                              //                                             "",
                              //                                     "BankAddress":
                              //                                         paymentData[0]
                              //                                                 [
                              //                                                 "BankAddress"] ??
                              //                                             "",
                              //                                     "IfscCode":
                              //                                         paymentData[0]
                              //                                                 [
                              //                                                 "IfscCode"] ??
                              //                                             "",
                              //                                     "PanNumber":
                              //                                         paymentData[0]
                              //                                                 [
                              //                                                 "PanNumber"] ??
                              //                                             "",
                              //                                     "PaymentId": snapshot
                              //                                             .data
                              //                                             ?.docs[
                              //                                                 0]
                              //                                             .id ??
                              //                                         ""
                              //                                   })
                              //                         : index == 2
                              //                             ? showDialog(
                              //                                 context: context,
                              //                                 builder:
                              //                                     (context) {
                              //                                   return AlertDialog(
                              //                                     backgroundColor: Theme.of(context)
                              //                                                 .brightness ==
                              //                                             Brightness
                              //                                                 .dark
                              //                                         ? darkModeBottomBarColor
                              //                                         : whiteColor,
                              //                                     content:
                              //                                         SizedBox(
                              //                                       height: h *
                              //                                           0.09,
                              //                                       child:
                              //                                           Column(
                              //                                         mainAxisAlignment:
                              //                                             MainAxisAlignment
                              //                                                 .center,
                              //                                         children:
                              //                                             List.generate(
                              //                                           controller
                              //                                               .languageList
                              //                                               .length,
                              //                                           (index) =>
                              //                                               Column(
                              //                                             mainAxisAlignment:
                              //                                                 MainAxisAlignment.center,
                              //                                             children: [
                              //                                               InkWell(
                              //                                                 onTap: () {
                              //                                                   controller.selectLanguage(index);
                              //                                                   if (controller.selectedLanguageIndex == 0) {
                              //                                                     Get.updateLocale(const Locale('en', 'US'));
                              //                                                     PreferenceManager.setLanguage('en');
                              //                                                     setState(() {});
                              //                                                   } else {
                              //                                                     Get.updateLocale(const Locale('hr', 'HR'));
                              //                                                     PreferenceManager.setLanguage('hr');
                              //                                                     setState(() {});
                              //                                                   }
                              //                                                   Get.back();
                              //                                                 },
                              //                                                 child: Row(
                              //                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                                                   children: [
                              //                                                     Text(
                              //                                                       controller.languageList[index],
                              //                                                       style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor),
                              //                                                     ),
                              //                                                     controller.selectedLanguageIndex == index
                              //                                                         ? const Icon(
                              //                                                             Icons.check,
                              //                                                             color: greyColor,
                              //                                                           )
                              //                                                         : const SizedBox(),
                              //                                                   ],
                              //                                                 ),
                              //                                               ),
                              //                                               Divider(
                              //                                                 height: h * 0.01,
                              //                                                 color: index == 0 ? greyColor : Colors.transparent,
                              //                                               )
                              //                                             ],
                              //                                           ),
                              //                                         ),
                              //                                       ),
                              //                                     ),
                              //                                   );
                              //                                 })
                              //                             : const SizedBox();
                              //                 if (index == 3) {
                              //                   PreferenceManager.logOut();
                              //                   Get.to(const InvoiceView());
                              //                 }
                              //                 //Get.to(controller.navigatorList[index]);
                              //               },
                              //               child: Row(
                              //                 children: [
                              //                   Icon(
                              //                     controller.iconList[index],
                              //                     color: Theme.of(context)
                              //                                 .brightness ==
                              //                             Brightness.dark
                              //                         ? whiteColor
                              //                         : blackColor,
                              //                   ),
                              //                   SizedBox(width: w * 0.03),
                              //                   Text(
                              //                       controller
                              //                           .profileTextList[index],
                              //                       style: CommonTextStyle
                              //                           .kWhite15OpenSansSemiBold
                              //                           .copyWith(
                              //                         color: Theme.of(context)
                              //                                     .brightness ==
                              //                                 Brightness.dark
                              //                             ? whiteColor
                              //                             : blackColor,
                              //                       )),
                              //                   const Spacer(),
                              //                   Icon(Icons.arrow_forward_ios,
                              //                       color: Theme.of(context)
                              //                                   .brightness ==
                              //                               Brightness.dark
                              //                           ? whiteColor
                              //                           : blackColor,
                              //                       size: 15),
                              //                 ],
                              //               ),
                              //             ),
                              //           )),
                              // );
                            } else {
                              return const SizedBox();
                            }
                          }),
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            });
      }),
    );
  }

  Future<dynamic> pickPhotoBottomSheet({
    required BuildContext context,
    required double w,
    Function()? galleryOnTap,
    Function()? cameraOnTap,
  }) {
    final h = Get.height;
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      barrierColor: blackColor.withOpacity(0.8),
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: whiteColor,
            // borderRadius: BorderRadius.vertical(
            //   top: Radius.circular(20),
            // ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: h * 0.04),
              Center(
                child: Text("Choose Source", style: CommonTextStyle.kGrey22OpenSansSemiBold.copyWith(color: greyColor)),
              ),
              SizedBox(height: h * 0.04),
              InkWell(
                onTap: galleryOnTap,
                child: Center(
                    child: Text(
                  "Gallery",
                  style: CommonTextStyle.kBlack20OpenSansBold,
                )),
              ),
              SizedBox(height: h * 0.04),
              InkWell(
                onTap: cameraOnTap,
                child: Center(
                    child: Text(
                  "Camera",
                  style: CommonTextStyle.kBlack20OpenSansBold,
                )),
              ),
              SizedBox(height: h * 0.04),
            ],
          ),
        );
      },
    );
  }
}
