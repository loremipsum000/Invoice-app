import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:generate_invoice_app/utils/preference_manager.dart';
import 'package:generate_invoice_app/widgets/app_snackbar.dart';
import 'package:get/get.dart';

class EditInvoiceController extends GetxController {
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
    totalAmountControllers.add(TextEditingController(text: "0.0"));
    update();
  }

  List<Map<String, dynamic>> invoiceData = [];

  Future<void> getInvoiceData(String invoiceId) async {
    var invoice = await FirebaseFirestore.instance.collection("GenerateInvoice").doc(invoiceId).get();

    if (invoice.exists) {
      Map<String, dynamic> temp = invoice.data()!;
      invoiceData.add(temp);
    }
  }

  bool loading = false;
  CollectionReference generateInvoice = FirebaseFirestore.instance.collection("GenerateInvoice");

  void updateInvoice(invoiceId) async {
    try {
      loading = true;
      update();
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
        generateInvoice.doc(invoiceId.toString()).update({
          "InvoiceId": invoiceId.toString(),
          // "ClientId": clientId,
          // "ClientName": clientName,
          "DueDate": selectDate.toString(),
          "Currency": selectedCurrency?.name ?? invoiceData[0]["Currency"],
          "CurrencyCode": selectedCurrency?.code ?? invoiceData[0]["CurrencyCode"],
          "Invoice": invoiceItems.length,
          "InvoiceItems": invoiceItems,
          "VAT": vatController.text,
          "PaymentStatus": "Unpaid",
          "Comment": commentController.text,
          "UserId": PreferenceManager.getUserId(),
          "PaymentId": invoiceData[0]["PaymentId"] ?? '',
          "PaymentLink": invoiceData[0]["PaymentLink"] ?? ''
        });
        loading = false;
        update();
        log("Successfully Update Invoice!!");
      } else {
        loading = false;
        update();
        appSnackBar(message: "No invoice items to for Edit");
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
