import 'dart:developer';
import 'package:generate_invoice_app/ui/auth_screen/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

AuthController authController = Get.put(AuthController());

class PreferenceManager {
  static GetStorage box = GetStorage();

  static Future<void> setUserId(String value) async {
    await box.write("UserId", value);
  }

  static getUserId() {
    return box.read("UserId");
  }

  static Future<void> setUserName(String value) async {
    await box.write("UserName", value);
  }

  static getUserName() {
    return box.read("UserName");
  }

  static Future<void> setEmail(String value) async {
    await box.write("Email", value);
  }

  static getEmail() {
    return box.read("Email");
  }

  static Future<void> setAddPaymentDetail({String value = "No"}) async {
    await box.write("AddPaymentDetail", value);
  }

  static getAddPaymentDetail() {
    return box.read("AddPaymentDetail");
  }

  static Future<void> setStripePayment(String value) async {
    await box.write("StripePayment", value);
  }

  static getStripePayment() {
    return box.read("StripePayment");
  }

  static logOut() async {
    return box.erase();
  }

  void googleLogout() async {
    await authController.googleSignIn.signOut().then((value) => log('You are LogOut'));
  }

  static Future<void> setTheme(bool value) async {
    await box.write("isDarkMode", value);
  }

  static bool getTheme() {
    return box.read("isDarkMode") ?? false;
  }

  static Future<void> setLanguage(String value) async {
    await box.write("LanguageCode", value);
  }

  static getLanguage() {
    return box.read("LanguageCode");
  }

  static Future<void> setCountryCode(String value) async {
    await box.write("CountryCode", value);
  }

  static getCountryCode() {
    return box.read("CountryCode");
  }

// void logOut() async {
//   return removeData();
// }

// void removeData() {
//   box.remove("UserId");
//   box.remove("UserName");
//   box.remove("Email");
//   box.remove("AddPaymentDetail");
//   // box.remove("StripePayment");
// }
}
