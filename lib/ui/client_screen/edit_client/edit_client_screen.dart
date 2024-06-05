import 'dart:developer';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generate_invoice_app/const/app_color.dart';
import 'package:generate_invoice_app/utils/common_textstyle.dart';
import 'package:generate_invoice_app/widgets/app_buttons.dart';
import 'package:generate_invoice_app/widgets/app_circular.dart';
import 'package:generate_invoice_app/widgets/app_textfeild.dart';
import 'package:generate_invoice_app/widgets/common_appbar.dart';
import 'package:get/get.dart';
import 'controller/edit_client_controller.dart';

class EditClientScreen extends StatefulWidget {
  const EditClientScreen({super.key});

  @override
  State<EditClientScreen> createState() => _EditClientScreenState();
}

class _EditClientScreenState extends State<EditClientScreen> {
  EditClientController editClientController = Get.put(EditClientController());
  var data = Get.arguments;

  @override
  void initState() {
    log("clientId==>>>${data["ClientId"]}");
    editClientController.fullNameController.text = data["ClientName"];
    editClientController.emailController.text = data["ClientEmail"];
    editClientController.phoneController.text = data["ClientPhoneNo"];
    editClientController.addressController.text = data["ClientAddress"];
    editClientController.cityController.text = data["ClientCity"];
    editClientController.descriptionController.text = data["ClientDesc"];
    //  editClientController.selectedCountry = data["ClientCountry"];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      //backgroundColor: darkModeScaffoldColor,
      appBar: CommonAppBar(
        leadingIcon: true,
        title: "EditClient".tr,
      ),
      body: GetBuilder<EditClientController>(builder: (controller) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.03),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h * 0.02),
                Text(
                    //AppString.fullNameText,
                    "FullName".tr,
                    style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                    )),
                SizedBox(height: h * 0.01),
                commonTextFeild(
                  controller: controller.fullNameController,
                  hintText: "PleaseEnterName".tr,
                ),
                SizedBox(height: h * 0.02),
                Text("Email".tr,
                    style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                    )),
                SizedBox(height: h * 0.01),
                commonTextFeild(
                  controller: controller.emailController,
                  hintText: "PleaseEnterEmail".tr,
                ),
                SizedBox(height: h * 0.02),
                Text("PhoneNumber".tr,
                    style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                    )),
                SizedBox(height: h * 0.01),
                commonTextFeild(
                  input: [LengthLimitingTextInputFormatter(10)],
                  keyboardType: TextInputType.phone,
                  controller: controller.phoneController,
                  hintText: "PleaseEnterPhoneNumber".tr,
                  prefix: Padding(
                    padding: EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.02),
                    child: Text(controller.countryCode!.isEmpty ? "${data["ClientCountryCode"]}" : "${controller.countryCode}",
                        style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                        )),
                  ),
                ),
                SizedBox(height: h * 0.02),
                Text("Address".tr,
                    style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                    )),
                SizedBox(height: h * 0.01),
                commonTextFeild(
                  controller: controller.addressController,
                  hintText: "PleaseEnterAddress".tr,
                ),
                SizedBox(height: h * 0.02),
                Text("City".tr,
                    style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                    )),
                SizedBox(height: h * 0.01),
                commonTextFeild(
                  controller: controller.cityController,
                  hintText: "PleaseEnterCity".tr,
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
                    hintText: controller.selectedCountry != null ? controller.selectedCountry?.name : data["ClientCountry"],
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
                        ))),
                SizedBox(height: h * 0.02),
                Text("Description".tr,
                    style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                    )),
                SizedBox(height: h * 0.01),
                commonTextFeild(
                  maxLines: 4,
                  verticalPadding: h * 0.01,
                  controller: controller.descriptionController,
                  hintText: "PleaseEnterDescription".tr,
                ),
                SizedBox(height: h * 0.02),
                commonButton(
                  onPressed: () {
                    // Get.back();
                    controller.editClient(data["ClientId"]);
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
