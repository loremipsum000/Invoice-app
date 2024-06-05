import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:generate_invoice_app/utils/preference_manager.dart';
import 'package:generate_invoice_app/widgets/app_snackbar.dart';
import 'package:get/get.dart';

class AddClientController extends GetxController {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Country? selectedCountry;
  String? countryCode = '';
  bool isLoading = false;
  CollectionReference client = FirebaseFirestore.instance.collection("Clients");
  void addClient() async {
    isLoading = true;
    update();
    log("userid===>>>${PreferenceManager.getUserId()}");
    log("Country===>>${selectedCountry?.name}");
    try {
      int clientId = DateTime.now().microsecondsSinceEpoch;
      client.doc(clientId.toString()).set({
        "ClientId": clientId.toString(),
        "FullName": fullNameController.text,
        "Email": emailController.text,
        "CountryCode": "$countryCode",
        "PhoneNumber": phoneController.text,
        "Address": addressController.text,
        "City": cityController.text,
        "Country": selectedCountry?.name,
        "Description": descriptionController.text,
        "UserId": PreferenceManager.getUserId(),
      });
      isLoading = false;
      update();
      log("SuccessFully Added New Client");
      Get.back();
    } catch (e) {
      isLoading = false;
      appSnackBar(message: "$e");
      update();
    }
  }
}
