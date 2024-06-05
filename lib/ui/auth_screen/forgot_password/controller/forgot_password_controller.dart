import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:generate_invoice_app/widgets/app_snackbar.dart';
import 'package:get/get.dart';

class ForgotPassword extends GetxController {
  TextEditingController emailController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> forgotPassword() async {
    await auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value) {
      appSnackBar(
          message:
              "We have sent you link to recover password please check password");
    }).onError((error, stackTrace) {
      appSnackBar(message: "$error");
    });
    update();
  }
}
