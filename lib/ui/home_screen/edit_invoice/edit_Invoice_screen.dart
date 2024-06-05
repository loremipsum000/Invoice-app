import 'dart:developer';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:generate_invoice_app/const/app_color.dart';
import 'package:generate_invoice_app/utils/common_textstyle.dart';
import 'package:generate_invoice_app/utils/preference_manager.dart';
import 'package:generate_invoice_app/widgets/app_buttons.dart';
import 'package:generate_invoice_app/widgets/app_textfeild.dart';
import 'package:generate_invoice_app/widgets/common_appbar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'controller/edit_invoice_controller.dart';

class EditInvoiceScreen extends StatefulWidget {
  const EditInvoiceScreen({super.key});

  @override
  State<EditInvoiceScreen> createState() => _EditInvoiceScreenState();
}

class _EditInvoiceScreenState extends State<EditInvoiceScreen> {
  EditInvoiceController editInvoiceController = Get.put(EditInvoiceController());
  var data = Get.arguments;

  void initializeContainers() {
    editInvoiceController.listViewContainers.clear();
    for (int i = 0; i < editInvoiceController.descriptionControllers.length; i++) {
      editInvoiceController.listViewContainers.add(addListViewContainer(i, Get.height, Get.width));
    }
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      log("InvoiceIdIDID===>>>${data["InvoiceId"]}");
      await editInvoiceController.getInvoiceData(data["InvoiceId"]);
      editInvoiceController.selectDate = editInvoiceController.invoiceData[0]["DueDate"].toString();
      log("DueDate===>>${editInvoiceController.selectDate}");
      editInvoiceController.vatController.text = editInvoiceController.invoiceData[0]["VAT"];
      editInvoiceController.commentController.text = editInvoiceController.invoiceData[0]["Comment"];

      log("InvoiceItemLength===>>>${editInvoiceController.invoiceData[0]["InvoiceItems"].length}");
      for (int i = 0; i < editInvoiceController.invoiceData[0]["InvoiceItems"].length; i++) {
        editInvoiceController.descriptionControllers.add(TextEditingController());
        editInvoiceController.descriptionControllers[i].text = editInvoiceController.invoiceData[0]["InvoiceItems"][i]["Description"];
        editInvoiceController.quantityControllers.add(TextEditingController());
        editInvoiceController.quantityControllers[i].text = editInvoiceController.invoiceData[0]["InvoiceItems"][i]["Qty"];
        editInvoiceController.rateControllers.add(TextEditingController());
        editInvoiceController.rateControllers[i].text = editInvoiceController.invoiceData[0]["InvoiceItems"][i]["Rate"];
        editInvoiceController.totalAmountControllers.add(TextEditingController());
        editInvoiceController.totalAmountControllers[i].text = editInvoiceController.invoiceData[0]["InvoiceItems"][i]["TotalAmount"];

        log("descriptionData==>>>${editInvoiceController.descriptionControllers[i].text}");
        log("QtyData==>>>${editInvoiceController.quantityControllers[i].text}");
        log("RateData==>>>${editInvoiceController.rateControllers[i].text}");
        log("totalAmountData==>>>${editInvoiceController.totalAmountControllers[i].text}");
      }
      log('Selected Currency Code: ${editInvoiceController.selectedCurrency?.code}');
      initializeContainers();
      setState(() {});
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Color newColor = Theme.of(context).brightness == Brightness.dark ? darkModeBottomBarColor : whiteColor;
    editInvoiceController.updateContainerColor(newColor);
  }

  void updateTotalAmount(int index) {
    double quantity = double.tryParse(editInvoiceController.quantityControllers[index].text) ?? 0.0;
    double rate = double.tryParse(editInvoiceController.rateControllers[index].text) ?? 0.0;
    double totalAmount = quantity * rate;
    // String currencyCode =  editInvoiceController.selectedCurrency?.code ?? '';
    String currencyCode = editInvoiceController.selectedCurrency == null
        ? editInvoiceController.invoiceData[0]["CurrencyCode"]
        : editInvoiceController.selectedCurrency?.code;
    editInvoiceController.totalAmountControllers[index].text = '$currencyCode$totalAmount';
    //'$currencyCode$totalAmount';
    editInvoiceController.symbol = currencyCode;
  }

