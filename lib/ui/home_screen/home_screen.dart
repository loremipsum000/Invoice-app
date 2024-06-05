import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:generate_invoice_app/const/app_color.dart';
import 'package:generate_invoice_app/const/app_image.dart';
import 'package:generate_invoice_app/ui/client_screen/client_detail/controller/client_detail_controller.dart';
import 'package:generate_invoice_app/utils/app_routes.dart';
import 'package:generate_invoice_app/utils/common_textstyle.dart';
import 'package:generate_invoice_app/utils/preference_manager.dart';
import 'package:generate_invoice_app/utils/stripe_payment_controller.dart';
import 'package:generate_invoice_app/widgets/app_snackbar.dart';
import 'package:generate_invoice_app/widgets/common_appbar.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'controller/home_controller.dart';
import 'package:pdf/widgets.dart' as pw;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  StripePaymentController stripePaymentController = Get.put(StripePaymentController());
  HomeController homeController = Get.put(HomeController());
  ClientDetailController clientDetailController = Get.put(ClientDetailController());
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController?.addListener(handleTabSelection);
    log('PreferenceManager.getTheme========>>>>>${PreferenceManager.getTheme()}');
    // TODO: implement initState
    super.initState();
  }

  void handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    PreferenceManager.setTheme(Theme.of(context).brightness == Brightness.dark);
    log('PreferenceManager.getTheme========>>>>>${PreferenceManager.getTheme()}');
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: darkModeScaffoldColor,
      appBar: CommonAppBar(
        title: 'Invoice'.tr,
        action: true,
        actionWidget: Padding(
          padding: EdgeInsets.only(right: w * 0.02),
          child: InkResponse(
            onTap: () {
              Get.toNamed(Routes.selectClient);
            },
            child: PreferenceManager.getAddPaymentDetail() == "Yes"
                ? Icon(
                    Icons.add,
                    color: whiteColor,
                    size: 25,
                  )
                : const SizedBox(),
          ),
        ),
      ),
      body: GetBuilder<HomeController>(
        builder: (controller) {
          return GetBuilder<StripePaymentController>(
            builder: (paymentController) {
              return Column(
                children: [
                  SizedBox(height: h * 0.04),
                  DefaultTabController(
                    length: 3,
                    child: TabBar(
                        labelPadding: EdgeInsets.only(bottom: h * 0.01),
                        controller: tabController,
                        indicatorColor: Theme.of(context).brightness == Brightness.dark ? darkModePrimaryColor : lightModePrimaryColor,
                        dividerColor: Colors.transparent,
                        indicatorWeight: 4.0,
                        padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                          Text(
                            // AppString.unPaidText,
                            "Unpaid".tr,
                            style: tabController?.index == 0
                                ? CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                  )
                                : CommonTextStyle.kGrey15OpenSansRegular.copyWith(
                                    color: Theme.of(context).brightness == Brightness.dark ? greyTextColor : lightModeGreyTextColor,
                                  ),
                          ),
                          Text(
                            //  AppString.paidText,
                            "Paid".tr,
                            style: tabController?.index == 1
                                ? CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                  )
                                : CommonTextStyle.kGrey15OpenSansRegular.copyWith(
                                    color: Theme.of(context).brightness == Brightness.dark ? greyTextColor : lightModeGreyTextColor,
                                  ),
                          ),
                          Text(
                            // AppString.allText,
                            "All".tr,
                            style: tabController?.index == 2
                                ? CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                  )
                                : CommonTextStyle.kGrey15OpenSansRegular.copyWith(
                                    color: Theme.of(context).brightness == Brightness.dark ? greyTextColor : lightModeGreyTextColor,
                                  ),
                          ),
                        ]),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        ///Unpaid
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("GenerateInvoice")
                                .where("UserId", isEqualTo: PreferenceManager.getUserId())
                                .where("PaymentStatus", isEqualTo: "Unpaid")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var unpaidData = snapshot.data?.docs;
                                log("unpaidInvoiceLength===>>>${unpaidData?.length}");

                                double totalInvoiceAmount = 0.0;
                                for (var doc in unpaidData!) {
                                  var items = doc["InvoiceItems"];
                                  double totalSum = 0.0;
                                  for (var item in items) {
                                    String totalAmountString = item["TotalAmount"];
                                    double totalAmount = double.parse(
                                      totalAmountString.replaceAll(RegExp(r'[^0-9.]'), ''),
                                    );
                                    totalSum += totalAmount;
                                  }
                                  totalInvoiceAmount += totalSum;
                                }
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                                  child: Column(
                                    children: [
                                      SizedBox(height: h * 0.02),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                //"0",
                                                "${unpaidData.length}",
                                                style: CommonTextStyle.kWhite22OpenSansSemiBold.copyWith(
                                                  color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                                ),
                                              ),
                                              Text(
                                                // AppString.invoicesText,
                                                "Invoices".tr,
                                                style: CommonTextStyle.kWhite18OpenSansRegular.copyWith(
                                                  color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                totalInvoiceAmount.toStringAsFixed(3),
                                                style: CommonTextStyle.kWhite22OpenSansSemiBold.copyWith(
                                                  color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                                ),
                                              ),
                                              Text(
                                                // AppString.amtText,
                                                "Amount".tr,
                                                style: CommonTextStyle.kWhite18OpenSansRegular.copyWith(
                                                  color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: h * 0.02),
                                      Expanded(
                                        child: unpaidData.isEmpty
                                            ? Center(
                                                child: Lottie.asset(
                                                    repeat: false,
                                                    "assets/animation/lottie/empty_box.json",
                                                    height: h * 0.55,
                                                    width: h * 0.45),
                                              )
                                            : ListView.builder(
                                                itemCount: unpaidData.length,
                                                itemBuilder: (context, index) {
                                                  var items = unpaidData[index]["InvoiceItems"];
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
                                                        "InvoiceId": unpaidData[index]["InvoiceId"],
                                                      });
                                                    },
                                                    child: Container(
                                                      // height: h * 0.22,
                                                      width: double.infinity,
                                                      margin: EdgeInsets.symmetric(vertical: h * 0.01),
                                                      padding: EdgeInsets.symmetric(
                                                        horizontal: w * 0.03,
                                                        vertical: h * 0.015,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context).brightness == Brightness.dark
                                                            ? darkModeBottomBarColor
                                                            : whiteColor,
                                                        //darkModeBottomBarColor,
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(color: lightGreyColor),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                height: h * 0.06,
                                                                width: w * 0.12,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  color: Theme.of(context).brightness == Brightness.dark
                                                                      ? whiteColor
                                                                      : lightModeGreyColor,
                                                                  //whiteColor,
                                                                ),
                                                                child: Image.asset(AppImage.personImage),
                                                              ),
                                                              SizedBox(width: w * 0.03),
                                                              Text(
                                                                //"Shreya",
                                                                "${unpaidData[index]["ClientName"]}",
                                                                style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                                                                    color: Theme.of(context).brightness == Brightness.dark
                                                                        ? whiteColor
                                                                        : blackColor),
                                                              ),
                                                              const Spacer(),
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
                                                                          unpaidData[index]["InvoiceId"];
                                                                        },
                                                                        padding: const EdgeInsets.symmetric(
                                                                          horizontal: 0,
                                                                          vertical: 0,
                                                                        ),
                                                                        constraints: BoxConstraints(
                                                                          maxHeight: h * 0.35,
                                                                        ),
                                                                        color: Theme.of(context).brightness == Brightness.dark
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
                                                                                    /// Download
                                                                                    InkResponse(
                                                                                      onTap: () async {
                                                                                        Get.back();

                                                                                        Directory? directory =
                                                                                            await getExternalStorageDirectory();
                                                                                        await Permission.storage.request();
                                                                                        //String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();

                                                                                        String filePath =
                                                                                            '${directory?.path}/GenerateInvoice${DateTime.now().millisecond}.pdf';
                                                                                        log('directory.path==========>>>>>${directory?.path}');

                                                                                        await paymentController
                                                                                            .createPriceId(
                                                                                          currency:
                                                                                              "${unpaidData[index]["CurrencyCode"] ?? 'IND'}",
                                                                                          amount: formattedTotalSum,
                                                                                          // "50.55",
                                                                                          recurringInterval: "month",
                                                                                          name: unpaidData[index]["ClientName"] ?? '',
                                                                                          invoiceId: unpaidData[index].id,
                                                                                        )
                                                                                            .then((value1) async {
                                                                                          final pdfBytes =
                                                                                              await clientDetailController.generatePdf(
                                                                                            invoiceId: unpaidData[index]["InvoiceId"],
                                                                                            clientName: unpaidData[index]["ClientName"],
                                                                                            clientCity: unpaidData[index]["ClientCity"],
                                                                                            invoiceDate: unpaidData[index]["InvoiceDate"],
                                                                                            dueDate: unpaidData[index]["DueDate"],
                                                                                            length:
                                                                                                unpaidData[index]["InvoiceItems"].length,
                                                                                            totalAmount:
                                                                                                "${unpaidData[index]["CurrencyCode"]}$formattedTotalSum",
                                                                                            vat: unpaidData[index]["VAT"],
                                                                                            totalPayable: formattedTotalSum +
                                                                                                unpaidData[index]["VAT"],
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
                                                                                                    itemCount: unpaidData[index]
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
                                                                                                                    "${unpaidData[index]["InvoiceItems"][index1]["Description"]}",
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
                                                                                                                  "${unpaidData[index]["InvoiceItems"][index1]["Qty"]}",
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
                                                                                                                    "${unpaidData[index]["InvoiceItems"][index1]["Rate"]}",
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
                                                                                                                    "${unpaidData[index]["InvoiceItems"][index1]["TotalAmount"]}",
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

                                                                                          File file = File(filePath);
                                                                                          await file.writeAsBytes(pdfBytes);
                                                                                          appSnackBar(
                                                                                              message: "Successfully downloaded the PDF",
                                                                                              color: Colors.green,
                                                                                              style: CommonTextStyle.kBlack15OpenSansRegular
                                                                                                  .copyWith(
                                                                                                      color: Theme.of(Get.context!)
                                                                                                                  .brightness ==
                                                                                                              Brightness.dark
                                                                                                          ? blackColor
                                                                                                          : whiteColor));
                                                                                        });
                                                                                      },
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.only(left: w * 0.03),
                                                                                        child: Text("Download",
                                                                                            style: CommonTextStyle.kWhite15OpenSansRegular
                                                                                                .copyWith(
                                                                                              color: Theme.of(context).brightness ==
                                                                                                      Brightness.dark
                                                                                                  ? whiteColor
                                                                                                  : blackColor,
                                                                                            )),
                                                                                      ),
                                                                                    ),
                                                                                    Divider(
                                                                                      color: greyColor,
                                                                                      height: h * 0.05,
                                                                                    ),

                                                                                    /// Mark as Paid
                                                                                    InkResponse(
                                                                                      onTap: () {
                                                                                        Get.back();
                                                                                        FirebaseFirestore.instance
                                                                                            .collection("GenerateInvoice")
                                                                                            .doc(unpaidData[index]["InvoiceId"])
                                                                                            .update({
                                                                                          "PaymentStatus": "Paid",
                                                                                        });
                                                                                      },
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.only(left: w * 0.03),
                                                                                        child: Text("Mark as paid",
                                                                                            style: CommonTextStyle.kWhite15OpenSansRegular
                                                                                                .copyWith(
                                                                                              color: Theme.of(context).brightness ==
                                                                                                      Brightness.dark
                                                                                                  ? whiteColor
                                                                                                  : blackColor,
                                                                                            )),
                                                                                      ),
                                                                                    ),
                                                                                    Divider(
                                                                                      color: greyColor,
                                                                                      height: h * 0.05,
                                                                                    ),

                                                                                    /// Share
                                                                                    InkResponse(
                                                                                      onTap: () async {
                                                                                        Get.back();
                                                                                        await paymentController
                                                                                            .createPriceId(
                                                                                          currency:
                                                                                              "${unpaidData[index]["CurrencyCode"] ?? 'IND'}",
                                                                                          amount: formattedTotalSum,
                                                                                          // "50.55",
                                                                                          recurringInterval: "month",
                                                                                          name: unpaidData[index]["ClientName"] ?? '',
                                                                                          invoiceId: unpaidData[index].id,
                                                                                        )
                                                                                            .then((value1) async {
                                                                                          // String timeStamp = DateTime.now().millisecond.toString();
                                                                                          final pdf =
                                                                                              await clientDetailController.generatePdf(
                                                                                            invoiceId: unpaidData[index]["InvoiceId"],
                                                                                            clientName: unpaidData[index]["ClientName"],
                                                                                            clientCity: unpaidData[index]["ClientCity"],
                                                                                            invoiceDate: unpaidData[index]["InvoiceDate"],
                                                                                            dueDate: unpaidData[index]["DueDate"],
                                                                                            length:
                                                                                                unpaidData[index]["InvoiceItems"].length,
                                                                                            totalAmount:
                                                                                                "${unpaidData[index]["CurrencyCode"]}$formattedTotalSum",
                                                                                            vat: unpaidData[index]["VAT"],
                                                                                            totalPayable: formattedTotalSum +
                                                                                                unpaidData[index]["VAT"],
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
                                                                                                    itemCount: unpaidData[index]
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
                                                                                                                    "${unpaidData[index]["InvoiceItems"][index1]["Description"]}",
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
                                                                                                                  "${unpaidData[index]["InvoiceItems"][index1]["Qty"]}",
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
                                                                                                                    "${unpaidData[index]["InvoiceItems"][index1]["Rate"]}",
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
                                                                                                                    "${unpaidData[index]["InvoiceItems"][index1]["TotalAmount"]}",
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
                                                                                                  "GenerateInvoice${DateTime.now().millisecond}.pdf");
                                                                                        });
                                                                                      },
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.only(left: w * 0.03),
                                                                                        child: Text(
                                                                                          "Share",
                                                                                          style: CommonTextStyle.kWhite15OpenSansRegular
                                                                                              .copyWith(
                                                                                            color: Theme.of(context).brightness ==
                                                                                                    Brightness.dark
                                                                                                ? whiteColor
                                                                                                : blackColor,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Divider(color: greyColor, height: h * 0.05),

                                                                                    /// Delete
                                                                                    InkResponse(
                                                                                      onTap: () {
                                                                                        Get.back();
                                                                                        deleteInvoiceDialog(
                                                                                          context,
                                                                                          () {
                                                                                            FirebaseFirestore.instance
                                                                                                .collection("GenerateInvoice")
                                                                                                .doc(unpaidData[index]["InvoiceId"])
                                                                                                .delete();
                                                                                          },
                                                                                        );
                                                                                      },
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.only(left: w * 0.03),
                                                                                        child: Text("Delete",
                                                                                            style: CommonTextStyle.kWhite15OpenSansRegular
                                                                                                .copyWith(
                                                                                              color: Theme.of(context).brightness ==
                                                                                                      Brightness.dark
                                                                                                  ? whiteColor
                                                                                                  : blackColor,
                                                                                            )),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ];
                                                                        },
                                                                        child: Icon(Icons.more_vert,
                                                                            color: Theme.of(context).brightness == Brightness.dark
                                                                                ? whiteColor
                                                                                : blackColor),
                                                                      );
                                                                    } else {
                                                                      return const SizedBox();
                                                                    }
                                                                  }),
                                                            ],
                                                          ),
                                                          Divider(
                                                            color: Theme.of(context).brightness == Brightness.dark
                                                                ? darkWhiteColor
                                                                : lightGreyColor,
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(vertical: h * 0.02),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  //"#3289",
                                                                  "# ${unpaidData[index]["InvoiceId"]}",
                                                                  style: CommonTextStyle.kWhite15OpenSansRegular.copyWith(
                                                                      color: Theme.of(context).brightness == Brightness.dark
                                                                          ? whiteColor
                                                                          : blackColor),
                                                                ),
                                                                Text(
                                                                  //"GBP,5000",
                                                                  "${unpaidData[index]["CurrencyCode"]}$formattedTotalSum",
                                                                  style: CommonTextStyle.kRed15OpenSansSemiBold,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                //"Due by May,8,2024",
                                                                "${"DueBy".tr} ${unpaidData[index]["DueDate"]}",
                                                                style: CommonTextStyle.kWhite15OpenSansRegular.copyWith(
                                                                    color: Theme.of(context).brightness == Brightness.dark
                                                                        ? whiteColor
                                                                        : blackColor),
                                                              ),
                                                              Text(
                                                                "Unpaid",
                                                                style: CommonTextStyle.kRed15OpenSansSemiBold,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            }),

                        ///Paid
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("GenerateInvoice")
                                .where("UserId", isEqualTo: PreferenceManager.getUserId())
                                .where("PaymentStatus", isEqualTo: "Paid")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var paidInvoiceData = snapshot.data?.docs;
                                log("PaidInvoiceLength===>>>${paidInvoiceData?.length}");
                                double totalInvoiceAmount = 0.0;
                                for (var doc in paidInvoiceData!) {
                                  var items = doc["InvoiceItems"];
                                  double totalSum = 0.0;
                                  for (var item in items) {
                                    String totalAmountString = item["TotalAmount"];
                                    double totalAmount = double.parse(
                                      totalAmountString.replaceAll(RegExp(r'[^0-9.]'), ''),
                                    );
                                    totalSum += totalAmount;
                                  }
                                  totalInvoiceAmount += totalSum;
                                }
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                                  child: Column(
                                    children: [
                                      SizedBox(height: h * 0.02),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "${paidInvoiceData.length}",
                                                style: CommonTextStyle.kWhite22OpenSansSemiBold.copyWith(
                                                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor),
                                              ),
                                              Text(
                                                // AppString.invoicesText,
                                                "Invoices".tr,
                                                style: CommonTextStyle.kWhite18OpenSansRegular.copyWith(
                                                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                totalInvoiceAmount.toStringAsFixed(3),
                                                style: CommonTextStyle.kWhite22OpenSansSemiBold.copyWith(
                                                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor),
                                              ),
                                              Text(
                                                //AppString.amtText,
                                                "Amount".tr,
                                                style: CommonTextStyle.kWhite18OpenSansRegular.copyWith(
                                                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: h * 0.02),
                                      Expanded(
                                        child: paidInvoiceData.isEmpty
                                            ? Center(
                                                child: Lottie.asset(
                                                    repeat: false,
                                                    "assets/animation/lottie/empty_box.json",
                                                    height: h * 0.55,
                                                    width: h * 0.45),
                                              )
                                            : ListView.builder(
                                                itemCount: paidInvoiceData.length,
                                                itemBuilder: (context, index) {
                                                  var items = paidInvoiceData[index]["InvoiceItems"];
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
                                                        "InvoiceId": paidInvoiceData[index]["InvoiceId"],
                                                      });
                                                    },
                                                    child: Container(
                                                      // height: h * 0.22,
                                                      width: double.infinity,
                                                      margin: EdgeInsets.symmetric(vertical: h * 0.01),
                                                      padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.015),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context).brightness == Brightness.dark
                                                            ? darkModeBottomBarColor
                                                            : whiteColor,
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(color: lightGreyColor),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                height: h * 0.06,
                                                                width: w * 0.12,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  color: Theme.of(context).brightness == Brightness.dark
                                                                      ? whiteColor
                                                                      : lightModeGreyColor,
                                                                ),
                                                                child: Image.asset(AppImage.personImage),
                                                              ),
                                                              SizedBox(width: w * 0.03),
                                                              Text(
                                                                //"Shreya",
                                                                "${paidInvoiceData[index]["ClientName"]}",
                                                                style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                                                                    color: Theme.of(context).brightness == Brightness.dark
                                                                        ? whiteColor
                                                                        : blackColor),
                                                              ),
                                                              const Spacer(),
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
                                                                          paidInvoiceData[index]["InvoiceId"];
                                                                        },
                                                                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                                                        constraints: BoxConstraints(
                                                                          maxHeight: h * 0.35,
                                                                        ),
                                                                        color: Theme.of(context).brightness == Brightness.dark
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
                                                                                        Directory? directory =
                                                                                            await getExternalStorageDirectory();
                                                                                        await Permission.storage.request();
                                                                                        if (directory != null) {
                                                                                          String filePath =
                                                                                              '${directory.path}/GenerateInvoice${DateTime.now().millisecond}.pdf';
                                                                                          log('directory.path==========>>>>>${directory.path}');
                                                                                          final pdfBytes =
                                                                                              await clientDetailController.generatePdf(
                                                                                            invoiceId: paidInvoiceData[index]["InvoiceId"],
                                                                                            clientName: paidInvoiceData[index]
                                                                                                ["ClientName"],
                                                                                            clientCity: paidInvoiceData[index]
                                                                                                ["ClientCity"],
                                                                                            invoiceDate: paidInvoiceData[index]
                                                                                                ["InvoiceDate"],
                                                                                            dueDate: paidInvoiceData[index]["DueDate"],
                                                                                            length: paidInvoiceData[index]["InvoiceItems"]
                                                                                                .length,
                                                                                            totalAmount:
                                                                                                "${paidInvoiceData[index]["CurrencyCode"]}$formattedTotalSum",
                                                                                            vat: paidInvoiceData[index]["VAT"],
                                                                                            totalPayable: formattedTotalSum +
                                                                                                paidInvoiceData[index]["VAT"],
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
                                                                                                    itemCount: paidInvoiceData[index]
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
                                                                                                                    "${paidInvoiceData[index]["InvoiceItems"][index1]["Description"]}",
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
                                                                                                                  "${paidInvoiceData[index]["InvoiceItems"][index1]["Qty"]}",
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
                                                                                                                    "${paidInvoiceData[index]["InvoiceItems"][index1]["Rate"]}",
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
                                                                                                                    "${paidInvoiceData[index]["InvoiceItems"][index1]["TotalAmount"]}",
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
                                                                                          File file = File(filePath);
                                                                                          await file.writeAsBytes(pdfBytes);
                                                                                          appSnackBar(
                                                                                              message: "Successfully downloaded the PDF",
                                                                                              color: Colors.green,
                                                                                              style: CommonTextStyle.kBlack15OpenSansRegular
                                                                                                  .copyWith(
                                                                                                      color: Theme.of(Get.context!)
                                                                                                                  .brightness ==
                                                                                                              Brightness.dark
                                                                                                          ? blackColor
                                                                                                          : whiteColor));
                                                                                        } else {
                                                                                          appSnackBar(
                                                                                              message:
                                                                                                  "Error: Unable to get directory for downloading PDF");
                                                                                        }
                                                                                      },
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.only(left: w * 0.03),
                                                                                        child: Text("Download",
                                                                                            style: CommonTextStyle.kWhite15OpenSansRegular
                                                                                                .copyWith(
                                                                                              color: Theme.of(context).brightness ==
                                                                                                      Brightness.dark
                                                                                                  ? whiteColor
                                                                                                  : blackColor,
                                                                                            )),
                                                                                      ),
                                                                                    ),
                                                                                    Divider(
                                                                                      color: greyColor,
                                                                                      height: h * 0.05,
                                                                                    ),
                                                                                    InkResponse(
                                                                                      onTap: () async {
                                                                                        Get.back();
                                                                                        final pdf =
                                                                                            await clientDetailController.generatePdf(
                                                                                          invoiceId: paidInvoiceData[index]["InvoiceId"],
                                                                                          clientName: paidInvoiceData[index]["ClientName"],
                                                                                          clientCity: paidInvoiceData[index]["ClientCity"],
                                                                                          invoiceDate: paidInvoiceData[index]
                                                                                              ["InvoiceDate"],
                                                                                          dueDate: paidInvoiceData[index]["DueDate"],
                                                                                          length:
                                                                                              paidInvoiceData[index]["InvoiceItems"].length,
                                                                                          totalAmount:
                                                                                              "${paidInvoiceData[index]["CurrencyCode"]}$formattedTotalSum",
                                                                                          vat: paidInvoiceData[index]["VAT"],
                                                                                          totalPayable: formattedTotalSum +
                                                                                              paidInvoiceData[index]["VAT"],
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
                                                                                                  itemCount: paidInvoiceData[index]
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
                                                                                                                  "${paidInvoiceData[index]["InvoiceItems"][index1]["Description"]}",
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
                                                                                                                "${paidInvoiceData[index]["InvoiceItems"][index1]["Qty"]}",
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
                                                                                                                  "${paidInvoiceData[index]["InvoiceItems"][index1]["Rate"]}",
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
                                                                                                                  "${paidInvoiceData[index]["InvoiceItems"][index1]["TotalAmount"]}",
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
                                                                                                "GenerateInvoice${DateTime.now().millisecond}.pdf");
                                                                                      },
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.only(left: w * 0.03),
                                                                                        child: Text("Share",
                                                                                            style: CommonTextStyle.kWhite15OpenSansRegular
                                                                                                .copyWith(
                                                                                              color: Theme.of(context).brightness ==
                                                                                                      Brightness.dark
                                                                                                  ? whiteColor
                                                                                                  : blackColor,
                                                                                            )),
                                                                                      ),
                                                                                    ),
                                                                                    Divider(color: greyColor, height: h * 0.05),
                                                                                    InkResponse(
                                                                                      onTap: () {
                                                                                        Get.back();
                                                                                        deleteInvoiceDialog(
                                                                                          context,
                                                                                          () {
                                                                                            FirebaseFirestore.instance
                                                                                                .collection("GenerateInvoice")
                                                                                                .doc(paidInvoiceData[index]["InvoiceId"])
                                                                                                .delete();
                                                                                          },
                                                                                        );
                                                                                      },
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.only(left: w * 0.03),
                                                                                        child: Text("Delete",
                                                                                            style: CommonTextStyle.kWhite15OpenSansRegular
                                                                                                .copyWith(
                                                                                              color: Theme.of(context).brightness ==
                                                                                                      Brightness.dark
                                                                                                  ? whiteColor
                                                                                                  : blackColor,
                                                                                            )),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ];
                                                                        },
                                                                        child: Icon(Icons.more_vert,
                                                                            color: Theme.of(context).brightness == Brightness.dark
                                                                                ? whiteColor
                                                                                : blackColor),
                                                                      );
                                                                    } else {
                                                                      return const SizedBox();
                                                                    }
                                                                  }),
                                                            ],
                                                          ),
                                                          Divider(
                                                            color: Theme.of(context).brightness == Brightness.dark
                                                                ? darkWhiteColor
                                                                : lightGreyColor,
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(vertical: h * 0.02),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                    //"#3289",
                                                                    "# ${paidInvoiceData[index]["InvoiceId"]}",
                                                                    style: CommonTextStyle.kWhite15OpenSansRegular.copyWith(
                                                                        color: Theme.of(context).brightness == Brightness.dark
                                                                            ? whiteColor
                                                                            : blackColor)),
                                                                Text(
                                                                  //"GBP,5000",
                                                                  "${paidInvoiceData[index]["CurrencyCode"]}$formattedTotalSum",
                                                                  style: CommonTextStyle.kGreen15OpenSansSemiBold,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                  //"Due by May,8,2024",
                                                                  "${"DueBy".tr} ${paidInvoiceData[index]["DueDate"]}",
                                                                  style: CommonTextStyle.kWhite15OpenSansRegular.copyWith(
                                                                      color: Theme.of(context).brightness == Brightness.dark
                                                                          ? whiteColor
                                                                          : blackColor)),
                                                              Text(
                                                                "Paid",
                                                                style: CommonTextStyle.kGreen15OpenSansSemiBold
                                                                  ..copyWith(
                                                                      color: Theme.of(context).brightness == Brightness.dark
                                                                          ? whiteColor
                                                                          : blackColor),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            }),

                        ///All
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("GenerateInvoice")
                              .where("UserId", isEqualTo: PreferenceManager.getUserId())
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var invoiceData = snapshot.data?.docs;
                              log('AllInvoicesLength=====>>>>${snapshot.data?.docs.length}');
                              double totalInvoiceAmount = 0.0;
                              for (var doc in invoiceData!) {
                                var items = doc["InvoiceItems"];
                                double totalSum = 0.0;
                                for (var item in items) {
                                  String totalAmountString = item["TotalAmount"];
                                  double totalAmount = double.parse(
                                    totalAmountString.replaceAll(RegExp(r'[^0-9.]'), ''),
                                  );
                                  totalSum += totalAmount;
                                }
                                totalInvoiceAmount += totalSum;
                              }
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                                child: Column(
                                  children: [
                                    SizedBox(height: h * 0.02),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "${invoiceData.length}",
                                              style: CommonTextStyle.kWhite22OpenSansSemiBold.copyWith(
                                                  color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor),
                                            ),
                                            Text(
                                              //AppString.invoicesText,
                                              "Invoices".tr,
                                              style: CommonTextStyle.kWhite18OpenSansRegular.copyWith(
                                                  color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(totalInvoiceAmount.toStringAsFixed(3),
                                                style: CommonTextStyle.kWhite22OpenSansSemiBold.copyWith(
                                                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor)),
                                            Text(
                                                // AppString.amtText,
                                                "Amount".tr,
                                                style: CommonTextStyle.kWhite18OpenSansRegular.copyWith(
                                                    color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: h * 0.02),
                                    Expanded(
                                      child: invoiceData.isEmpty
                                          ? Center(
                                              child: Lottie.asset(
                                                  repeat: false,
                                                  "assets/animation/lottie/empty_box.json",
                                                  height: h * 0.55,
                                                  width: h * 0.45),
                                            )
                                          : ListView.builder(
                                              itemCount: invoiceData.length,
                                              itemBuilder: (context, index) {
                                                var items = invoiceData[index]["InvoiceItems"];
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
                                                    Get.toNamed(Routes.editInvoice,
                                                        arguments: {"InvoiceId": invoiceData[index]["InvoiceId"]});
                                                  },
                                                  child: Container(
                                                    // height: h * 0.22,
                                                    width: double.infinity,
                                                    margin: EdgeInsets.symmetric(vertical: h * 0.01),
                                                    padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.015),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context).brightness == Brightness.dark
                                                          ? darkModeBottomBarColor
                                                          : whiteColor,
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(color: lightGreyColor),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              height: h * 0.06,
                                                              width: w * 0.12,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  color: Theme.of(context).brightness == Brightness.dark
                                                                      ? whiteColor
                                                                      : lightModeGreyColor),
                                                              child: Image.asset(AppImage.personImage),
                                                            ),
                                                            SizedBox(width: w * 0.03),
                                                            Text(
                                                              //"Shreya",
                                                              "${invoiceData[index]["ClientName"]}",
                                                              style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                                                                  color: Theme.of(context).brightness == Brightness.dark
                                                                      ? whiteColor
                                                                      : blackColor),
                                                            ),
                                                            const Spacer(),
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
                                                                        invoiceData[index]["InvoiceId"];
                                                                      },
                                                                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                                                      constraints: BoxConstraints(
                                                                        maxHeight: h * 0.35,
                                                                      ),
                                                                      color: Theme.of(context).brightness == Brightness.dark
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
                                                                                  /// Download
                                                                                  InkResponse(
                                                                                    onTap: () async {
                                                                                      Get.back();

                                                                                      if (invoiceData[index]["PaymentStatus"] == "Paid") {
                                                                                        Directory? directory =
                                                                                            await getExternalStorageDirectory();
                                                                                        await Permission.storage.request();
                                                                                        if (directory != null) {
                                                                                          String filePath =
                                                                                              '${directory.path}/GenerateInvoice${DateTime.now().millisecond}.pdf';
                                                                                          log('directory.path==========>>>>>${directory.path}');

                                                                                          final pdfBytes =
                                                                                              await clientDetailController.generatePdf(
                                                                                            invoiceId: invoiceData[index]["InvoiceId"],
                                                                                            clientName: invoiceData[index]["ClientName"],
                                                                                            clientCity: invoiceData[index]["ClientCity"],
                                                                                            invoiceDate: invoiceData[index]["InvoiceDate"],
                                                                                            dueDate: invoiceData[index]["DueDate"],
                                                                                            length:
                                                                                                invoiceData[index]["InvoiceItems"].length,
                                                                                            totalAmount:
                                                                                                "${invoiceData[index]["CurrencyCode"]}$formattedTotalSum",
                                                                                            vat: invoiceData[index]["VAT"],
                                                                                            totalPayable: formattedTotalSum +
                                                                                                invoiceData[index]["VAT"],
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
                                                                                                    itemCount: invoiceData[index]
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
                                                                                                                    "${invoiceData[index]["InvoiceItems"][index1]["Description"]}",
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
                                                                                                                  "${invoiceData[index]["InvoiceItems"][index1]["Qty"]}",
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
                                                                                                                    "${invoiceData[index]["InvoiceItems"][index1]["Rate"]}",
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
                                                                                                                    "${invoiceData[index]["InvoiceItems"][index1]["TotalAmount"]}",
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
                                                                                          File file = File(filePath);
                                                                                          await file.writeAsBytes(pdfBytes);
                                                                                          appSnackBar(
                                                                                              message: "successfully downloaded the PDF",
                                                                                              color: Colors.green,
                                                                                              style: CommonTextStyle.kBlack15OpenSansRegular
                                                                                                  .copyWith(
                                                                                                      color: Theme.of(Get.context!)
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
                                                                                        Directory? directory =
                                                                                            await getExternalStorageDirectory();
                                                                                        await Permission.storage.request();

                                                                                        if (directory != null) {
                                                                                          String filePath =
                                                                                              '${directory.path}/GenerateInvoice${DateTime.now().millisecond}.pdf';
                                                                                          log('directory.path=========1111=>>>>>${directory.path}');

                                                                                          await paymentController
                                                                                              .createPriceId(
                                                                                            currency:
                                                                                                "${invoiceData[index]["CurrencyCode"] ?? 'IND'}",
                                                                                            amount: formattedTotalSum,
                                                                                            // "50.55",
                                                                                            recurringInterval: "month",
                                                                                            name: invoiceData[index]["ClientName"] ?? '',
                                                                                            invoiceId: invoiceData[index].id,
                                                                                          )
                                                                                              .then((value1) async {
                                                                                            final pdfBytes =
                                                                                                await clientDetailController.generatePdf(
                                                                                              invoiceId: invoiceData[index]["InvoiceId"],
                                                                                              clientName: invoiceData[index]["ClientName"],
                                                                                              clientCity: invoiceData[index]["ClientCity"],
                                                                                              invoiceDate: invoiceData[index]
                                                                                                  ["InvoiceDate"],
                                                                                              dueDate: invoiceData[index]["DueDate"],
                                                                                              length:
                                                                                                  invoiceData[index]["InvoiceItems"].length,
                                                                                              totalAmount:
                                                                                                  "${invoiceData[index]["CurrencyCode"]}$formattedTotalSum",
                                                                                              vat: invoiceData[index]["VAT"],
                                                                                              totalPayable: formattedTotalSum +
                                                                                                  invoiceData[index]["VAT"],
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
                                                                                                      itemCount: invoiceData[index]
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
                                                                                                                      "${invoiceData[index]["InvoiceItems"][index1]["Description"]}",
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
                                                                                                                    "${invoiceData[index]["InvoiceItems"][index1]["Qty"]}",
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
                                                                                                                      "${invoiceData[index]["InvoiceItems"][index1]["Rate"]}",
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
                                                                                                                      "${invoiceData[index]["InvoiceItems"][index1]["TotalAmount"]}",
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
                                                                                            File file = File(filePath);
                                                                                            await file.writeAsBytes(pdfBytes);
                                                                                            appSnackBar(
                                                                                                message: "successfully downloaded the PDF",
                                                                                                color: Colors.green,
                                                                                                style: CommonTextStyle
                                                                                                    .kBlack15OpenSansRegular
                                                                                                    .copyWith(
                                                                                                        color: Theme.of(Get.context!)
                                                                                                                    .brightness ==
                                                                                                                Brightness.dark
                                                                                                            ? blackColor
                                                                                                            : whiteColor));
                                                                                          });
                                                                                        } else {
                                                                                          appSnackBar(
                                                                                              message:
                                                                                                  "Error: Unable to get directory for downloading PDF");
                                                                                        }
                                                                                      }
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.only(left: w * 0.03),
                                                                                      child: Text("Download",
                                                                                          style: CommonTextStyle.kWhite15OpenSansRegular
                                                                                              .copyWith(
                                                                                            color: Theme.of(context).brightness ==
                                                                                                    Brightness.dark
                                                                                                ? whiteColor
                                                                                                : blackColor,
                                                                                          )),
                                                                                    ),
                                                                                  ),

                                                                                  /// Mark as Paid
                                                                                  invoiceData[index]["PaymentStatus"] == "Paid"
                                                                                      ? const SizedBox()
                                                                                      : Divider(
                                                                                          color: greyColor,
                                                                                          height: h * 0.05,
                                                                                        ),
                                                                                  invoiceData[index]["PaymentStatus"] == "Paid"
                                                                                      ? const SizedBox()
                                                                                      : InkResponse(
                                                                                          onTap: () {
                                                                                            Get.back();
                                                                                            FirebaseFirestore.instance
                                                                                                .collection("GenerateInvoice")
                                                                                                .doc(invoiceData[index]["InvoiceId"])
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
                                                                                                  color: Theme.of(context).brightness ==
                                                                                                          Brightness.dark
                                                                                                      ? whiteColor
                                                                                                      : blackColor,
                                                                                                )),
                                                                                          ),
                                                                                        ),
                                                                                  Divider(
                                                                                    color: greyColor,
                                                                                    height: h * 0.05,
                                                                                  ),

                                                                                  /// Share
                                                                                  InkResponse(
                                                                                    onTap: () async {
                                                                                      Get.back();

                                                                                      if (invoiceData[index]["PaymentStatus"] == "Paid") {
                                                                                        final pdf =
                                                                                            await clientDetailController.generatePdf(
                                                                                          invoiceId: invoiceData[index]["InvoiceId"],
                                                                                          clientName: invoiceData[index]["ClientName"],
                                                                                          clientCity: invoiceData[index]["ClientCity"],
                                                                                          invoiceDate: invoiceData[index]["InvoiceDate"],
                                                                                          dueDate: invoiceData[index]["DueDate"],
                                                                                          length: invoiceData[index]["InvoiceItems"].length,
                                                                                          totalAmount:
                                                                                              "${invoiceData[index]["CurrencyCode"]}$formattedTotalSum",
                                                                                          vat: invoiceData[index]["VAT"],
                                                                                          totalPayable:
                                                                                              formattedTotalSum + invoiceData[index]["VAT"],
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
                                                                                                  itemCount: invoiceData[index]
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
                                                                                                                  "${invoiceData[index]["InvoiceItems"][index1]["Description"]}",
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
                                                                                                                "${invoiceData[index]["InvoiceItems"][index1]["Qty"]}",
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
                                                                                                                  "${invoiceData[index]["InvoiceItems"][index1]["Rate"]}",
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
                                                                                                                  "${invoiceData[index]["InvoiceItems"][index1]["TotalAmount"]}",
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
                                                                                                "GenerateInvoice${DateTime.now().millisecond}.pdf");
                                                                                      } else {
                                                                                        await paymentController
                                                                                            .createPriceId(
                                                                                          currency:
                                                                                              "${invoiceData[index]["CurrencyCode"] ?? 'IND'}",
                                                                                          amount: formattedTotalSum,
                                                                                          // "50.55",
                                                                                          recurringInterval: "month",
                                                                                          name: invoiceData[index]["ClientName"] ?? '',
                                                                                          invoiceId: invoiceData[index].id,
                                                                                        )
                                                                                            .then((value1) async {
                                                                                          final pdf =
                                                                                              await clientDetailController.generatePdf(
                                                                                            invoiceId: invoiceData[index]["InvoiceId"],
                                                                                            clientName: invoiceData[index]["ClientName"],
                                                                                            clientCity: invoiceData[index]["ClientCity"],
                                                                                            invoiceDate: invoiceData[index]["InvoiceDate"],
                                                                                            dueDate: invoiceData[index]["DueDate"],
                                                                                            length:
                                                                                                invoiceData[index]["InvoiceItems"].length,
                                                                                            totalAmount:
                                                                                                "${invoiceData[index]["CurrencyCode"]}$formattedTotalSum",
                                                                                            vat: invoiceData[index]["VAT"],
                                                                                            totalPayable: formattedTotalSum +
                                                                                                invoiceData[index]["VAT"],
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
                                                                                                    itemCount: invoiceData[index]
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
                                                                                                                    "${invoiceData[index]["InvoiceItems"][index1]["Description"]}",
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
                                                                                                                  "${invoiceData[index]["InvoiceItems"][index1]["Qty"]}",
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
                                                                                                                    "${invoiceData[index]["InvoiceItems"][index1]["Rate"]}",
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
                                                                                                                    "${invoiceData[index]["InvoiceItems"][index1]["TotalAmount"]}",
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
                                                                                                  "GenerateInvoice${DateTime.now().millisecond}.pdf");
                                                                                        });
                                                                                      }
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.only(left: w * 0.03),
                                                                                      child: Text("Share",
                                                                                          style: CommonTextStyle.kWhite15OpenSansRegular
                                                                                              .copyWith(
                                                                                            color: Theme.of(context).brightness ==
                                                                                                    Brightness.dark
                                                                                                ? whiteColor
                                                                                                : blackColor,
                                                                                          )),
                                                                                    ),
                                                                                  ),
                                                                                  Divider(color: greyColor, height: h * 0.05),

                                                                                  /// Delete
                                                                                  InkResponse(
                                                                                    onTap: () {
                                                                                      Get.back();
                                                                                      deleteInvoiceDialog(
                                                                                        context,
                                                                                        () {
                                                                                          FirebaseFirestore.instance
                                                                                              .collection("GenerateInvoice")
                                                                                              .doc(invoiceData[index]["InvoiceId"])
                                                                                              .delete();
                                                                                          Get.back();
                                                                                        },
                                                                                      );
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.only(left: w * 0.03),
                                                                                      child: Text("Delete",
                                                                                          style: CommonTextStyle.kWhite15OpenSansRegular
                                                                                              .copyWith(
                                                                                            color: Theme.of(context).brightness ==
                                                                                                    Brightness.dark
                                                                                                ? whiteColor
                                                                                                : blackColor,
                                                                                          )),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ];
                                                                      },
                                                                      child: Icon(Icons.more_vert,
                                                                          color: Theme.of(context).brightness == Brightness.dark
                                                                              ? whiteColor
                                                                              : blackColor),
                                                                    );
                                                                  } else {
                                                                    return const SizedBox();
                                                                  }
                                                                }),
                                                          ],
                                                        ),
                                                        Divider(
                                                            color: Theme.of(context).brightness == Brightness.dark
                                                                ? darkWhiteColor
                                                                : lightGreyColor),
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(vertical: h * 0.02),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                //"#3289",
                                                                "# ${invoiceData[index]["InvoiceId"]}",
                                                                style: CommonTextStyle.kWhite15OpenSansRegular.copyWith(
                                                                    color: Theme.of(context).brightness == Brightness.dark
                                                                        ? whiteColor
                                                                        : blackColor),
                                                              ),
                                                              Text(
                                                                //"GBP,5000",
                                                                "${invoiceData[index]["CurrencyCode"]}$formattedTotalSum",
                                                                style: invoiceData[index]["PaymentStatus"] == "Paid"
                                                                    ? CommonTextStyle.kGreen15OpenSansSemiBold
                                                                    : CommonTextStyle.kRed15OpenSansSemiBold,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              //"Due by May,8,2024",
                                                              "${"DueBy".tr} ${invoiceData[index]["DueDate"]}",
                                                              style: CommonTextStyle.kWhite15OpenSansRegular.copyWith(
                                                                  color: Theme.of(context).brightness == Brightness.dark
                                                                      ? whiteColor
                                                                      : blackColor),
                                                            ),
                                                            Text(
                                                              //"Unpaid",
                                                              "${invoiceData[index]["PaymentStatus"]}",
                                                              style: invoiceData[index]["PaymentStatus"] == "Paid"
                                                                  ? CommonTextStyle.kGreen15OpenSansSemiBold
                                                                  : CommonTextStyle.kRed15OpenSansSemiBold,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
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
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? darkModeBottomBarColor : whiteColor,
          title: Text(
            //AppString.deleteText,
            "DeleteInvoice".tr,
            style: CommonTextStyle.kWhite22OpenSansSemiBold
                .copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor),
          ),
          content: Text(
              //AppString.areYouSureDeleteText,
              "areYouSureDeleteText".tr,
              style: CommonTextStyle.kWhite15OpenSansSemiBold
                  .copyWith(color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor)),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  'No',
                  //   style: TextStyle(color: darkModePrimaryColor),
                )),
            TextButton(
              onPressed: onTap,
              child: const Text(
                'Yes',
                // style: TextStyle(color: darkModePrimaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
