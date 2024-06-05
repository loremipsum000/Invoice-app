import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:generate_invoice_app/const/app_color.dart';
import 'package:generate_invoice_app/utils/common_textstyle.dart';
import 'package:generate_invoice_app/widgets/app_buttons.dart';
import 'package:generate_invoice_app/widgets/app_snackbar.dart';
import 'package:generate_invoice_app/widgets/app_textfeild.dart';
import 'package:get/get.dart';
import '../../../const/app_string.dart';
import '../../../widgets/common_appbar.dart';
import 'controller/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  ForgotPassword forgotPassword = Get.put(ForgotPassword());
  FirebaseAuth auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: darkModeScaffoldColor,
      appBar: CommonAppBar(
        leadingIcon: true,
        title: "ForgotPassword".tr,
      ),
      body: GetBuilder<ForgotPassword>(builder: (controller) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.03),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(height: h * 0.06),
                  Text(
                    // AppString.enterYourEmailForResetPassText,
                    "enterYourEmailForResetPassText".tr,
                    style: CommonTextStyle.kWhite15OpenSansSemiBold.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? whiteColor
                            : blackColor),
                  ),
                  SizedBox(height: h * 0.03),
                  commonTextFeild(
                    labelText: "Email".tr,
                    controller: controller.emailController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Feild is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: h * 0.02),
                  commonButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        controller.forgotPassword();
                      }
                    },
                    child: Text(
                      "Submit",
                      style: CommonTextStyle.kWhite15OpenSansSemiBold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
