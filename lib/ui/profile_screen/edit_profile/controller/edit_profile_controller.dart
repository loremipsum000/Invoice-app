import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:generate_invoice_app/utils/preference_manager.dart';
import 'package:generate_invoice_app/widgets/app_snackbar.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  Country? selectedCountry;
  String? countryCode = '';
  bool loading = false;
  var data = Get.arguments;
  FirebaseStorage storage = FirebaseStorage.instance;

  void editProfile() async {
    //  log("ProfileImage==>>${data["ProfileImage"]}");
    // try {
    //   loading = true;
    //   update();
    //   storage
    //       .ref("UserProfile/${data["ProfileImage"]}.png")
    //       .putFile(data["ProfileImage"]!)
    //       .then((value) async {
    //     FirebaseFirestore.instance
    //         .collection("User")
    //         .doc(PreferenceManager.getUserId())
    //         .update({
    //       "UserId": PreferenceManager.getUserId(),
    //       "Full Name": fullNameController.text,
    //       "Email": emailController.text,
    //       "CountryCode": "$countryCode",
    //       "PhoneNumber": phoneController.text,
    //       "Address": addressController.text,
    //       "City": cityController.text,
    //       "Country": selectedCountry?.name,
    //       // "ProfileImage": data["ProfileImage"] ?? "",
    //     });
    //     loading = false;
    //     update();
    //     appSnackBar(message: "Successfully updated user profile");
    //   });
    // }

    try {
      loading = true;
      update();
      FirebaseFirestore.instance.collection("User").doc(PreferenceManager.getUserId()).update({
        "UserId": PreferenceManager.getUserId(),
        "Full Name": fullNameController.text,
        "Email": emailController.text,
        "CountryCode": countryCode!.isEmpty ? "${data["CountryCode"]}" : "$countryCode",
        "PhoneNumber": phoneController.text,
        "Address": addressController.text,
        "City": cityController.text,
        "Country": selectedCountry != null ? selectedCountry?.name : "${data["Country"]}",
        // "ProfileImage": data["ProfileImage"] ?? "",
      });
      loading = false;
      update();
      appSnackBar(message: "Successfully updated user profile");
    } catch (e) {
      loading = false;
      update();
      appSnackBar(message: "$e");
    }
  }
}
