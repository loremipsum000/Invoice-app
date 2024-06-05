import 'dart:developer';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:generate_invoice_app/const/app_color.dart';
import 'package:generate_invoice_app/utils/common_textstyle.dart';
import 'package:generate_invoice_app/widgets/app_buttons.dart';
import 'package:generate_invoice_app/widgets/app_circular.dart';
import 'package:generate_invoice_app/widgets/app_textfeild.dart';
import 'package:generate_invoice_app/widgets/common_appbar.dart';
import 'package:get/get.dart';
import 'controller/edit_profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  EditProfileController editProfileController = Get.put(EditProfileController());

  // Country? selectedCountry;
  // String? countryCode = '';
  var data = Get.arguments;

  @override
  void initState() {
    log("userName===>>>${data["Name"]}");
    editProfileController.fullNameController.text = data["Name"];
    editProfileController.emailController.text = data["Email"];
    editProfileController.phoneController.text = data["PhoneNumber"];
    editProfileController.addressController.text = data["Address"];
    editProfileController.cityController.text = data["City"];
    // editProfileController.countryController.text = data["Country"];
    print("userCountry===>>${data["Country"]}");
    print("userCountryCode===>>${data["CountryCode"]}");
    print("ProfileImage===>>${data["ProfileImage"]}");
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: darkModeScaffoldColor,
      appBar: CommonAppBar(
        leadingIcon: true,
        title: "EditUser".tr,
        //AppString.editUserText,
      ),
      body: GetBuilder<EditProfileController>(builder: (controller) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // AppString.fullNameText,
                  "FullName".tr,
                  style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                  ),
                ),
                SizedBox(height: h * 0.01),
                commonTextFeild(
                  controller: controller.fullNameController,
                  hintText:
                      //AppString.plEnNameText,
                      "PleaseEnterName".tr,
                ),
                SizedBox(height: h * 0.02),
                Text(
                  //AppString.emailText,
                  "Email".tr,
                  style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                  ),
                ),
                SizedBox(height: h * 0.01),
                commonTextFeild(
                  controller: controller.emailController,
                  hintText:
                      //AppString.plEnEmailText,
                      "PleaseEnterEmail".tr,
                ),
                SizedBox(height: h * 0.02),
                Text(
                  //AppString.phoneNumText,
                  "PhoneNumber".tr,
                  style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                  ),
                ),
                SizedBox(height: h * 0.01),
                commonTextFeild(
                  keyboardType: TextInputType.phone,
                  controller: controller.phoneController,
                  hintText: "PleaseEnterPhoneNumber".tr,
                  prefix: Padding(
                    padding: EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.02),
                    child: Text(
                      controller.countryCode!.isEmpty ? "${data["CountryCode"]}" : "${controller.countryCode}",
                      style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: h * 0.02),
                Text(
                  "Address".tr,
                  style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                  ),
                ),
                SizedBox(height: h * 0.01),
                commonTextFeild(
                  controller: controller.addressController,
                  hintText: "PleaseEnterAddress".tr,
                ),
                SizedBox(height: h * 0.02),
                Text(
                  "City".tr,
                  style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                  ),
                ),
                SizedBox(height: h * 0.01),
                commonTextFeild(
                  controller: controller.cityController,
                  hintText: "PleaseEnterCity".tr,
                ),
                SizedBox(height: h * 0.02),
                Text(
                  "Country".tr,
                  style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                  ),
                ),
                SizedBox(height: h * 0.01),
                commonTextFeild(
                    textStyle: CommonTextStyle.kWhite15OpenSansSemiBold,
                    controller: controller.countryController,
                    hintText: controller.selectedCountry != null ? controller.selectedCountry?.name : "${data["Country"]}",
                    // AppString.selectCountryText,
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
                              textStyle: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                                color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                              ),
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
                              //  controller.phoneController.text = controller.countryCode!;
                              print('Select country: ${country.displayName}');
                            }),
                          );
                        },
                        child: Icon(
                          Icons.arrow_drop_down_outlined,
                          color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                        ))),
                SizedBox(height: h * 0.02),
                commonButton(
                  onPressed: () {
                    controller.editProfile();
                  },
                  child: controller.loading == true
                      ? commonCircular()
                      : Text(
                          "Save".tr,
                          style: CommonTextStyle.kWhite15OpenSansSemiBold,
                        ),
                ),
                SizedBox(height: h * 0.02),
              ],
            ),
          ),
        );
      }),
    );
  }
}
