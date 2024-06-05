import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:generate_invoice_app/const/app_color.dart';
import 'package:generate_invoice_app/utils/common_textstyle.dart';
import 'package:generate_invoice_app/widgets/app_buttons.dart';
import 'package:generate_invoice_app/widgets/app_circular.dart';
import 'package:generate_invoice_app/widgets/app_textfeild.dart';
import 'package:generate_invoice_app/widgets/common_appbar.dart';
import 'package:get/get.dart';
import 'controller/payment_detail_controller.dart';

class PaymentDetailScreen extends StatefulWidget {
  const PaymentDetailScreen({super.key});

  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  PaymentDetailController paymentDetailController = Get.put(PaymentDetailController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      //backgroundColor: darkModeScaffoldColor,
      appBar: CommonAppBar(
        leadingIcon: true,
        title: "PaymentDetails".tr,
        // AppString.paymentDeatilText,
      ),
      body: GetBuilder<PaymentDetailController>(builder: (controller) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.02),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //     //AppString.accountHoldText,
                  //     "AccountHoldText".tr,
                  //     style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                  //       color: Theme.of(context).brightness == Brightness.dark
                  //           ? whiteColor
                  //           : blackColor,
                  //     )),
                  // SizedBox(height: h * 0.01),
                  // commonTextFeild(
                  //   controller: controller.accHolderNameController,
                  //   hintText:
                  //       //AppString.plEnNameText,
                  //       "PleaseEnterName".tr,
                  //   validator: (value) {
                  //     if (value.isEmpty) {
                  //       return "Feild is required";
                  //     } else {
                  //       return null;
                  //     }
                  //   },
                  // ),
                  Text(
                      //AppString.accountHoldText,
                      "FirstName".tr,
                      style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                      )),
                  SizedBox(height: h * 0.01),
                  commonTextFeild(
                    controller: controller.firstNameController,
                    hintText:
                        //AppString.plEnNameText,
                        "plEnFirstNameText".tr,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Feild is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: h * 0.02),
                  Text(
                      //AppString.accountHoldText,
                      "LastName".tr,
                      style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                      )),
                  SizedBox(height: h * 0.01),
                  commonTextFeild(
                    controller: controller.lastNameController,
                    hintText:
                        //AppString.plEnNameText,
                        "plEnLastNameText".tr,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Feild is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: h * 0.02),
                  Text(
                      //AppString.accountHoldText,
                      "CompanyName".tr,
                      style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                      )),
                  SizedBox(height: h * 0.01),
                  commonTextFeild(
                    controller: controller.companyNameController,
                    hintText:
                        //AppString.plEnNameText,
                        "plEnCompanyName".tr,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Feild is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: h * 0.02),
                  Text(
                      // AppString.acNumText,
                      "AccountNumber".tr,
                      style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                      )),
                  SizedBox(height: h * 0.01),
                  commonTextFeild(
                    controller: controller.accNumberController,
                    hintText: "plEnAcNumText".tr,
                    //AppString.plEnAcNumText,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Feild is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: h * 0.02),
                  Text("BankName".tr,
                      //AppString.bankNameText,
                      style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                      )),
                  SizedBox(height: h * 0.01),
                  commonTextFeild(
                    controller: controller.bankNameController,
                    hintText: "plEnBankNameText".tr,
                    //AppString.plEnBankNameText,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Feild is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: h * 0.02),
                  Text("BankAddress".tr,
                      //AppString.bankAddressText,
                      style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                      )),
                  SizedBox(height: h * 0.01),
                  commonTextFeild(
                    controller: controller.bankAddressController,
                    hintText: "plEnBankAddressText".tr,
                    //AppString.plEnBankAddressText,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Feild is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: h * 0.02),
                  Text("Country".tr,
                      style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                      )),
                  SizedBox(height: h * 0.01),
                  commonTextFeild(
                    //textStyle: CommonTextStyle.kWhite15OpenSansSemiBold,
                    controller: controller.countryController,
                    hintText: controller.selectedCountry != null ? controller.selectedCountry?.name : "SelectCountry".tr,
                    hintStyle: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                    ),
                    suffix: InkResponse(
                      onTap: () {
                        showCountryPicker(
                          showPhoneCode: true,
                          context: context,
                          countryListTheme: CountryListThemeData(
                            flagSize: 25,
                            backgroundColor: darkModeBottomBarColor,
                            // textStyle: CommonTextStyle.kWhite15OpenSansSemiBold
                            //     .copyWith(
                            //         color: Theme.of(Get.context!).brightness ==
                            //                 Brightness.dark
                            //             ? whiteColor
                            //             : blackColor),
                            bottomSheetHeight: 500,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                            inputDecoration: InputDecoration(
                              labelText: 'Search',
                              hintText: 'Start typing to search',
                              contentPadding: EdgeInsets.symmetric(vertical: h * 0.025),
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(0xFF8C98A8).withOpacity(0.2),
                                ),
                              ),
                            ),
                          ),
                          onSelect: (Country country) => setState(() {
                            controller.selectedCountry = country;
                            controller.countryCode = '+${country.phoneCode}';
                            // controller.phoneController.text =
                            //     controller.countryCode!;
                            print('Select country: ${country.displayName}');
                          }),
                        );
                      },
                      child: Icon(
                        Icons.arrow_drop_down_outlined,
                        color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                      ),
                    ),
                  ),
                  // SizedBox(height: h * 0.02),
                  // Text("ifscText".tr,
                  //     //AppString.ifscText,
                  //     style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                  //       color: Theme.of(context).brightness == Brightness.dark
                  //           ? whiteColor
                  //           : blackColor,
                  //     )),
                  // SizedBox(height: h * 0.01),
                  // commonTextFeild(
                  //   // controller: controller.ifscController,
                  //   hintText: "plEnIfscCodeText".tr,
                  //   //AppString.plEnIfscCodeText,
                  //   validator: (value) {
                  //     if (value.isEmpty) {
                  //       return "Feild is required";
                  //     } else {
                  //       return null;
                  //     }
                  //   },
                  // ),
                  SizedBox(height: h * 0.02),
                  Text(
                      //AppString.accountHoldText,
                      "IBAN".tr,
                      style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                      )),
                  SizedBox(height: h * 0.01),
                  commonTextFeild(
                    controller: controller.ibanController,
                    hintText:
                        //AppString.plEnNameText,
                        "plEnIBANText".tr,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Feild is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: h * 0.02),
                  Text(
                      //AppString.accountHoldText,
                      "BIC".tr,
                      style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                      )),
                  SizedBox(height: h * 0.01),
                  commonTextFeild(
                    controller: controller.bicController,
                    hintText:
                        //AppString.plEnNameText,
                        "plEnBICText".tr,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Feild is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: h * 0.02),
                  Text("PANNumber".tr,
                      //AppString.panNumText,
                      style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                      )),
                  SizedBox(height: h * 0.01),
                  commonTextFeild(
                    controller: controller.panNumberController,
                    hintText: "plEnPanNumText".tr,
                    //AppString.plEnPanNumText,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Feild is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: h * 0.03),
                  commonButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        controller.addPaymentDetail();
                      }
                    },
                    child: controller.loading == true
                        ? commonCircular()
                        : Text(
                            "Save".tr,
                            //AppString.saveText,
                            style: CommonTextStyle.kWhite15OpenSansSemiBold,
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
