import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:generate_invoice_app/widgets/app_snackbar.dart';
import 'package:get/get.dart';

class EditClientController extends GetxController {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Country? selectedCountry;
  String? countryCode = '';
  bool loading = false;
  var data = Get.arguments;
  void editClient(clientId) async {
    try {
      loading = true;
      update();
      FirebaseFirestore.instance.collection("Clients").doc(clientId).update({
        "FullName": fullNameController.text,
        "Email": emailController.text,
        "CountryCode": countryCode!.isEmpty
            ? "${data["ClientCountryCode"]}"
            : "$countryCode",
        "PhoneNumber": phoneController.text,
        "Address": addressController.text,
        "City": cityController.text,
        "Country": selectedCountry != null
            ? selectedCountry?.name
            : data["ClientCountry"],
        "Description": descriptionController.text,
      });
      loading = false;
      update();
      appSnackBar(message: "Successfully updated client details");
    } catch (e) {
      loading = false;
      update();
      appSnackBar(message: "$e");
    }
    // FirebaseFirestore.instance
    //     .collection("Vendor")
    //     .doc(await PreferenceManager.getUserId())
    //     .update({
    //   "Image": pickedImage != null ? url : url,
    //   "Brand Name": brandController.text,
    //   "Email": emailController.text,
    //   "Full Name": ownerNameController.text,
    //   "Last Name": ownerNameController.text,
    //   "Gender": selectGender,
    //   "PhoneNumber": phoneNumberController.text,
    // });
  }
}