  @override
  Widget build(BuildContext context) {
    PreferenceManager.setTheme(Theme.of(context).brightness == Brightness.dark);
    log('PreferenceManager.getTheme========>>>>>${PreferenceManager.getTheme()}');
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
        //backgroundColor: darkModeScaffoldColor,
        appBar: CommonAppBar(
          leadingIcon: true,
          title: "EditInvoice".tr,
        ),
        body: GetBuilder<EditInvoiceController>(builder: (controller) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.02),
            child: SingleChildScrollView(
              child: controller.invoiceData.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: h * 0.40),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).brightness == Brightness.dark ? darkModePrimaryColor : lightModePrimaryColor,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: InkResponse(
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                  );
                                  if (pickedDate != null) {
                                    String formatedDate = DateFormat('yMMMd').format(pickedDate);
                                    controller.selectDate = formatedDate;
                                    log("selectDate===>>>${controller.selectDate}");
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
                                      backgroundColor:
                                          Theme.of(context).brightness == Brightness.dark ? darkModeBottomBarColor : whiteColor,
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
                                      for (var controller in editInvoiceController.totalAmountControllers) {
                                        controller.text = editInvoiceController.symbol!;
                                      }
                                      log('Select currency: ${currency.name}');
                                      log('Select currency Code: ${controller.selectedCurrency?.code}');
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
                                          ? "${editInvoiceController.invoiceData[0]["CurrencyCode"]}"
                                          : "${controller.selectedCurrency?.symbol}${controller.selectedCurrency?.name}",
                                      style: CommonTextStyle.kWhite15OpenSansRegular.copyWith(
                                        color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: h * 0.02),
                        // addListViewContainer(1, h, w),
                        SizedBox(
                          height: h * 0.47 * controller.listViewContainers.length.toDouble(),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.listViewContainers.length,
                            itemBuilder: (context, index) {
                              return controller.listViewContainers[index] ?? [];
                            },
                          ),
                        ),
                        SizedBox(height: h * 0.02),
                        commonButton(
                          onPressed: () {
                            setState(() {
                              int newIndex = controller.listViewContainers.length;
                              Color color = Theme.of(context).brightness == Brightness.dark ? darkModeBottomBarColor : whiteColor;
                              controller.listViewContainers.add(addListViewContainer(
                                newIndex,
                                h,
                                w,
                              ));
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
                        commonTextFeild(
                          maxLines: 4,
                          hintText: "CommentHere".tr,
                          controller: controller.commentController,
                        ),
                        SizedBox(height: h * 0.02),
                        controller.loading == true
                            ? Center(
                                child: CircularProgressIndicator(
                                    color: Theme.of(context).brightness == Brightness.dark ? darkModePrimaryColor : lightModePrimaryColor),
                              )
                            : commonButton(
                                onPressed: () {
                                  controller.updateInvoice(data["InvoiceId"]);
                                },
                                child: Text("Save".tr, style: CommonTextStyle.kWhite15OpenSansSemiBold),
                              ),
                      ],
                    ),
            ),
          );
        }));
  }

  Widget addListViewContainer(int index, double h, double w) {
    while (index >= editInvoiceController.descriptionControllers.length) {
      editInvoiceController.add();
    }
    return ValueListenableBuilder<Color>(
      valueListenable: editInvoiceController.containerColor,
      builder: (context, color, child) {
        return Container(
          height: h * 0.45,
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: h * 0.01),
          padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.022),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: lightGreyColor),
          ),
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("$index .", style: CommonTextStyle.kWhite15OpenSansSemiBold),
                      InkResponse(
                          onTap: () {
                            setState(() {
                              editInvoiceController.listViewContainers.removeAt(index - 1); // Adjust index
                            });
                          },
                          child: const Icon(Icons.delete_forever, color: darkModeRedColor))
                    ],
                  ),
                  SizedBox(height: h * 0.01),
                  commonTextFeild(
                    hintText: "Description".tr,
                    //AppString.descText,
                    controller: editInvoiceController.descriptionControllers[index],
                  ),
                  SizedBox(height: h * 0.015),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Quantity".tr,
                          //AppString.quantityText,
                          style: CommonTextStyle.kWhite15OpenSansRegular
                              .copyWith(color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: commonTextFeild(
                          controller: editInvoiceController.quantityControllers[index],
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            updateTotalAmount(index);
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
                          style: CommonTextStyle.kWhite15OpenSansRegular
                              .copyWith(color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: commonTextFeild(
                          controller: editInvoiceController.rateControllers[index],
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            updateTotalAmount(index);
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
                          style: CommonTextStyle.kWhite15OpenSansRegular
                              .copyWith(color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: commonTextFeild(
                          controller: editInvoiceController.totalAmountControllers[index],
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            updateTotalAmount(index);
                          },
                          // hintText: "0.0",
                        ),
                      ),
                    ],
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
