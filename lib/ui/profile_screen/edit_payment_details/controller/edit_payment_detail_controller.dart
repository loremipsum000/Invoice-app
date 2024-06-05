import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:generate_invoice_app/utils/preference_manager.dart';
import 'package:get/get.dart';

class EditPaymentDetailController extends GetxController {
  //TextEditingController accHolderNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController ibanController = TextEditingController();
  TextEditingController bicController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController accNumberController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController bankAddressController = TextEditingController();

  // TextEditingController ifscController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  Country? selectedCountry;
  String? countryCode = '';

  // List<Map<String, dynamic>> paymentDetailData = [];
  //
  // Future<void> getPaymentDetail() async {
  //   var payment = await FirebaseFirestore.instance
  //       .collection("PaymentDetail")
  //       .where('UserId', isEqualTo: await PreferenceManager.getUserId())
  //       .get();
  //   for (var element in payment.docs) {
  //     Map<String, dynamic> temp = element.data();
  //     temp.addAll({"PaymentId": element.id});
  //     paymentDetailData.add(temp);
  //   }
  //   update();
  // }

  var data = Get.arguments;

  void editPaymentDetail(paymentDetailId) async {
    try {
      FirebaseFirestore.instance.collection("PaymentDetail").doc(paymentDetailId).update({
        //"AccHolderName": accHolderNameController.text,
        // "AccountNumber": accNumberController.text,
        // "BankName": bankNameController.text,
        // "BankAddress": bankAddressController.text,
        // //"IfscCode": ifscController.text,
        // "PanNumber": panNumberController.text,
        // "Status": "yes",
        // "UserId": PreferenceManager.getUserId(),
        //"AccHolderName": accHolderNameController.text,
        "FirstName": firstNameController.text,
        "LastName": lastNameController.text,
        "CompanyName": companyNameController.text,
        "AccountNumber": accNumberController.text,
        "BankName": bankNameController.text,
        "BankAddress": bankAddressController.text,
        "Country": selectedCountry != null ? selectedCountry?.name : data["Country"],
        "IBAN": ibanController.text,
        "BIC": bicController.text,
        // "IfscCode": ifscController.text,
        "PanNumber": panNumberController.text,
        "Status": "yes",
        "UserId": PreferenceManager.getUserId(),
      });
      update();
      log("Successfully updated paymentDetail");
    } catch (e) {
      update();
      log("$e");
    }
  }
}
