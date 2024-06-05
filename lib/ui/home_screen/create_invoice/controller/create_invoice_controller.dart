import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:generate_invoice_app/utils/preference_manager.dart';
import 'package:generate_invoice_app/widgets/app_snackbar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateInvoiceController extends GetxController {
  // TextEditingController descriptionController = TextEditingController();
  // TextEditingController quantityController = TextEditingController(text: "0.0");
  // TextEditingController rateController = TextEditingController(text: "0.0");
  // TextEditingController totalAmountController = TextEditingController(text: "0");

  // void quantity(value) async {
  //   double quantity = double.tryParse(value) ?? 0.0;
  //   double rate = double.tryParse(rateController.text) ?? 0.0;
  //   double totalAmount = quantity * rate;
  //   totalAmountController.text = totalAmount.toString();
  //   update();
  // }
  //
  // void rate(value) async {
  //   double rate = double.tryParse(value) ?? 0.0;
  //   double quantity = double.tryParse(quantityController.text) ?? 0.0;
  //   double totalAmount = quantity * rate;
  //   totalAmountController.text = totalAmount.toString();
  //   update();
  // }

  // TextEditingController descriptionController = TextEditingController();
  // TextEditingController quantityController = TextEditingController(text: "0.0");
  // TextEditingController rateController = TextEditingController(text: "0.0");
  // TextEditingController totalAmountController =
  //     TextEditingController(text: "0");
  // List<TextEditingController> textControllers = [];
  // void add() {
  //   textControllers.add(descriptionController);
  //   update();
  // }
  //
  // void updateTotalAmount() {
  //   double quantity = double.tryParse(quantityController.text) ?? 0.0;
  //   double rate = double.tryParse(rateController.text) ?? 0.0;
  //   double totalAmount = quantity * rate;
  //   totalAmountController.text = totalAmount.toString();
  //   update();
  // }

  TextEditingController vatController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  String? selectDate;
  Currency? selectedCurrency;
  String? symbol = '';
  List listViewContainers = [];

  List<TextEditingController> descriptionControllers = [];
  List<TextEditingController> quantityControllers = [];
  List<TextEditingController> rateControllers = [];
  List<TextEditingController> totalAmountControllers = [];

  void add() {
    descriptionControllers.add(TextEditingController());
    quantityControllers.add(TextEditingController(text: "0.0"));
    rateControllers.add(TextEditingController(text: "0.0"));
    totalAmountControllers.add(TextEditingController(text: "0"));
    update();
  }

  void updateTotalAmount(int index) {
    double quantity = double.tryParse(quantityControllers[index].text) ?? 0.0;
    double rate = double.tryParse(rateControllers[index].text) ?? 0.0;
    double totalAmount = quantity * rate;
    // totalAmountControllers[index].text = totalAmount.toString();
    String symbol = totalAmountControllers[0].text;
    totalAmountControllers[index].text = '$symbol$totalAmount';
    update();
  }

  bool loading = false;
  CollectionReference generateInvoice = FirebaseFirestore.instance.collection("GenerateInvoice");

  // void createInvoice(clientId) async {
  //   try {
  //     loading = true;
  //     update();
  //     int invoiceId = DateTime.now().microsecondsSinceEpoch;
  //     // List descriptionTextList = [];
  //     // // for (int i = 0; i < descriptionControllers.length; i++) {
  //     // //   String description = descriptionControllers[i].text.trim();
  //     // //   if (description.isNotEmpty) {
  //     // //     descriptionTextList.add(description);
  //     // //   }
  //     // // }
  //     // for (var element in descriptionControllers) {
  //     //   descriptionTextList.add(element.text.toString());
  //     // }
  //     // List qtyList = [];
  //     // for (var element in quantityControllers) {
  //     //   qtyList.add(element.text.toString());
  //     // }
  //     //
  //     // // for (int i = 0; i < quantityControllers.length; i++) {
  //     // //   String qty = quantityControllers[i].text.trim();
  //     // //   if (qty.isNotEmpty) {
  //     // //     qtyList.add(qty);
  //     // //   }
  //     // // }
  //     //
  //     // List rateList = [];
  //     // for (var element in rateControllers) {
  //     //   rateList.add(element.text.toString());
  //     // }
  //     // // for (int i = 0; i < rateControllers.length; i++) {
  //     // //   String rate = rateControllers[i].text.trim();
  //     // //   if (rate.isNotEmpty) {
  //     // //     rateList.add(rate);
  //     // //   }
  //     // // }
  //     //
  //     // List totalAmountList = [];
  //     // for (var element in totalAmountControllers) {
  //     //   totalAmountList.add(element.text.toString());
  //     // }
  //     // // for (int i = 0; i < totalAmountControllers.length; i++) {
  //     // //   String totalAmount = totalAmountControllers[i].text.trim();
  //     // //   if (totalAmount.isNotEmpty) {
  //     // //     totalAmountList.add(totalAmount);
  //     // //   }
  //     // // }
  //
  //     List descriptionTextList = [];
  //     List qtyList = [];
  //     List rateList = [];
  //     List totalAmountList = [];
  //
  //     for (int i = 0; i < descriptionControllers.length; i++) {
  //       String description = descriptionControllers[i].text.trim();
  //       String qty = quantityControllers[i].text.trim();
  //       String rate = rateControllers[i].text.trim();
  //       String totalAmount = totalAmountControllers[i].text.trim();
  //
  //       if (description.isNotEmpty ||
  //           qty.isNotEmpty ||
  //           rate.isNotEmpty ||
  //           totalAmount.isNotEmpty) {
  //         descriptionTextList.add(description);
  //         qtyList.add(qty);
  //         rateList.add(rate);
  //         totalAmountList.add(totalAmount);
  //       }
  //     }
  //     generateInvoice.doc(invoiceId.toString()).set({
  //       "InvoiceId": invoiceId.toString(),
  //       "ClientId": clientId,
  //       "DueDate": selectDate.toString(),
  //       "Currency": selectedCurrency?.name,
  //       "Invoice": listViewContainers.length,
  //       "Description": descriptionTextList,
  //       "Qty": qtyList,
  //       "Rate": rateList,
  //       "TotalAmount": totalAmountList,
  //       "VAT": vatController.text,
  //       "PaymentStatus": "UnPaid",
  //       "Comment": commentController.text,
  //       "UserId": PreferenceManager.getUserId(),
  //     });
  //     loading = false;
  //     update();
  //     log("Generate Invoice!!");
  //   } catch (e) {
  //     loading = false;
  //     update();
  //     log("$e");
  //     appSnackBar(message: "$e");
  //   }
  // }

  void createInvoice(clientId, clientName, clientCity) async {
    try {
      loading = true;
      update();
      int invoiceId = DateTime.now().microsecondsSinceEpoch;

      List<Map<String, dynamic>> invoiceItems = [];

      for (int i = 0; i < descriptionControllers.length; i++) {
        String description = descriptionControllers[i].text.trim();
        String qty = quantityControllers[i].text.trim();
        String rate = rateControllers[i].text.trim();
        String totalAmount = totalAmountControllers[i].text.trim();

        if (description.isNotEmpty && qty.isNotEmpty && rate.isNotEmpty && totalAmount.isNotEmpty) {
          invoiceItems.add({
            "Description": description,
            "Qty": qty,
            "Rate": rate,
            "TotalAmount": totalAmount,
          });
        }
      }
      if (invoiceItems.isNotEmpty) {
        generateInvoice.doc(invoiceId.toString()).set({
          "InvoiceId": invoiceId.toString(),
          "ClientId": clientId,
          "InvoiceDate": DateFormat.yMMMd().format(DateTime.now()),
          "ClientName": clientName,
          "ClientCity": clientCity,
          "DueDate": selectDate.toString(),
          "Currency": selectedCurrency?.name,
          "CurrencyCode": selectedCurrency?.code,
          "Invoice": invoiceItems.length,
          "InvoiceItems": invoiceItems,
          "VAT": vatController.text,
          "PaymentStatus": "Unpaid",
          "Comment": commentController.text,
          "UserId": PreferenceManager.getUserId(),
          "PaymentId": "",
          "PaymentLink": ""
        });
        loading = false;
        update();
        log("Generate Invoice!!");
        Get.back();
      } else {
        loading = false;
        update();
        appSnackBar(message: "No invoice items to save");
      }
    } catch (e) {
      loading = false;
      update();
      log("$e");
      appSnackBar(message: "$e");
    }
  }

  ValueNotifier<Color> containerColor = ValueNotifier<Color>(Colors.white);

  void updateContainerColor(Color newColor) {
    containerColor.value = newColor;
    update();
  }
}
