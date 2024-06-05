import 'dart:developer';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:generate_invoice_app/const/app_color.dart';
import 'package:generate_invoice_app/utils/common_textstyle.dart';
import 'package:generate_invoice_app/utils/preference_manager.dart';
import 'package:generate_invoice_app/widgets/app_buttons.dart';
import 'package:generate_invoice_app/widgets/app_snackbar.dart';
import 'package:generate_invoice_app/widgets/app_textfeild.dart';
import 'package:generate_invoice_app/widgets/common_appbar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'controller/create_invoice_controller.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  CreateInvoiceController createInvoiceController = Get.put(CreateInvoiceController());

  // Currency? selectedCurrency;
  // String? symbol = '';
  // List listViewContainers = [];

  var data = Get.arguments;

  @override
  void initState() {
    final h = Get.height;
    final w = Get.width;
    createInvoiceController.listViewContainers.add(addListViewContainer(1, h, w));
    print("ClientId==>>${data["ClientId"]}");
    print("ClientName==>>${data["ClientName"]}");
    // createInvoiceController.add();
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Color newColor = Theme.of(context).brightness == Brightness.dark ? darkModeBottomBarColor : whiteColor;
    createInvoiceController.updateContainerColor(newColor);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      //backgroundColor: darkModeScaffoldColor,
      appBar: CommonAppBar(
        leadingIcon: true,
        title: "CreateInvoice".tr,
      ),
      body: GetBuilder<CreateInvoiceController>(builder: (controller) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.02),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkResponse(
                        onTap: () async {
                          // log('PreferenceManager.getLanguage()==========>>>>>${PreferenceManager.getLanguage()}');
                          // String? languageCode =
                          //     PreferenceManager.getLanguage();
                          // log('DateTime.now()==========>>>>>${DateTime.now()}');
                          // Locale locale = Locale(languageCode ?? 'en', 'US');
                          // DateTime? pickedDate = await showDatePicker(
                          //   context: context,
                          //   // locale: Locale(
                          //   //     PreferenceManager.getLanguage() == 'hr'
                          //   //         ? 'hr'
                          //   //         : 'en'),
                          //   // locale: locale,
                          //   cancelText: "Cancel".tr,
                          //   confirmText: "Ok".tr,
                          //   helpText: "SelectDate".tr,
                          //   fieldHintText: "Date",
                          //   initialDate: DateTime.now(),
                          //   firstDate: DateTime.now(),
                          //   lastDate: DateTime(2100),
                          // );
                          // if (pickedDate != null) {
                          //   String formatedDate =
                          //       DateFormat('yMMMd').format(pickedDate);
                          //   controller.selectDate = formatedDate;
                          //   print("selectDate===>>>${controller.selectDate}");
                          //   setState(() {});
                          // }

                          log('PreferenceManager.getLanguage()==========>>>>>${PreferenceManager.getLanguage()}');
                          String? languageCode = PreferenceManager.getLanguage();
                          Locale locale = Locale(languageCode ?? 'en');
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            locale: locale,
                            cancelText: "Cancel".tr,
                            confirmText: "Ok".tr,
                            helpText: "SelectDate".tr,
                            fieldHintText: "Date",
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            // Formatting date according to locale
                            final dateFormatter = DateFormat.yMMMd(languageCode);
                            String formattedDate = dateFormatter.format(pickedDate);

                            controller.selectDate = formattedDate;
                            print("selectDate===>>>${controller.selectDate}");
                            setState(() {});
                          }
                        },
                        child: Container(
                          height: h * 0.075,
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark ? darkModeBottomBarColor : whiteColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: lightGreyColor),
                          ),
                          child: Center(
                            child: Text(
                              controller.selectDate == null
                                  ? "SelectDueDate".tr
                                  //AppString.selectDueDateText
                                  : "${controller.selectDate}",
                              style: CommonTextStyle.kWhite15OpenSansRegular.copyWith(
                                color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: w * 0.02),
                    Expanded(
                      flex: 1,
                      child: InkResponse(
                        onTap: () async {
                          showCurrencyPicker(
                            context: context,
                            theme: CurrencyPickerThemeData(
                              backgroundColor: Theme.of(context).brightness == Brightness.dark ? darkModeBottomBarColor : whiteColor,
                              flagSize: 25,
                              currencySignTextStyle: CommonTextStyle.kWhite18OpenSansRegular.copyWith(
                                color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                              ),
                              titleTextStyle: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                                color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                              ),
                              subtitleTextStyle: CommonTextStyle.kGrey15OpenSansRegular.copyWith(
                                color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                              ),
                              bottomSheetHeight: MediaQuery.of(context).size.height / 2,
                              inputDecoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: h * 0.025),
                                labelText: 'Search',
                                labelStyle: CommonTextStyle.kGrey15OpenSansRegular.copyWith(
                                  color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                ),
                                hintText: 'Start typing to search',
                                hintStyle: CommonTextStyle.kGrey15OpenSansRegular.copyWith(
                                  color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Theme.of(context).brightness == Brightness.dark ? greyTextColor : blackColor,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: const Color(0xFF8C98A8).withOpacity(0.2),
                                  ),
                                ),
                              ),
                            ),
                            onSelect: (Currency currency) => setState(() {
                              controller.selectedCurrency = currency;
                              controller.symbol = currency.code;
                              for (var controller in createInvoiceController.totalAmountControllers) {
                                controller.text = createInvoiceController.symbol!;
                              }
                              print('Select currency: ${currency.name}');
                              print('Select currency Code: ${controller.selectedCurrency?.code}');
                            }),
                          );
                        },
                        child: Container(
                          height: h * 0.075,
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark ? darkModeBottomBarColor : whiteColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: lightGreyColor),
                          ),
                          child: Center(
                            child: Text(
                              controller.selectedCurrency == null
                                  ? "SelectCurrency".tr
                                  //AppString.selectCurrencyText
                                  : "${controller.selectedCurrency?.symbol}${controller.selectedCurrency?.name}",
                              style: CommonTextStyle.kWhite15OpenSansRegular
                                  .copyWith(color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h * 0.02),
                //addListViewContainer(1, h, w),
                SizedBox(
                  height: h * 0.47 * controller.listViewContainers.length.toDouble(),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.listViewContainers.length,
                    itemBuilder: (context, index) {
                      return controller.listViewContainers[index];
                    },
                  ),
                ),
                // SizedBox(
                //   height: h * 0.47 * listViewContainers.length.toDouble(),
                //   child: ListView.builder(
                //     physics: const NeverScrollableScrollPhysics(),
                //     itemCount: listViewContainers.length,
                //     //1,
                //     itemBuilder: (context, index) {
                //       if (index == 0) {
                //         return Container(
                //           height: h * 0.45,
                //           width: double.infinity,
                //           margin: EdgeInsets.symmetric(vertical: h * 0.01),
                //           padding: EdgeInsets.symmetric(
                //               horizontal: w * 0.03, vertical: h * 0.022),
                //           decoration: BoxDecoration(
                //               color: bottomBarColor,
                //               borderRadius: BorderRadius.circular(10),
                //               border: Border.all(color: lightGreyColor)),
                //           child: Column(
                //             children: [
                //               Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: [
                //                   Text("1.",
                //                       style: CommonTextStyle
                //                           .kWhite15OpenSansSemiBold),
                //                   InkResponse(
                //                     onTap: () {
                //                       listViewContainers.removeAt(index);
                //                     },
                //                     child: const Icon(Icons.delete_forever,
                //                         color: redColor),
                //                   )
                //                 ],
                //               ),
                //               SizedBox(height: h * 0.01),
                //               commonTextFeild(
                //                   hintText: AppString.descText,
                //                   controller: controller.descriptionController),
                //               SizedBox(height: h * 0.015),
                //               Row(
                //                 children: [
                //                   Expanded(
                //                       flex: 1,
                //                       child: Text(AppString.quantityText,
                //                           style: CommonTextStyle
                //                               .kWhite15OpenSansRegular)),
                //                   Expanded(
                //                     flex: 1,
                //                     child: commonTextFeild(
                //                       controller: controller.quantityController,
                //                       keyboardType: TextInputType.phone,
                //                       // hintText: "0.0",
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //               SizedBox(height: h * 0.015),
                //               Row(
                //                 children: [
                //                   Expanded(
                //                       flex: 1,
                //                       child: Text(AppString.rateText,
                //                           style: CommonTextStyle
                //                               .kWhite15OpenSansRegular)),
                //                   Expanded(
                //                     flex: 1,
                //                     child: commonTextFeild(
                //                       controller: controller.rateController,
                //                       keyboardType: TextInputType.phone,
                //                       // hintText: "0.0",
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //               SizedBox(height: h * 0.015),
                //               Row(
                //                 children: [
                //                   Expanded(
                //                       flex: 1,
                //                       child: Text(AppString.amountText,
                //                           style: CommonTextStyle
                //                               .kWhite15OpenSansRegular)),
                //                   Expanded(
                //                     flex: 1,
                //                     child: commonTextFeild(
                //                       controller:
                //                           controller.totalAmountController,
                //                       keyboardType: TextInputType.phone,
                //                       // hintText: "0.0",
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ],
                //           ),
                //         );
                //       }
                //       return addListViewContainer(index, h, w);
                //     },
                //   ),
                // ),
                SizedBox(height: h * 0.02),
                commonButton(
                  onPressed: () {
                    setState(() {
                      int newIndex = controller.listViewContainers.length + 1;
                      controller.listViewContainers.add(addListViewContainer(newIndex, h, w));
                    });
                  },
                  child: Text("AddNewItem".tr,
                      //AppString.addNewItemText,
                      style: CommonTextStyle.kWhite15OpenSansSemiBold),
                ),
                SizedBox(height: h * 0.02),
                commonTextFeild(
                  hintText: "EnterVAT".tr,
                  keyboardType: TextInputType.phone,
                  controller: controller.vatController,
                ),
                SizedBox(height: h * 0.02),
                commonTextFeild(maxLines: 4, hintText: "CommentHere".tr, controller: controller.commentController),
                SizedBox(height: h * 0.02),
                commonButton(
                  onPressed: () {
                    if (controller.selectDate == null) {
                      appSnackBar(message: "Select Due Date");
                    } else {
                      controller.createInvoice(data["ClientId"], data["ClientName"], data["ClientCity"]);
                    }
                  },
                  child: Text("Save".tr,
                      //AppString.saveText,
                      style: CommonTextStyle.kWhite15OpenSansSemiBold),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget addListViewContainer(int index, double h, double w) {
    //final createInvoiceController = Get.find<CreateInvoiceController>();
    //createInvoiceController.add();
    while (index >= createInvoiceController.descriptionControllers.length) {
      createInvoiceController.add();
    }
    return ValueListenableBuilder<Color>(
      valueListenable: createInvoiceController.containerColor,
      builder: (context, color, child) {
        return Container(
          height: h * 0.45,
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: h * 0.01),
          padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.022),
          decoration: BoxDecoration(
              color: Theme.of(Get.context!).brightness == Brightness.dark ? darkModeBottomBarColor : whiteColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: lightGreyColor)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$index.",
                    style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                      color: Theme.of(Get.context!).brightness == Brightness.dark ? whiteColor : blackColor,
                    ),
                  ),
                  InkResponse(
                      onTap: () {
                        setState(() {
                          createInvoiceController.listViewContainers.removeAt(index - 1); // Adjust index
                        });
                      },
                      child: const Icon(Icons.delete_forever, color: darkModeRedColor))
                ],
              ),
              SizedBox(height: h * 0.01),
              commonTextFeild(
                hintText: "Description".tr,
                //AppString.descText,
                controller: createInvoiceController.descriptionControllers[index],
              ),
              SizedBox(height: h * 0.015),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Quantity".tr,
                      //AppString.quantityText,
                      style: CommonTextStyle.kWhite15OpenSansRegular.copyWith(
                        color: Theme.of(Get.context!).brightness == Brightness.dark ? whiteColor : blackColor,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: commonTextFeild(
                      controller: createInvoiceController.quantityControllers[index],
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        createInvoiceController.updateTotalAmount(index);
                      },
                      // hintText: "0.0",
                    ),
                  ),
                ],
              ),
              SizedBox(height: h * 0.015),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Text(
                        "Rate".tr,
                        //AppString.rateText,
                        style: CommonTextStyle.kWhite15OpenSansRegular.copyWith(
                          color: Theme.of(Get.context!).brightness == Brightness.dark ? whiteColor : blackColor,
                        ),
                      )),
                  Expanded(
                    flex: 1,
                    child: commonTextFeild(
                      controller: createInvoiceController.rateControllers[index],
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        createInvoiceController.updateTotalAmount(index);
                      },
                      // hintText: "0.0",
                    ),
                  ),
                ],
              ),
              SizedBox(height: h * 0.015),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Amount".tr,
                      //AppString.amountText,
                      style: CommonTextStyle.kWhite15OpenSansRegular.copyWith(
                        color: Theme.of(Get.context!).brightness == Brightness.dark ? whiteColor : blackColor,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: commonTextFeild(
                      controller: createInvoiceController.totalAmountControllers[index],
                      keyboardType: TextInputType.phone,
                      // hintText: "0.0",
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
