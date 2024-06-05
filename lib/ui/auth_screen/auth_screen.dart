import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:generate_invoice_app/const/app_color.dart';
import 'package:generate_invoice_app/const/app_image.dart';
import 'package:generate_invoice_app/utils/app_routes.dart';
import 'package:generate_invoice_app/utils/common_textstyle.dart';
import 'package:generate_invoice_app/utils/preference_manager.dart';
import 'package:generate_invoice_app/widgets/app_buttons.dart';
import 'package:generate_invoice_app/widgets/app_circular.dart';
import 'package:generate_invoice_app/widgets/app_snackbar.dart';
import 'package:generate_invoice_app/widgets/app_textfeild.dart';
import 'package:get/get.dart';
import 'controller/auth_controller.dart';

class InvoiceView extends StatefulWidget {
  const InvoiceView({super.key});

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> with TickerProviderStateMixin {
  AuthController invoiceController = Get.put(AuthController());
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(handleTabSelection);
    invoiceController.emailController.clear();
    invoiceController.passWordController.clear();
    log("username====>>>${PreferenceManager.getUserId()}");
    log("username====>>>${PreferenceManager.getUserName()}");
    log("username====>>>${PreferenceManager.getEmail()}");
    log('AddPaymentDetail====>>>${PreferenceManager.getAddPaymentDetail()}');
    log('getStripePayment=====>>>>>${PreferenceManager.getStripePayment()}');
    // TODO: implement initState
    super.initState();
  }

