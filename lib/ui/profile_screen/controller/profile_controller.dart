import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:generate_invoice_app/ui/auth_screen/auth_screen.dart';
import 'package:generate_invoice_app/ui/profile_screen/edit_payment_details/edit_payment_detail_screen.dart';
import 'package:generate_invoice_app/ui/profile_screen/edit_profile/edit_profile_screen.dart';
import 'package:generate_invoice_app/utils/preference_manager.dart';
import 'package:generate_invoice_app/widgets/app_snackbar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  ImagePicker imagePicker = ImagePicker();
  File? pickedImage;

  void pickGalleryImage() async {
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    pickedImage = File(file!.path);
    update();
  }

  void pickCameraImage() async {
    XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
    pickedImage = File(file!.path);
    update();
  }

  // XFile? pickedImage;
  // pickGalleryImage() async {
  //   XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     pickedImage = image;
  //     update();
  //   }
  // }

  FirebaseStorage storage = FirebaseStorage.instance;
  bool loading = false;

  void editProfileImage() async {
    try {
      loading = true;
      update();
      storage.ref("UserProfile/${pickedImage?.path}.png").putFile(pickedImage!).then((value) async {
        String url = await value.ref.getDownloadURL();
        log('pickedImage==========>>>>>$url');
        FirebaseFirestore.instance.collection("User").doc(PreferenceManager.getUserId()).update({
          "UserId": PreferenceManager.getUserId(),
          "ProfileImage": url,
        });
        loading = false;
        update();
        appSnackBar(message: "Updated User profile");
      });
    } catch (e) {
      loading = false;
      update();
      appSnackBar(message: "$e");
    }
  }

  List iconList = [
    Icons.account_balance_wallet,
    Icons.payment_outlined,
    Icons.language_outlined,
    Icons.logout,
  ];

  List profileTextList = [
    // AppString.accountText,
    // AppString.paymentDetailText,
    // AppString.languageText,
    // AppString.logoutText,
    'Account'.tr,
    'PaymentDetails'.tr,
    'Language'.tr,
    'Logout'.tr,
  ];

  List navigatorList = [
    const EditProfileScreen(),
    const EditPaymentDetailScreen(),
    const InvoiceView(),
  ];

  bool isCheck = true;

  List languageList = [
    // AppString.englishText,
    // AppString.croatianText
    "English".tr,
    "Croatian".tr,
  ];

  int selectedLanguageIndex = 0;

  void selectLanguage(int index) {
    selectedLanguageIndex = index;
    update();
  }
}
