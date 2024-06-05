import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:generate_invoice_app/const/app_color.dart';
import 'package:generate_invoice_app/const/app_image.dart';
import 'package:generate_invoice_app/utils/app_routes.dart';
import 'package:generate_invoice_app/utils/common_textstyle.dart';
import 'package:generate_invoice_app/utils/preference_manager.dart';
import 'package:generate_invoice_app/widgets/common_appbar.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      //backgroundColor: darkModeScaffoldColor,
      appBar: CommonAppBar(
        title: "Client".tr,
        //AppString.clientText,
        action: true,
        actionWidget: Padding(
          padding: EdgeInsets.only(right: w * 0.02),
          child: InkResponse(
            onTap: () {
              Get.toNamed(Routes.addNewClient);
            },
            child: Icon(
              Icons.add,
              color: whiteColor,
              size: 25,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.03),
        child: Column(
          children: [
            SizedBox(height: h * 0.01),
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("Clients").where("UserId", isEqualTo: PreferenceManager.getUserId()).snapshots(),
                builder: (context, snapshot) {
                  var clientData = snapshot.data?.docs;
                  if (snapshot.hasData) {
                    return Expanded(
                      child: clientData!.isEmpty
                          ? Center(
                              child: Lottie.asset(
                                repeat: false,
                                "assets/animation/lottie/empty_box.json",
                                height: h * 0.55,
                                width: h * 0.45,
                              ),
                            )
                          : ListView.builder(
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (context, index) {
                                log("Data===$clientData");
                                log("ClientId==>>${clientData[index]["ClientId"]}");
                                return InkResponse(
                                  onTap: () {
                                    Get.toNamed(Routes.clientDetail, arguments: {
                                      "ClientName": clientData[index]["FullName"],
                                      "ClientId": clientData[index]["ClientId"],
                                      "ClientEmail": clientData[index]["Email"],
                                      "ClientCity": clientData[index]["City"],
                                    });
                                  },
                                  child: Container(
                                    height: h * 0.08,
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(vertical: h * 0.01),
                                    padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).brightness == Brightness.dark ? darkModeBottomBarColor : whiteColor,
                                      border: Border.all(color: lightGreyColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: h * 0.06,
                                          width: w * 0.12,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Theme.of(context).brightness == Brightness.dark ? whiteColor : lightModeGreyColor,
                                          ),
                                          child: Image.asset(AppImage.personImage),
                                        ),
                                        SizedBox(width: w * 0.02),
                                        Text(
                                          //"Shreya",
                                          "${clientData[index]["FullName"]}",
                                          style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                                            color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    );
                  } else {
                    return Center(
                      child: Lottie.asset(
                        repeat: false,
                        "assets/animation/lottie/empty_box.json",
                        height: h * 0.55,
                        width: h * 0.45,
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