  void handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: darkModeScaffoldColor,
      body: GetBuilder<AuthController>(builder: (controller) {
        return Center(
          child: Column(
            children: [
              SizedBox(height: h * 0.07),
              Text(
                //AppString.invoiceText,
                //   AppStringLocal.en["Invoice"],
                'Invoice'.tr,
                //"${AppStringLocal.en["Invoice"].tr()}",
                //AppLocalizations.of(context)!.translate('Invoice')!,
                style: CommonTextStyle.kWhite22OpenSansSemiBold
                    .copyWith(color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor),
              ),
              SizedBox(height: h * 0.03),
              DefaultTabController(
                length: 2,
                child: TabBar(
                    labelPadding: EdgeInsets.only(bottom: h * 0.01),
                    controller: tabController,
                    indicatorColor: Theme.of(context).brightness == Brightness.dark ? darkModePrimaryColor : lightModePrimaryColor,
                    //  darkModePrimaryColor,
                    dividerColor: Colors.transparent,
                    indicatorWeight: 4.0,
                    padding: EdgeInsets.symmetric(horizontal: w * 0.17),
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Text(
                        //AppString.signInText,
                        "SignIn".tr,
                        style: tabController?.index == 0
                            ? CommonTextStyle.kWhite22OpenSansSemiBold.copyWith(
                                color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                fontSize: 20,
                              )
                            : CommonTextStyle.kGrey22OpenSansSemiBold.copyWith(
                                color: Theme.of(context).brightness == Brightness.dark ? greyTextColor : lightModeGreyTextColor,
                                fontSize: 20),
                      ),
                      Text(
                        //AppString.signUpText,
                        "SignUp".tr,
                        style: tabController?.index == 1
                            ? CommonTextStyle.kWhite22OpenSansSemiBold
                                .copyWith(color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor, fontSize: 20)
                            : CommonTextStyle.kGrey22OpenSansSemiBold.copyWith(
                                color: Theme.of(context).brightness == Brightness.dark ? greyTextColor : lightModeGreyTextColor,
                                fontSize: 20),
                      ),
                    ]),
              ),
              Expanded(
                  child: TabBarView(
                controller: tabController,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: h * 0.03),
                        Text(
                            //AppString.letsFillingBelowText,
                            "Lets".tr,
                            style: CommonTextStyle.kWhite15OpenSansSemiBold
                                .copyWith(color: Theme.of(context).brightness == Brightness.dark ? greyTextColor : lightModeGreyTextColor)),
                        SizedBox(height: h * 0.04),
                        commonTextFeild(
                          controller: controller.emailController,
                          labelText: "Email".tr,
                          // verticalPadding: h * 0.025,
                        ),
                        SizedBox(height: h * 0.02),
                        commonTextFeild(
                          obscure: controller.isshow,
                          controller: controller.passWordController,
                          labelText: "Password".tr,
                          // verticalPadding: h * 0.025,
                          suffix: IconButton(
                            onPressed: () {
                              controller.passwordShow();
                            },
                            icon: controller.isshow == true
                                ? Icon(
                                    Icons.visibility_off,
                                    color: lightGreyColor,
                                  )
                                : Icon(
                                    Icons.visibility,
                                    color: lightGreyColor,
                                  ),
                          ),
                        ),
                        SizedBox(height: h * 0.02),
                        commonButton(
                          // color: Theme.of(context).brightness == Brightness.dark
                          //     ? darkModePrimaryColor
                          //     : lightModePrimaryColor,
                          onPressed: () {
                            controller.userLogin();
                            // Get.toNamed(Routes.bottomBar);
                          },
                          child: controller.loading == true
                              ?
                              // SizedBox(
                              //         height: h * 0.03,
                              //         width: w * 0.055,
                              //         child: const CircularProgressIndicator(
                              //             color: whiteColor))
                              commonCircular()
                              : Text(
                                  //AppString.signInText,
                                  "SignIn".tr,
                                  style: CommonTextStyle.kWhite15OpenSansSemiBold),
                        ),
                        SizedBox(height: h * 0.05),
                        InkResponse(
                          onTap: () async {
                            // await controller.googleSignIn
                            //     .signOut()
                            //     .then((value) => log('You are LogOut'));
                            Get.toNamed(Routes.forgotPassword);
                          },
                          child: Center(
                            child: Text(
                                //AppString.forgotPassText,
                                "ForgotPassword".tr,
                                style: CommonTextStyle.kWhite15OpenSansSemiBold
                                    .copyWith(color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor)),
                          ),
                        ),
                        SizedBox(height: h * 0.06),
                        // InkResponse(
                        //     onTap: () async {
                        //       await controller.makePayment();
                        //       // await StripePaymentHandle().stripeMakePayment();
                        //       // await controller.createPaymentIntent("30", 'INR');
                        //     },
                        //     child: Center(
                        //         child: Text("Payment",
                        //             style: CommonTextStyle
                        //                 .kWhite15OpenSansSemiBold))),
                        // SizedBox(height: h * 0.05),
                        Center(
                          child: Container(
                            // height: h * 0.07,
                            //width: w * 0.65,
                            margin: EdgeInsets.symmetric(horizontal: w * 0.19),
                            padding: EdgeInsets.symmetric(horizontal: w * 0.015, vertical: h * 0.01),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor),
                                borderRadius: BorderRadius.circular(10)),
                            child: InkResponse(
                              onTap: () {
                                controller.googleLogin();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    // height: h * 0.05,
                                    //width: w * 0.12,
                                    padding: EdgeInsets.symmetric(vertical: h * 0.005, horizontal: w * 0.005),
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Image.asset(
                                      AppImage.googleImage,
                                      // scale: 1.2,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: w * 0.02),
                                    child: controller.loadingGoogle == true
                                        ? commonCircular()
                                        : Text(
                                            // AppString.continueWithGoogleText,
                                            "ContinueWithGoogle".tr,
                                            //style: CommonTextStyle.kWhite15OpenSansSemiBold,
                                            style: TextStyle(
                                                fontFamily: "OpenSansSemiBold",
                                                color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                                fontSize: 13),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.03),
                    child: Column(
                      children: [
                        Text(
                            // AppString.letsFillingBelowText,
                            "Lets".tr,
                            style: CommonTextStyle.kWhite15OpenSansSemiBold
                                .copyWith(color: Theme.of(context).brightness == Brightness.dark ? greyTextColor : lightModeGreyTextColor)),
                        SizedBox(height: h * 0.04),
                        commonTextFeild(
                          controller: controller.nameController,
                          labelText: "Name".tr,
                          //  verticalPadding: h * 0.025,
                        ),
                        SizedBox(height: h * 0.02),
                        commonTextFeild(
                          controller: controller.emailControllerSignup,
                          labelText: "Email".tr,
                          //verticalPadding: h * 0.025,
                        ),
                        SizedBox(height: h * 0.02),
                        commonTextFeild(
                          obscure: controller.isshow1,
                          controller: controller.passwordControllerSignup,
                          labelText: "Password".tr,
                          //verticalPadding: h * 0.025,
                          suffix: InkResponse(
                            onTap: () {
                              controller.passwordShow1();
                            },
                            child: controller.isshow1 == true
                                ? Icon(
                                    Icons.visibility_off,
                                    color: lightGreyColor,
                                  )
                                : Icon(
                                    Icons.visibility,
                                    color: lightGreyColor,
                                  ),
                          ),
                        ),
                        SizedBox(height: h * 0.02),
                        commonTextFeild(
                            obscure: controller.isshow2,
                            controller: controller.confirmPasswordController,
                            labelText: "ConfirmPassword".tr,
                            // verticalPadding: h * 0.025,
                            suffix: InkResponse(
                              onTap: () {
                                controller.passwordShow2();
                              },
                              child: controller.isshow2 == true
                                  ? Icon(
                                      Icons.visibility_off,
                                      color: lightGreyColor,
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      color: lightGreyColor,
                                    ),
                            )),
                        SizedBox(height: h * 0.02),
                        commonButton(
                          // color: Theme.of(context).brightness == Brightness.dark
                          //     ? darkModePrimaryColor
                          //     : lightModePrimaryColor,
                          //height: h * 0.08,
                          onPressed: () async {
                            if (controller.passwordControllerSignup.text != controller.confirmPasswordController.text) {
                              appSnackBar(message: "Password don't match!");
                            } else {
                              controller.createUser();
                            }
                            //Get.toNamed(Routes.bottomBar);
                          },
                          child: controller.isLoading == true
                              ?
                              // SizedBox(
                              //         height: h * 0.03,
                              //         width: w * 0.055,
                              //         child: const CircularProgressIndicator(
                              //             color: whiteColor))
                              commonCircular()
                              : Text(
                                  //  AppString.createAccText,
                                  "CreateAccount".tr,
                                  style: CommonTextStyle.kWhite15OpenSansSemiBold,
                                ),
                        ),
                        const Spacer(),
                        Center(
                          child: Container(
                            // height: h * 0.07,
                            //width: w * 0.65,
                            margin: EdgeInsets.symmetric(horizontal: w * 0.19),
                            padding: EdgeInsets.symmetric(horizontal: w * 0.015, vertical: h * 0.01),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor),
                                borderRadius: BorderRadius.circular(10)),
                            child: InkResponse(
                              onTap: () {
                                controller.googleLogin();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    // height: h * 0.05,
                                    //width: w * 0.12,
                                    padding: EdgeInsets.symmetric(vertical: h * 0.005, horizontal: w * 0.005),
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Image.asset(
                                      AppImage.googleImage,
                                      // scale: 1.2,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: w * 0.02),
                                    child: Text(
                                      //AppString.continueWithGoogleText,
                                      "ContinueWithGoogle".tr,
                                      style: TextStyle(
                                          fontFamily: "OpenSansSemiBold",
                                          color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                          fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
            ],
          ),
        );
      }),
    );
  }
}
