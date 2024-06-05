import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:generate_invoice_app/utils/preference_manager.dart';
import 'package:generate_invoice_app/widgets/app_snackbar.dart';
import 'package:get/get.dart';

class PaymentDetailController extends GetxController {
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

  CollectionReference paymentDetail =
      FirebaseFirestore.instance.collection("PaymentDetail");

  bool loading = false;
  String? status = "No";
  void addPaymentDetail() async {
    try {
      loading = true;
      update();
      paymentDetail.doc().set({
        //"AccHolderName": accHolderNameController.text,
        "FirstName": firstNameController.text,
        "LastName": lastNameController.text,
        "CompanyName": companyNameController.text,
        "AccountNumber": accNumberController.text,
        "BankName": bankNameController.text,
        "BankAddress": bankAddressController.text,
        "Country": selectedCountry?.name,
        "IBAN": ibanController.text,
        "BIC": bicController.text,
        // "IfscCode": ifscController.text,
        "PanNumber": panNumberController.text,
        "Status": "yes",
        "UserId": PreferenceManager.getUserId(),
      });

      loading = false;
      update();

      PreferenceManager.setAddPaymentDetail(value: "Yes");
      PreferenceManager.getAddPaymentDetail();

      log("addPaymentDetail==>>${PreferenceManager.getAddPaymentDetail()}");
      log("Payment Detail Add Successfully");
    } catch (e) {
      loading = false;
      appSnackBar(message: "$e");
      log("$e");
      update();
    }
  }
}
