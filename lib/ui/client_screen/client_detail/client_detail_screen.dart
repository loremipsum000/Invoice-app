import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:generate_invoice_app/const/app_color.dart';
import 'package:generate_invoice_app/const/app_image.dart';
import 'package:generate_invoice_app/utils/app_routes.dart';
import 'package:generate_invoice_app/utils/common_textstyle.dart';
import 'package:generate_invoice_app/utils/preference_manager.dart';
import 'package:generate_invoice_app/utils/stripe_payment_controller.dart';
import 'package:generate_invoice_app/widgets/app_buttons.dart';
import 'package:generate_invoice_app/widgets/app_snackbar.dart';
import 'package:generate_invoice_app/widgets/common_appbar.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'controller/client_detail_controller.dart';

class ClientDetailScreen extends StatefulWidget {
  const ClientDetailScreen({super.key});

  @override
  State<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<ClientDetailScreen> {
  StripePaymentController stripePaymentController = Get.put(StripePaymentController());
  ClientDetailController clientDetailController = Get.put(ClientDetailController());
  var data = Get.arguments;

  @override
  void initState() {
    log("ClientId==>>${data["ClientId"]}");
    log("ClientEmail==>>${data["ClientEmail"]}");
    log("addPaymentDetail==>>${PreferenceManager.getAddPaymentDetail()}");
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery
        .of(context)
        .size
        .height;
    final w = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      // backgroundColor: darkModeScaffoldColor,
      appBar: CommonAppBar(
        leadingIcon: true,
        title: "${data["ClientName"]}",
        action: true,
        actionWidget: Padding(
          padding: EdgeInsets.only(right: w * 0.02),
          child: InkResponse(
            onTap: () {
              deleteClientDialog(context);
            },
            child: const Icon(
              Icons.delete_outline,
              color: darkModeRedColor,
            ),
          ),
        ),
      ),
      body: GetBuilder<ClientDetailController>(builder: (controller) {
        return GetBuilder<StripePaymentController>(
          builder: (paymentController) {
            return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("Clients").where("Email", isEqualTo: data["ClientEmail"]).snapshots(),
                builder: (context, snapshot1) {
                  var clientData = snapshot1.data?.docs;
                  if (snapshot1.hasData) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.02),
                      child: Column(
                        children: [
                          InkResponse(
                            onTap: () {
                              Get.toNamed(Routes.editClient, arguments: {
                                "ClientId": snapshot1.data?.docs[0].id,
                                "ClientName": clientData?[0]["FullName"],
                                "ClientEmail": clientData?[0]["Email"],
                                "ClientCountryCode": clientData?[0]["CountryCode"],
                                "ClientPhoneNo": clientData?[0]["PhoneNumber"],
                                "ClientAddress": clientData?[0]["Address"],
                                "ClientCity": clientData?[0]["City"],
                                "ClientCountry": clientData?[0]["Country"],
                                "ClientDesc": clientData?[0]["Description"],
                              });
                            },
                            child: Container(
                              //  height: h * 0.26,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Theme
                                      .of(context)
                                      .brightness == Brightness.dark ? darkModeBottomBarColor : whiteColor,
                                  border: Border.all(color: lightGreyColor),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: h * 0.02),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                        backgroundColor:
                                        Theme
                                            .of(context)
                                            .brightness == Brightness.dark ? darkWhiteColor : lightModeGreyColor,
                                        radius: 35,
                                        backgroundImage: const AssetImage(AppImage.personImage)),
                                    Divider(
                                      color: Theme
                                          .of(context)
                                          .brightness == Brightness.dark ? darkWhiteColor : lightGreyColor,
                                      height: h * 0.03,
                                    ),
                                    Center(
                                        child: Text(
                                          //"Shreya",
                                          "${clientData?[0]["FullName"]}",
                                          style: CommonTextStyle.kWhite15OpenSansRegular.copyWith(
                                            color: Theme
                                                .of(context)
                                                .brightness == Brightness.dark ? whiteColor : blackColor,
                                          ),
                                        )),
                                    Divider(
                                        color: Theme
                                            .of(context)
                                            .brightness == Brightness.dark ? darkWhiteColor : lightGreyColor,
                                        height: h * 0.03),
                                    Center(
                                        child: Text(
                                          //"shreyachovatiya171@gmail.com",
                                          "${clientData?[0]["Email"]}",
                                          style: CommonTextStyle.kWhite15OpenSansRegular
                                              .copyWith(color: Theme
                                              .of(context)
                                              .brightness == Brightness.dark ? whiteColor : blackColor),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: h * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("RecentInvoice".tr,
                                  style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                                    color: Theme
                                        .of(context)
                                        .brightness == Brightness.dark ? whiteColor : blackColor,
                                  )),
                              InkResponse(
                                  onTap: () async {
                                    PreferenceManager.getAddPaymentDetail() == "Yes"
                                        ? Get.toNamed(Routes.createInvoice, arguments: {
                                      "ClientId": clientData?[0]["ClientId"],
                                      "ClientName": clientData?[0]["FullName"],
                                      "ClientCity": clientData?[0]["City"]
                                    })
                                        : showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: Theme
                                                .of(context)
                                                .brightness == Brightness.dark ? blackColor : whiteColor,
                                            title: Text(
                                              // AppString.plAddBankDeatilText,
                                                "PleaseAddYourBankDetails".tr,
                                                style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                                                  color: Theme
                                                      .of(context)
                                                      .brightness == Brightness.dark ? whiteColor : blackColor,
                                                )),
                                            actions: [
                                              commonButton(
                                                onPressed: () {
                                                  Get.toNamed(Routes.paymentDetail);
                                                },
                                                child: Text("Ok, Sure", style: CommonTextStyle.kWhite15OpenSansSemiBold),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: Icon(Icons.add, color: Theme
                                      .of(context)
                                      .brightness == Brightness.dark ? whiteColor : blackColor))
                            ],
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("GenerateInvoice")
                                  .where("ClientId", isEqualTo: clientData?[0]["ClientId"])
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Expanded(
                                    child: snapshot.data!.docs.isEmpty
                                        ? Lottie.asset(
                                        repeat: false, "assets/animation/lottie/empty_box.json", height: h * 0.45, width: h * 0.45)
                                        : ListView.builder(
                                      itemCount: snapshot.data?.docs.length,
                                      itemBuilder: (context, index) {
                                        var invoiceData = snapshot.data?.docs;
                                        log("lengthOfInvoice===>>>${snapshot.data?.docs.length}");
                                        // log("InvoiceData===>>>${invoiceData?[index]["InvoiceItems"][index]["Description"]}");
                                        var items = invoiceData?[index]["InvoiceItems"];
                                        double totalSum = 0.0;
                                        for (var item in items) {
                                          String totalAmountString = item["TotalAmount"];
                                          double totalAmount = double.parse(
                                            totalAmountString.replaceAll(RegExp(r'[^0-9.]'), ''),
                                          );
                                          totalSum += totalAmount;
                                        }
                                        String formattedTotalSum = totalSum.toStringAsFixed(5);
                                        return InkResponse(
                                          onTap: () {
                                            Get.toNamed(Routes.editInvoice, arguments: {
                                              "InvoiceId": invoiceData?[index]["InvoiceId"],
                                            });
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.symmetric(vertical: h * 0.01),
                                            decoration: BoxDecoration(
                                                color: Theme
                                                    .of(context)
                                                    .brightness == Brightness.dark
                                                    ? darkModeBottomBarColor
                                                    : whiteColor,
                                                border: Border.all(color: lightGreyColor),
                                                borderRadius: BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: h * 0.02),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          "# ${invoiceData?[index]["InvoiceId"]}",
                                                          style: CommonTextStyle.kWhite15OpenSansRegular.copyWith(
                                                            color: Theme
                                                                .of(context)
                                                                .brightness == Brightness.dark
                                                                ? whiteColor
                                                                : blackColor,
                                                          ),
                                                        ),
                                                        StreamBuilder<QuerySnapshot>(
                                                            stream: FirebaseFirestore.instance
                                                                .collection("PaymentDetail")
                                                                .where("UserId", isEqualTo: PreferenceManager.getUserId())
                                                                .snapshots(),
                                                            builder: (context, snapshot) {
                                                              if (snapshot.hasData) {
                                                                var paymentDetailData = snapshot.data?.docs;
                                                                return PopupMenuButton(
                                                                  onOpened: () {
                                                                    invoiceData?[index]["InvoiceId"];
                                                                  },
                                                                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                                                  constraints: BoxConstraints(maxHeight: h * 0.35),
                                                                  color: Theme
                                                                      .of(Get.context!)
                                                                      .brightness == Brightness.dark
                                                                      ? greyPopUpColor
                                                                      : whiteColor,
                                                                  offset: const Offset(10, 0),
                                                                  position: PopupMenuPosition.over,
                                                                  itemBuilder: (BuildContext context) {
                                                                    return [
                                                                      PopupMenuItem(
                                                                        padding: const EdgeInsets.all(0),
                                                                        child: Padding(
                                                                          padding: EdgeInsets.symmetric(vertical: h * 0.02),
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              InkResponse(
                                                                                onTap: () async {
                                                                                  Get.back();

                                                                                  if (invoiceData?[index]["PaymentStatus"] ==
                                                                                      "Paid") {
                                                                                    Directory? directory =
                                                                                    await getExternalStorageDirectory();
                                                                                    if (directory != null) {
                                                                                      String filePath =
                                                                                          '${directory.path}/GenerateInvoice${DateTime
                                                                                          .now()
                                                                                          .millisecond}.pdf';
                                                                                      log('directory.path==========>>>>>${directory.path}');
                                                                                      final pdfBytes = await controller.generatePdf(
                                                                                        invoiceId: invoiceData?[index]["InvoiceId"],
                                                                                        clientName: invoiceData?[index]["ClientName"],
                                                                                        clientCity: invoiceData?[index]["ClientCity"],
                                                                                        invoiceDate: invoiceData?[index]
                                                                                        ["InvoiceDate"],
                                                                                        dueDate: invoiceData?[index]["DueDate"],
                                                                                        length: invoiceData?[index]["InvoiceItems"]
                                                                                            .length,
                                                                                        totalAmount:
                                                                                        "${invoiceData?[index]["CurrencyCode"]}$formattedTotalSum",
                                                                                        vat: invoiceData?[index]["VAT"],
                                                                                        totalPayable: formattedTotalSum +
                                                                                            invoiceData?[index]["VAT"],
                                                                                        accountNumber: paymentDetailData?[0]
                                                                                        ["AccountNumber"],
                                                                                        accountHolder:
                                                                                        "${paymentDetailData?[0]["FirstName"]} ${paymentDetailData?[0]["LastName"]}",
                                                                                        iban: paymentDetailData?[0]["IBAN"],
                                                                                        bic: paymentDetailData?[0]["BIC"],
                                                                                        panNumber: paymentDetailData?[0]["PanNumber"],
                                                                                        paymentLink: stripePaymentController
                                                                                            .linkData.isNotEmpty
                                                                                            ? stripePaymentController.linkData['url']
                                                                                            : '',
                                                                                        listViewBuilder: () {
                                                                                          return pw.Column(
                                                                                            mainAxisAlignment:
                                                                                            pw.MainAxisAlignment.center,
                                                                                            children: [
                                                                                              pw.ListView.builder(
                                                                                                itemCount: invoiceData?[index]
                                                                                                ["InvoiceItems"]
                                                                                                    .length,
                                                                                                itemBuilder: (context, index1) {
                                                                                                  return pw.Row(
                                                                                                    children: [
                                                                                                      pw.Expanded(
                                                                                                        flex: 1,
                                                                                                        child: pw.Container(
                                                                                                          height: h * 0.06,
                                                                                                          decoration:
                                                                                                          pw.BoxDecoration(
                                                                                                            border: pw.Border.all(
                                                                                                                color:
                                                                                                                PdfColors.black),
                                                                                                          ),
                                                                                                          child: pw.Center(
                                                                                                              child: pw.Text(
                                                                                                                //"Description",
                                                                                                                  "${invoiceData?[index]["InvoiceItems"][index1]["Description"]}",
                                                                                                                  style: pw.TextStyle(
                                                                                                                      fontBold: pw
                                                                                                                          .Font
                                                                                                                          .courierBoldOblique()))),
                                                                                                        ),
                                                                                                      ),
                                                                                                      pw.Expanded(
                                                                                                        flex: 1,
                                                                                                        child: pw.Container(
                                                                                                          height: h * 0.06,
                                                                                                          decoration:
                                                                                                          pw.BoxDecoration(
                                                                                                            border: pw.Border.all(
                                                                                                                color:
                                                                                                                PdfColors.black),
                                                                                                          ),
                                                                                                          child: pw.Center(
                                                                                                            child: pw.Text(
                                                                                                              //"Quantity",
                                                                                                                "${invoiceData?[index]["InvoiceItems"][index1]["Qty"]}",
                                                                                                                style: pw.TextStyle(
                                                                                                                    fontBold: pw.Font
                                                                                                                        .courierBoldOblique())),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                      pw.Expanded(
                                                                                                        flex: 1,
                                                                                                        child: pw.Container(
                                                                                                          height: h * 0.06,
                                                                                                          decoration:
                                                                                                          pw.BoxDecoration(
                                                                                                            border: pw.Border.all(
                                                                                                                color:
                                                                                                                PdfColors.black),
                                                                                                          ),
                                                                                                          child: pw.Center(
                                                                                                              child: pw.Text(
                                                                                                                //"Rate",
                                                                                                                  "${invoiceData?[index]["InvoiceItems"][index1]["Rate"]}",
                                                                                                                  style: pw.TextStyle(
                                                                                                                      fontBold: pw
                                                                                                                          .Font
                                                                                                                          .courierBoldOblique()))),
                                                                                                        ),
                                                                                                      ),
                                                                                                      pw.Expanded(
                                                                                                        flex: 1,
                                                                                                        child: pw.Container(
                                                                                                          height: h * 0.06,
                                                                                                          decoration:
                                                                                                          pw.BoxDecoration(
                                                                                                            border: pw.Border.all(
                                                                                                                color:
                                                                                                                PdfColors.black),
                                                                                                          ),
                                                                                                          child: pw.Center(
                                                                                                              child: pw.Text(
                                                                                                                //"Amount",
                                                                                                                  "${invoiceData?[index]["InvoiceItems"][index1]["TotalAmount"]}",
                                                                                                                  style: pw.TextStyle(
                                                                                                                      fontBold: pw
                                                                                                                          .Font
                                                                                                                          .courierBoldOblique()))),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  );
                                                                                                },
                                                                                              )
                                                                                            ],
                                                                                          );
                                                                                        },
                                                                                      );
                                                                                      File file = File(filePath);
                                                                                      await file.writeAsBytes(pdfBytes);
                                                                                      appSnackBar(
                                                                                          message: "Successfully downloaded the PDF",
                                                                                          color: Colors.green,
                                                                                          style: CommonTextStyle
                                                                                              .kBlack15OpenSansRegular
                                                                                              .copyWith(
                                                                                              color: Theme
                                                                                                  .of(Get.context!)
                                                                                                  .brightness ==
                                                                                                  Brightness.dark
                                                                                                  ? blackColor
                                                                                                  : whiteColor));
                                                                                    } else {
                                                                                      appSnackBar(
                                                                                          message:
                                                                                          "Error: Unable to get directory for downloading PDF");
                                                                                    }
                                                                                  } else {
                                                                                    /// Generate Payment Link
                                                                                    await paymentController
                                                                                        .createPriceId(
                                                                                      currency:
                                                                                      "${invoiceData?[index]["CurrencyCode"] ?? 'IND'}",
                                                                                      amount: formattedTotalSum,
                                                                                      // "50.55",
                                                                                      recurringInterval: "month",
                                                                                      name: invoiceData?[index]["ClientName"] ?? '',
                                                                                      invoiceId: invoiceData?[index].id ?? '',
                                                                                    )
                                                                                        .then((value1) async {
                                                                                      Directory? directory =
                                                                                      await getExternalStorageDirectory();
                                                                                      if (directory != null) {
                                                                                        String filePath =
                                                                                            '${directory.path}/GenerateInvoice${DateTime
                                                                                            .now()
                                                                                            .millisecond}.pdf';
                                                                                        log('directory.path==========>>>>>${directory
                                                                                            .path}');
                                                                                        final pdfBytes = await controller.generatePdf(
                                                                                          invoiceId: invoiceData?[index]["InvoiceId"],
                                                                                          clientName: invoiceData?[index]
                                                                                          ["ClientName"],
                                                                                          clientCity: invoiceData?[index]
                                                                                          ["ClientCity"],
                                                                                          invoiceDate: invoiceData?[index]
                                                                                          ["InvoiceDate"],
                                                                                          dueDate: invoiceData?[index]["DueDate"],
                                                                                          length: invoiceData?[index]["InvoiceItems"]
                                                                                              .length,
                                                                                          totalAmount:
                                                                                          "${invoiceData?[index]["CurrencyCode"]}$formattedTotalSum",
                                                                                          vat: invoiceData?[index]["VAT"],
                                                                                          totalPayable: formattedTotalSum +
                                                                                              invoiceData?[index]["VAT"],
                                                                                          accountNumber: paymentDetailData?[0]
                                                                                          ["AccountNumber"],
                                                                                          accountHolder:
                                                                                          "${paymentDetailData?[0]["FirstName"]} ${paymentDetailData?[0]["LastName"]}",
                                                                                          iban: paymentDetailData?[0]["IBAN"],
                                                                                          bic: paymentDetailData?[0]["BIC"],
                                                                                          panNumber: paymentDetailData?[0]
                                                                                          ["PanNumber"],
                                                                                          paymentLink: stripePaymentController
                                                                                              .linkData.isNotEmpty
                                                                                              ? stripePaymentController
                                                                                              .linkData['url']
                                                                                              : '',
                                                                                          listViewBuilder: () {
                                                                                            return pw.Column(
                                                                                              mainAxisAlignment:
                                                                                              pw.MainAxisAlignment.center,
                                                                                              children: [
                                                                                                pw.ListView.builder(
                                                                                                  itemCount: invoiceData?[index]
                                                                                                  ["InvoiceItems"]
                                                                                                      .length,
                                                                                                  itemBuilder: (context, index1) {
                                                                                                    return pw.Row(children: [
                                                                                                      pw.Expanded(
                                                                                                        flex: 1,
                                                                                                        child: pw.Container(
                                                                                                          height: h * 0.06,
                                                                                                          decoration:
                                                                                                          pw.BoxDecoration(
                                                                                                            border: pw.Border.all(
                                                                                                                color:
                                                                                                                PdfColors.black),
                                                                                                          ),
                                                                                                          child: pw.Center(
                                                                                                              child: pw.Text(
                                                                                                                //"Description",
                                                                                                                  "${invoiceData?[index]["InvoiceItems"][index1]["Description"]}",
                                                                                                                  style: pw.TextStyle(
                                                                                                                      fontBold: pw
                                                                                                                          .Font
                                                                                                                          .courierBoldOblique()))),
                                                                                                        ),
                                                                                                      ),
                                                                                                      pw.Expanded(
                                                                                                        flex: 1,
                                                                                                        child: pw.Container(
                                                                                                          height: h * 0.06,
                                                                                                          decoration:
                                                                                                          pw.BoxDecoration(
                                                                                                            border: pw.Border.all(
                                                                                                                color:
                                                                                                                PdfColors.black),
                                                                                                          ),
                                                                                                          child: pw.Center(
                                                                                                            child: pw.Text(
                                                                                                              //"Quantity",
                                                                                                                "${invoiceData?[index]["InvoiceItems"][index1]["Qty"]}",
                                                                                                                style: pw.TextStyle(
                                                                                                                    fontBold: pw.Font
                                                                                                                        .courierBoldOblique())),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                      pw.Expanded(
                                                                                                        flex: 1,
                                                                                                        child: pw.Container(
                                                                                                          height: h * 0.06,
                                                                                                          decoration:
                                                                                                          pw.BoxDecoration(
                                                                                                            border: pw.Border.all(
                                                                                                                color:
                                                                                                                PdfColors.black),
                                                                                                          ),
                                                                                                          child: pw.Center(
                                                                                                              child: pw.Text(
                                                                                                                //"Rate",
                                                                                                                  "${invoiceData?[index]["InvoiceItems"][index1]["Rate"]}",
                                                                                                                  style: pw.TextStyle(
                                                                                                                      fontBold: pw
                                                                                                                          .Font
                                                                                                                          .courierBoldOblique()))),
                                                                                                        ),
                                                                                                      ),
                                                                                                      pw.Expanded(
                                                                                                        flex: 1,
                                                                                                        child: pw.Container(
                                                                                                          height: h * 0.06,
                                                                                                          decoration:
                                                                                                          pw.BoxDecoration(
                                                                                                            border: pw.Border.all(
                                                                                                                color:
                                                                                                                PdfColors.black),
                                                                                                          ),
                                                                                                          child: pw.Center(
                                                                                                              child: pw.Text(
                                                                                                                //"Amount",
                                                                                                                  "${invoiceData?[index]["InvoiceItems"][index1]["TotalAmount"]}",
                                                                                                                  style: pw.TextStyle(
                                                                                                                      fontBold: pw
                                                                                                                          .Font
                                                                                                                          .courierBoldOblique()))),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ]);
                                                                                                  },
                                                                                                )
                                                                                              ],
                                                                                            );
                                                                                          },
                                                                                        );
                                                                                        File file = File(filePath);
                                                                                        await file.writeAsBytes(pdfBytes);
                                                                                        appSnackBar(
                                                                                            message:
                                                                                            "Successfully downloaded the PDF",
                                                                                            color: Colors.green,
                                                                                            style: CommonTextStyle
                                                                                                .kBlack15OpenSansRegular
                                                                                                .copyWith(
                                                                                                color: Theme
                                                                                                    .of(Get.context!)
                                                                                                    .brightness ==
                                                                                                    Brightness.dark
                                                                                                    ? blackColor
                                                                                                    : whiteColor));
                                                                                      } else {
                                                                                        appSnackBar(
                                                                                            message:
                                                                                            "Error: Unable to get directory for downloading PDF");
                                                                                      }
                                                                                    });
                                                                                  }
                                                                                },
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.only(left: w * 0.03),
                                                                                  child: Text("Download",
                                                                                      style: CommonTextStyle.kWhite15OpenSansRegular
                                                                                          .copyWith(
                                                                                          color: Theme
                                                                                              .of(context)
                                                                                              .brightness ==
                                                                                              Brightness.dark
                                                                                              ? whiteColor
                                                                                              : blackColor)),
                                                                                ),
                                                                              ),
                                                                              invoiceData?[index]["PaymentStatus"] == "Paid"
                                                                                  ? const SizedBox()
                                                                                  : Divider(
                                                                                color: greyColor,
                                                                                height: h * 0.05,
                                                                              ),
                                                                              invoiceData?[index]["PaymentStatus"] == "Paid"
                                                                                  ? const SizedBox()
                                                                                  : InkResponse(
                                                                                onTap: () {
                                                                                  Get.back();
                                                                                  FirebaseFirestore.instance
                                                                                      .collection("GenerateInvoice")
                                                                                      .doc(invoiceData?[index]["InvoiceId"])
                                                                                      .update({
                                                                                    "PaymentStatus": "Paid",
                                                                                  });
                                                                                },
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.only(left: w * 0.03),
                                                                                  child: Text("Mark as paid",
                                                                                      style: CommonTextStyle
                                                                                          .kWhite15OpenSansRegular
                                                                                          .copyWith(
                                                                                          color: Theme
                                                                                              .of(context)
                                                                                              .brightness ==
                                                                                              Brightness.dark
                                                                                              ? whiteColor
                                                                                              : blackColor)),
                                                                                ),
                                                                              ),
                                                                              Divider(color: greyColor, height: h * 0.05),
                                                                              InkResponse(
                                                                                onTap: () async {
                                                                                  Get.back();
                                                                                  if (invoiceData?[index]["PaymentStatus"] ==
                                                                                      "Paid") {
                                                                                    final pdf = await controller.generatePdf(
                                                                                      invoiceId: invoiceData?[index]["InvoiceId"],
                                                                                      clientName: invoiceData?[index]["ClientName"],
                                                                                      clientCity: invoiceData?[index]["ClientCity"],
                                                                                      invoiceDate: invoiceData?[index]["InvoiceDate"],
                                                                                      dueDate: invoiceData?[index]["DueDate"],
                                                                                      length:
                                                                                      invoiceData?[index]["InvoiceItems"].length,
                                                                                      totalAmount:
                                                                                      "${invoiceData?[index]["CurrencyCode"]}$formattedTotalSum",
                                                                                      vat: invoiceData?[index]["VAT"],
                                                                                      totalPayable: formattedTotalSum +
                                                                                          invoiceData?[index]["VAT"],
                                                                                      accountNumber: paymentDetailData?[0]
                                                                                      ["AccountNumber"],
                                                                                      accountHolder:
                                                                                      "${paymentDetailData?[0]["FirstName"]} ${paymentDetailData?[0]["LastName"]}",
                                                                                      iban: paymentDetailData?[0]["IBAN"],
                                                                                      bic: paymentDetailData?[0]["BIC"],
                                                                                      panNumber: paymentDetailData?[0]["PanNumber"],
                                                                                      paymentLink: '',
                                                                                      listViewBuilder: () {
                                                                                        return pw.Column(
                                                                                          mainAxisAlignment:
                                                                                          pw.MainAxisAlignment.center,
                                                                                          children: [
                                                                                            pw.ListView.builder(
                                                                                              itemCount: invoiceData?[index]
                                                                                              ["InvoiceItems"]
                                                                                                  .length,
                                                                                              itemBuilder: (context, index1) {
                                                                                                return pw.Row(children: [
                                                                                                  pw.Expanded(
                                                                                                    flex: 1,
                                                                                                    child: pw.Container(
                                                                                                      height: h * 0.06,
                                                                                                      decoration: pw.BoxDecoration(
                                                                                                        border: pw.Border.all(
                                                                                                            color: PdfColors.black),
                                                                                                      ),
                                                                                                      child: pw.Center(
                                                                                                          child: pw.Text(
                                                                                                            //"Description",
                                                                                                              "${invoiceData?[index]["InvoiceItems"][index1]["Description"]}",
                                                                                                              style: pw.TextStyle(
                                                                                                                  fontBold: pw.Font
                                                                                                                      .courierBoldOblique()))),
                                                                                                    ),
                                                                                                  ),
                                                                                                  pw.Expanded(
                                                                                                    flex: 1,
                                                                                                    child: pw.Container(
                                                                                                      height: h * 0.06,
                                                                                                      decoration: pw.BoxDecoration(
                                                                                                        border: pw.Border.all(
                                                                                                            color: PdfColors.black),
                                                                                                      ),
                                                                                                      child: pw.Center(
                                                                                                        child: pw.Text(
                                                                                                          //"Quantity",
                                                                                                            "${invoiceData?[index]["InvoiceItems"][index1]["Qty"]}",
                                                                                                            style: pw.TextStyle(
                                                                                                                fontBold: pw.Font
                                                                                                                    .courierBoldOblique())),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  pw.Expanded(
                                                                                                    flex: 1,
                                                                                                    child: pw.Container(
                                                                                                      height: h * 0.06,
                                                                                                      decoration: pw.BoxDecoration(
                                                                                                        border: pw.Border.all(
                                                                                                            color: PdfColors.black),
                                                                                                      ),
                                                                                                      child: pw.Center(
                                                                                                          child: pw.Text(
                                                                                                            //"Rate",
                                                                                                              "${invoiceData?[index]["InvoiceItems"][index1]["Rate"]}",
                                                                                                              style: pw.TextStyle(
                                                                                                                  fontBold: pw.Font
                                                                                                                      .courierBoldOblique()))),
                                                                                                    ),
                                                                                                  ),
                                                                                                  pw.Expanded(
                                                                                                    flex: 1,
                                                                                                    child: pw.Container(
                                                                                                      height: h * 0.06,
                                                                                                      decoration: pw.BoxDecoration(
                                                                                                        border: pw.Border.all(
                                                                                                            color: PdfColors.black),
                                                                                                      ),
                                                                                                      child: pw.Center(
                                                                                                          child: pw.Text(
                                                                                                            //"Amount",
                                                                                                              "${invoiceData?[index]["InvoiceItems"][index1]["TotalAmount"]}",
                                                                                                              style: pw.TextStyle(
                                                                                                                  fontBold: pw.Font
                                                                                                                      .courierBoldOblique()))),
                                                                                                    ),
                                                                                                  ),
                                                                                                ]);
                                                                                              },
                                                                                            )
                                                                                          ],
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                    await Printing.sharePdf(
                                                                                        bytes: pdf,
                                                                                        filename:
                                                                                        "GenerateInvoice${DateTime
                                                                                            .now()
                                                                                            .millisecond}.pdf");
                                                                                  } else {
                                                                                    await paymentController
                                                                                        .createPriceId(
                                                                                      currency:
                                                                                      "${invoiceData?[index]["CurrencyCode"] ?? 'IND'}",
                                                                                      amount: formattedTotalSum,
                                                                                      // "50.55",
                                                                                      recurringInterval: "month",
                                                                                      name: invoiceData?[index]["ClientName"] ?? '',
                                                                                      invoiceId: invoiceData?[index].id ?? '',
                                                                                    )
                                                                                        .then((value1) async {
                                                                                      final pdf = await controller.generatePdf(
                                                                                        invoiceId: invoiceData?[index]["InvoiceId"],
                                                                                        clientName: invoiceData?[index]["ClientName"],
                                                                                        clientCity: invoiceData?[index]["ClientCity"],
                                                                                        invoiceDate: invoiceData?[index]
                                                                                        ["InvoiceDate"],
                                                                                        dueDate: invoiceData?[index]["DueDate"],
                                                                                        length: invoiceData?[index]["InvoiceItems"]
                                                                                            .length,
                                                                                        totalAmount:
                                                                                        "${invoiceData?[index]["CurrencyCode"]}$formattedTotalSum",
                                                                                        vat: invoiceData?[index]["VAT"],
                                                                                        totalPayable: formattedTotalSum +
                                                                                            invoiceData?[index]["VAT"],
                                                                                        accountNumber: paymentDetailData?[0]
                                                                                        ["AccountNumber"],
                                                                                        accountHolder:
                                                                                        "${paymentDetailData?[0]["FirstName"]} ${paymentDetailData?[0]["LastName"]}",
                                                                                        iban: paymentDetailData?[0]["IBAN"],
                                                                                        bic: paymentDetailData?[0]["BIC"],
                                                                                        panNumber: paymentDetailData?[0]["PanNumber"],
                                                                                        paymentLink: stripePaymentController
                                                                                            .linkData.isNotEmpty
                                                                                            ? stripePaymentController.linkData['url']
                                                                                            : '',
                                                                                        listViewBuilder: () {
                                                                                          return pw.Column(
                                                                                            mainAxisAlignment:
                                                                                            pw.MainAxisAlignment.center,
                                                                                            children: [
                                                                                              pw.ListView.builder(
                                                                                                itemCount: invoiceData?[index]
                                                                                                ["InvoiceItems"]
                                                                                                    .length,
                                                                                                itemBuilder: (context, index1) {
                                                                                                  return pw.Row(children: [
                                                                                                    pw.Expanded(
                                                                                                      flex: 1,
                                                                                                      child: pw.Container(
                                                                                                        height: h * 0.06,
                                                                                                        decoration: pw.BoxDecoration(
                                                                                                          border: pw.Border.all(
                                                                                                              color: PdfColors.black),
                                                                                                        ),
                                                                                                        child: pw.Center(
                                                                                                            child: pw.Text(
                                                                                                              //"Description",
                                                                                                                "${invoiceData?[index]["InvoiceItems"][index1]["Description"]}",
                                                                                                                style: pw.TextStyle(
                                                                                                                    fontBold: pw.Font
                                                                                                                        .courierBoldOblique()))),
                                                                                                      ),
                                                                                                    ),
                                                                                                    pw.Expanded(
                                                                                                      flex: 1,
                                                                                                      child: pw.Container(
                                                                                                        height: h * 0.06,
                                                                                                        decoration: pw.BoxDecoration(
                                                                                                          border: pw.Border.all(
                                                                                                              color: PdfColors.black),
                                                                                                        ),
                                                                                                        child: pw.Center(
                                                                                                          child: pw.Text(
                                                                                                            //"Quantity",
                                                                                                              "${invoiceData?[index]["InvoiceItems"][index1]["Qty"]}",
                                                                                                              style: pw.TextStyle(
                                                                                                                  fontBold: pw.Font
                                                                                                                      .courierBoldOblique())),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    pw.Expanded(
                                                                                                      flex: 1,
                                                                                                      child: pw.Container(
                                                                                                        height: h * 0.06,
                                                                                                        decoration: pw.BoxDecoration(
                                                                                                          border: pw.Border.all(
                                                                                                              color: PdfColors.black),
                                                                                                        ),
                                                                                                        child: pw.Center(
                                                                                                            child: pw.Text(
                                                                                                              //"Rate",
                                                                                                                "${invoiceData?[index]["InvoiceItems"][index1]["Rate"]}",
                                                                                                                style: pw.TextStyle(
                                                                                                                    fontBold: pw.Font
                                                                                                                        .courierBoldOblique()))),
                                                                                                      ),
                                                                                                    ),
                                                                                                    pw.Expanded(
                                                                                                      flex: 1,
                                                                                                      child: pw.Container(
                                                                                                        height: h * 0.06,
                                                                                                        decoration: pw.BoxDecoration(
                                                                                                          border: pw.Border.all(
                                                                                                              color: PdfColors.black),
                                                                                                        ),
                                                                                                        child: pw.Center(
                                                                                                            child: pw.Text(
                                                                                                              //"Amount",
                                                                                                                "${invoiceData?[index]["InvoiceItems"][index1]["TotalAmount"]}",
                                                                                                                style: pw.TextStyle(
                                                                                                                    fontBold: pw.Font
                                                                                                                        .courierBoldOblique()))),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ]);
                                                                                                },
                                                                                              )
                                                                                            ],
                                                                                          );
                                                                                        },
                                                                                      );
                                                                                      await Printing.sharePdf(
                                                                                          bytes: pdf,
                                                                                          filename:
                                                                                          "GenerateInvoice${DateTime
                                                                                              .now()
                                                                                              .millisecond}.pdf");
                                                                                    });
                                                                                  }
                                                                                },
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.only(left: w * 0.03),
                                                                                  child: Text(
                                                                                    "Share",
                                                                                    style: CommonTextStyle.kWhite15OpenSansRegular
                                                                                        .copyWith(
                                                                                        color: Theme
                                                                                            .of(context)
                                                                                            .brightness ==
                                                                                            Brightness.dark
                                                                                            ? whiteColor
                                                                                            : blackColor),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Divider(color: greyColor, height: h * 0.05),
                                                                              InkResponse(
                                                                                onTap: () {
                                                                                  deleteInvoiceDialog(
                                                                                    context,
                                                                                        () {
                                                                                      Get.back();
                                                                                      FirebaseFirestore.instance
                                                                                          .collection("GenerateInvoice")
                                                                                          .doc(invoiceData?[index]["InvoiceId"])
                                                                                          .delete();
                                                                                    },
                                                                                  );
                                                                                },
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.only(left: w * 0.03),
                                                                                  child: Text("Delete",
                                                                                      style: CommonTextStyle.kWhite15OpenSansRegular
                                                                                          .copyWith(
                                                                                          color: Theme
                                                                                              .of(context)
                                                                                              .brightness ==
                                                                                              Brightness.dark
                                                                                              ? whiteColor
                                                                                              : blackColor)),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  child: Icon(
                                                                    Icons.more_vert,
                                                                    color: Theme
                                                                        .of(context)
                                                                        .brightness == Brightness.dark
                                                                        ? whiteColor
                                                                        : blackColor,
                                                                  ),
                                                                );
                                                              } else {
                                                                return const SizedBox();
                                                              }
                                                            }),
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(
                                                      color: Theme
                                                          .of(context)
                                                          .brightness == Brightness.dark
                                                          ? darkWhiteColor
                                                          : lightGreyColor,
                                                      height: h * 0.03),
                                                  Column(
                                                    children: List.generate(
                                                      // 1,
                                                        invoiceData?[index]["InvoiceItems"].length, (index1) {
                                                      log("lenght==>>>${invoiceData?[index]["InvoiceItems"].length}");
                                                      log("straemusd==>>${snapshot.data?.docs[index].id}");
                                                      log("getdataInvoiceid==>>${invoiceData?[index]["InvoiceId"]}");
                                                      return Column(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "${index1 +
                                                                      1}. ${invoiceData?[index]["InvoiceItems"][index1]["Description"]}",
                                                                  style: CommonTextStyle.kWhite15OpenSansRegular.copyWith(
                                                                    color: Theme
                                                                        .of(context)
                                                                        .brightness == Brightness.dark
                                                                        ? whiteColor
                                                                        : blackColor,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  //  "${invoiceData?[index]["InvoiceItems"][index1]["TotalAmount"]}",
                                                                  "${items[index1]["TotalAmount"]}",
                                                                  style: CommonTextStyle.kWhite15OpenSansRegular.copyWith(
                                                                      color: Theme
                                                                          .of(context)
                                                                          .brightness == Brightness.dark
                                                                          ? whiteColor
                                                                          : blackColor),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Divider(
                                                              indent: 10,
                                                              endIndent: 10,
                                                              color: Theme
                                                                  .of(context)
                                                                  .brightness == Brightness.dark
                                                                  ? darkWhiteColor
                                                                  : lightGreyColor,
                                                              height: h * 0.03),
                                                        ],
                                                      );
                                                    }),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          "${invoiceData?[index]["CurrencyCode"]}$formattedTotalSum",
                                                          style: invoiceData?[index]["PaymentStatus"] == "Paid"
                                                              ? CommonTextStyle.kGreen15OpenSansSemiBold
                                                              : CommonTextStyle.kRed15OpenSansSemiBold,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Due by ${invoiceData?[index]["DueDate"]}",
                                                          style: CommonTextStyle.kWhite15OpenSansRegular.copyWith(
                                                              color: Theme
                                                                  .of(context)
                                                                  .brightness == Brightness.dark
                                                                  ? whiteColor
                                                                  : blackColor),
                                                        ),
                                                        Text(
                                                          // "Unpaid",
                                                          "${invoiceData?[index]["PaymentStatus"]}",
                                                          style: invoiceData?[index]["PaymentStatus"] == "Paid"
                                                              ? CommonTextStyle.kGreen15OpenSansSemiBold
                                                              : CommonTextStyle.kRed15OpenSansSemiBold,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              })
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                          color: darkModePrimaryColor,
                        ));
                  }
                });
          },
        );
      }),
    );
  }

  Future<void> deleteClientDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Theme
              .of(Get.context!)
              .brightness == Brightness.dark ? darkModeBottomBarColor : whiteColor,
          title: Text(
            "DisableClient".tr,
            // AppString.diAbleClientText,
            style: CommonTextStyle.kWhite22OpenSansSemiBold.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme
                  .of(Get.context!)
                  .brightness == Brightness.dark ? whiteColor : blackColor,
            ),
          ),
          content: Text("areYouSureText".tr,
              //AppString.areYouSureText,
              style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                color: Theme
                    .of(Get.context!)
                    .brightness == Brightness.dark ? whiteColor : blackColor,
              )),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  'No',
                  style:
                  TextStyle(color: Theme
                      .of(Get.context!)
                      .brightness == Brightness.dark ? darkModePrimaryColor : lightModePrimaryColor),
                )),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance.collection("Clients").doc(data["ClientId"]).delete();
                Get.back();
              },
              child: Text(
                'Yes',
                style:
                TextStyle(color: Theme
                    .of(Get.context!)
                    .brightness == Brightness.dark ? darkModePrimaryColor : lightModePrimaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteInvoiceDialog(BuildContext context, void Function()? onTap) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Theme
              .of(Get.context!)
              .brightness == Brightness.dark ? darkModeBottomBarColor : whiteColor,
          title: Text(
            //  AppString.deleteText,
            "DeleteInvoice".tr,
            style: CommonTextStyle.kWhite22OpenSansSemiBold.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme
                  .of(Get.context!)
                  .brightness == Brightness.dark ? whiteColor : blackColor,
            ),
          ),
          content: Text(
            //AppString.areYouSureDeleteText,
              "areYouSureDeleteText".tr,
              style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                color: Theme
                    .of(Get.context!)
                    .brightness == Brightness.dark ? whiteColor : blackColor,
              )),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    color: Theme
                        .of(Get.context!)
                        .brightness == Brightness.dark ? darkModePrimaryColor : lightModePrimaryColor,
                  ),
                )),
            TextButton(
              onPressed: onTap,
              child: Text(
                'Yes',
                style:
                TextStyle(color: Theme
                    .of(Get.context!)
                    .brightness == Brightness.dark ? darkModePrimaryColor : lightModePrimaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
