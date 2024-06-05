import 'dart:developer';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:generate_invoice_app/const/app_color.dart';
import 'package:generate_invoice_app/utils/common_textstyle.dart';
import 'package:generate_invoice_app/widgets/app_buttons.dart';
import 'package:generate_invoice_app/widgets/app_textfeild.dart';
import 'package:generate_invoice_app/widgets/common_appbar.dart';
import 'package:get/get.dart';
import 'controller/edit_payment_detail_controller.dart';

class EditPaymentDetailScreen extends StatefulWidget {
  const EditPaymentDetailScreen({super.key});

  @override
  State<EditPaymentDetailScreen> createState() => _EditPaymentDetailScreenState();
}

class _EditPaymentDetailScreenState extends State<EditPaymentDetailScreen> {
  EditPaymentDetailController editPaymentDetailController = Get.put(EditPaymentDetailController());
  var data = Get.arguments;

  @override
  void initState() {
    //editPaymentDetailController.getPaymentDetail();
    if (data != null) {
      editPaymentDetailController.firstNameController.text = data["FirstName"] ?? "";
      editPaymentDetailController.lastNameController.text = data["LastName"] ?? "";
      editPaymentDetailController.companyNameController.text = data["CompanyName"] ?? "";
      editPaymentDetailController.accNumberController.text = data["AccountNumber"] ?? "";
      editPaymentDetailController.bankNameController.text = data["BankName"] ?? "";
      // editPaymentDetailController.countryController.text = data["Country"] ?? "";
      editPaymentDetailController.bankAddressController.text = data["BankAddress"] ?? "";
      //  editPaymentDetailController.ifscController.text = data["IfscCode"] ?? "";
      editPaymentDetailController.ibanController.text = data["IBAN"] ?? "";
      editPaymentDetailController.bicController.text = data["BIC"] ?? "";
      editPaymentDetailController.panNumberController.text = data["PanNumber"] ?? "";
      log('data["PaymentId"]==========>>>>>${data["PaymentId"] ?? ""}');
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      //   backgroundColor: darkModeScaffoldColor,
      appBar: CommonAppBar(
        leadingIcon: true,
        title: "PaymentDetails".tr,
      ),
      body: GetBuilder<EditPaymentDetailController>(builder: (controller) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.02),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text("AccountHoldText".tr,
                //     style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                //       color: Theme.of(context).brightness == Brightness.dark
                //           ? whiteColor
                //           : blackColor,
                //     )),
                // SizedBox(height: h * 0.01),
                // commonTextFeild(
                //   //controller: controller.accHolderNameController,
                //   hintText: "AccountHoldText".tr,
                // ),
                Text(
                  "FirstName".tr,
                  style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                  ),
                ),
                SizedBox(height: h * 0.01),
                commonTextFeild(
                  controller: controller.firstNameController,
                  hintText: "plEnFirstNameText".tr,
                ),
                SizedBox(height: h * 0.02),
                Text(
                  "LastName".tr,
                  style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                  ),
                ),
                SizedBox(height: h * 0.01),
                commonTextFeild(
                  controller: controller.lastNameController,
                  hintText: "plEnLastNameText".tr,
                ),
                SizedBox(height: h * 0.02),
                Text(
                  "CompanyName".tr,
                  style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                  ),
                ),
                SizedBox(height: h * 0.01),
                commonTextFeild(
                  controller: controller.companyNameController,
                  hintText: "plEnCompanyName".tr,
                ),
                SizedBox(height: h * 0.02),
                Text(
                  "AccountNumber".tr,
                  style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                  ),
                ),
                SizedBox(height: h * 0.01),
                commonTextFeild(
                  controller: controller.accNumberController,
                  hintText: "plEnAcNumText".tr,
                ),
                SizedBox(height: h * 0.02),
                Text(
                  "BankName".tr,
                  style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                  ),
                ),
                SizedBox(height: h * 0.01),
                commonTextFeild(
                  controller: controller.bankNameController,
                  hintText: "plEnBankNameText".tr,
                ),
                SizedBox(height: h * 0.02),
                Text(
                  "BankAddress".tr,
                  style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                  ),
                ),
                SizedBox(height: h * 0.01),
                commonTextFeild(
                  controller: controller.bankAddressController,
                  hintText: "plEnBankAddressText".tr,
                ),
                SizedBox(height: h * 0.02),
                Text("Country".tr,
                    style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                    )),
                SizedBox(height: h * 0.01),
                commonTextFeild(
                  textStyle: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                  ),
                  controller: controller.countryController,
                  hintText: controller.selectedCountry != null ? controller.selectedCountry?.name : data["Country"],
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
                          textStyle: CommonTextStyle.kWhite15OpenSansSemiBold,
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
                //     style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                //       color: Theme.of(context).brightness == Brightness.dark
                //           ? whiteColor
                //           : blackColor,
                //     )),
                // SizedBox(height: h * 0.01),
                // commonTextFeild(
                //   //  controller: controller.ifscController,
                //   hintText: "plEnIfscCodeText".tr,
                // ),
                SizedBox(height: h * 0.02),
                Text(
                  "IBAN".tr,
                  style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                  ),
                ),
                SizedBox(height: h * 0.01),
                commonTextFeild(
                  controller: controller.ibanController,
                  hintText: "plEnIBANText".tr,
                ),
                SizedBox(height: h * 0.02),
                Text(
                  "BIC".tr,
                  style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                  ),
                ),
                SizedBox(height: h * 0.01),
                commonTextFeild(
                  controller: controller.bicController,
                  hintText: "plEnBICText".tr,
                ),
                SizedBox(height: h * 0.02),
                Text(
                  "PANNumber".tr,
                  style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                  ),
                ),
                SizedBox(height: h * 0.01),
                commonTextFeild(
                  controller: controller.panNumberController,
                  hintText: "plEnPanNumText".tr,
                ),
                SizedBox(height: h * 0.03),
                commonButton(
                  onPressed: () {
                    controller.editPaymentDetail(data["PaymentId"]);
                  },
                  child: Text(
                    "Save".tr,
                    style: CommonTextStyle.kWhite15OpenSansSemiBold,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
