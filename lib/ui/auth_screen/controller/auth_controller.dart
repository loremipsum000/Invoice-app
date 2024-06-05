import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:generate_invoice_app/utils/app_routes.dart';
import 'package:generate_invoice_app/utils/preference_manager.dart';
import 'package:generate_invoice_app/widgets/app_snackbar.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  TextEditingController emailControllerSignup = TextEditingController();
  TextEditingController passwordControllerSignup = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isshow = false;

  void passwordShow() {
    isshow = !isshow;
    update();
  }

  bool isshow1 = false;

  void passwordShow1() {
    isshow1 = !isshow1;
    update();
  }

  bool isshow2 = false;

  void passwordShow2() {
    isshow2 = !isshow2;
    update();
  }

  bool isLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection("User");

  Future<void> createUser() async {
    isLoading = true;
    update();
    try {
      UserCredential userData =
          await auth.createUserWithEmailAndPassword(email: emailControllerSignup.text, password: passwordControllerSignup.text);
      print("${userData.user?.uid}");
      await PreferenceManager.setUserId(userData.user!.uid);
      await PreferenceManager.setUserName(nameController.text);
      await PreferenceManager.setEmail(emailControllerSignup.text);
      log("userId==>>${PreferenceManager.getUserId()}");
      log("userName==>>${PreferenceManager.getUserName()}");
      log("email==>>${PreferenceManager.getEmail()}");
      users.doc(userData.user?.uid).set({
        "UserId": userData.user?.uid,
        "Full Name": nameController.text,
        "Email": emailControllerSignup.text,
        "PhoneNumber": "",
        "Address": "",
        "City": "",
        "CountryCode": "",
        "Country": "",
        "ProfileImage": "",
        "StripePayment": "false",
      });
      update();
      isLoading = false;
      update();
      appSnackBar(message: "User Successfully Created");
      // Get.toNamed(Routes.bottomBar);

      ///CREATE USER STRIPE PAYMENT

      var data = await FirebaseFirestore.instance.collection("User").doc(userData.user!.uid).get();
      String stripePayment = data["StripePayment"];

      log('PreferenceManager.getStripePayment==========>>>>>${await PreferenceManager.getStripePayment()}');
      // PreferenceManager.getStripePayment() == null
      //     ? await makePayment()
      //     : Get.offAllNamed(Routes.bottomBar);

      if (PreferenceManager.getStripePayment() == null) {
        await makePayment();
      }

      stripePayment == "true" ? Get.toNamed(Routes.bottomBar) : Get.toNamed(Routes.invoice);
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      update();
      if (e.code == "email-already-in-use") {
        appSnackBar(message: "Email is Already in Use");
      } else if (e.code == "weak-password") {
        appSnackBar(message: "Please enter Strong password");
      }
      print('ERROR ${e.message}');
      appSnackBar(message: "${e.message}");
      print('ERROR ${e.code}');
    }
    update();
  }

  bool loading = false;

  Future<void> userLogin() async {
    loading = true;
    update();
    try {
      UserCredential userData = await auth.signInWithEmailAndPassword(email: emailController.text, password: passWordController.text);
      var data = await FirebaseFirestore.instance.collection("User").doc(userData.user!.uid).get();
      String email = data["Email"];
      String userName = data["Full Name"];
      String stripePayment = data["StripePayment"];
      print(userData.user!.uid);
      await PreferenceManager.setUserId(userData.user!.uid);
      await PreferenceManager.setUserName(userName);
      await PreferenceManager.setEmail(email);

      log("userId==>>${PreferenceManager.getUserId()}");
      log("userName==>>${PreferenceManager.getUserName()}");
      log("Email==>>${PreferenceManager.getEmail()}");

      Future<String> getUserPaymentDetailStatus(String userId) async {
        var paymentData =
            await FirebaseFirestore.instance.collection("PaymentDetail").where("UserId", isEqualTo: PreferenceManager.getUserId()).get();

        if (paymentData.docs.isNotEmpty) {
          return "Yes";
        } else {
          return "No";
        }
      }

      String paymentStatus = await getUserPaymentDetailStatus(userData.user!.uid);

      if (paymentStatus == "Yes") {
        await PreferenceManager.setAddPaymentDetail(value: "Yes");
      }

      log("addPaymentDetail==>>${PreferenceManager.getAddPaymentDetail()}");
      loading = false;
      update();
      // appSnackBar(message: "User Successfully Login");

      ///LOGIN STRIPE PAYMENT

      log('PreferenceManager.getStripePayment()==========>>>>>${PreferenceManager.getStripePayment()}');
      log('stripePayment==========>>>>>$stripePayment');
      if (stripePayment == "false") {
        await makePayment();
      } else {
        Get.offAllNamed(Routes.bottomBar);
      }
      update();
    } on FirebaseAuthException catch (e) {
      loading = false;
      update();
      if (e.code == "user-not-found") {
        appSnackBar(message: "Wrong Email");
      } else if (e.code == "wrong-password") {
        appSnackBar(message: "password wrong");
      }
      print('ERROR ${e.message}');
      appSnackBar(message: "${e.message}");
      print('ERROR ${e.code}');
      //appSnackBar(message: e.code);
    }
  }

  GoogleSignIn googleSignIn = GoogleSignIn();
  bool loadingGoogle = false;

  void googleLogin() async {
    loadingGoogle = true;
    update();

    GoogleSignInAccount? account = await googleSignIn.signIn();
    GoogleSignInAuthentication authentication = await account!.authentication;
    OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );

    UserCredential userData = await auth.signInWithCredential(credential);
    PreferenceManager.setUserId(userData.user!.uid);
    PreferenceManager.setUserName(userData.user!.displayName.toString());
    PreferenceManager.setEmail(userData.user!.email.toString());

    log("userId==>>${PreferenceManager.getUserId()}");
    log("userName==>>${PreferenceManager.getUserName()}");
    log("Email==>>${PreferenceManager.getEmail()}");

    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("User").doc(userData.user?.uid).get();

    // var stripePaymentDetail;
    // stripePaymentDetail = userDoc.get("StripePayment");
    //log('stripePaymentDetail==========>>>>>${userDoc.get("StripePayment")}');
    if (userDoc.exists) {
      await users.doc(userData.user!.uid).update({
        "UserId": userData.user?.uid,
        "Full Name": userData.user?.displayName,
        "Email": userData.user?.email,
        "PhoneNumber": userData.user?.phoneNumber,
        "Address": "",
        "City": "",
        "CountryCode": "",
        "Country": "",
        "ProfileImage": userData.user?.photoURL,
        // "StripePayment": "true",
      });
    } else {
      await users.doc(userData.user!.uid).set({
        "UserId": userData.user?.uid,
        "Full Name": userData.user?.displayName,
        "Email": userData.user?.email,
        "PhoneNumber": userData.user?.phoneNumber,
        "Address": "",
        "City": "",
        "CountryCode": "",
        "Country": "",
        "ProfileImage": userData.user?.photoURL,
        "StripePayment": "false",
      });
    }

    await PreferenceManager.setUserId(userData.user!.uid);
    log("UserId===>>>${PreferenceManager.getUserId()}");

    Future<String> getUserPaymentDetailStatus(String userId) async {
      var paymentData =
          await FirebaseFirestore.instance.collection("PaymentDetail").where("UserId", isEqualTo: PreferenceManager.getUserId()).get();

      if (paymentData.docs.isNotEmpty) {
        return "Yes";
      } else {
        return "No";
      }
    }

    String paymentStatus = await getUserPaymentDetailStatus(userData.user!.uid);
    if (paymentStatus == "Yes") {
      await PreferenceManager.setAddPaymentDetail(value: "Yes");
    }

    log("addPaymentDetail==>>${PreferenceManager.getAddPaymentDetail()}");

    ///GOOGLE LOGIN STRIPE PAYMENT
    var data = await FirebaseFirestore.instance.collection("User").doc(userData.user!.uid).get();

    String stripePayment = data["StripePayment"];
    String fullName = data["Full Name"];
    log('fullName==========>>>>>$fullName');
    log('PreferenceManager.getStripePayment()==========>>>>>${PreferenceManager.getStripePayment()}');
    log('stripePayment==========>>>>>$stripePayment');
    if (stripePayment == "false") {
      await makePayment();
    } else {
      Get.offAllNamed(Routes.bottomBar);
    }
    loadingGoogle = false;
    update();
    //appSnackBar(message: "Successfully login with google");
    // Get.toNamed(Routes.bottomBar);
    print("${userData.user?.uid}");
    print("${userData.user?.email}");
    print("${userData.user?.phoneNumber}");
    update();
  }

  // //STEP 1 : Create Payment Intent
  // createPaymentIntent(String amount, String currency) async {
  //   try {
  //     //Request body
  //     Map<String, dynamic> body = {
  //       'amount': calculateAmount(amount),
  //       'currency': currency,
  //     };
  //
  //     var response = await http.post(
  //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //       headers: {
  //         'Authorization':
  //             'Bearer ${dotenv.env['sk_test_51NwekRSAML6bdyZOaL7wcMhYF9hccpI17oBe3W8XWK4mikZwNtvHRd31LnssaJhYywNtBIoBOW280oUdtd6bXVxT00xb8e2Zu1']}',
  //         'Content-Type': 'application/x-www-form-urlencoded'
  //       },
  //       body: body,
  //     );
  //     return json.decode(response.body);
  //   } catch (err) {
  //     throw Exception(err.toString());
  //   }
  // }
  //
  // displayPaymentSheet() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet().then((value) {
  //       const AlertDialog(
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Icon(
  //               Icons.check_circle,
  //               color: Colors.green,
  //               size: 100.0,
  //             ),
  //             SizedBox(height: 10.0),
  //             Text("Payment Successful!"),
  //           ],
  //         ),
  //       );
  //     }).onError((error, stackTrace) {
  //       throw Exception(error);
  //     });
  //   } on StripeException catch (e) {
  //     print('Error is:---> $e');
  //     const AlertDialog(
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Row(
  //             children: [
  //               Icon(
  //                 Icons.cancel,
  //                 color: Colors.red,
  //               ),
  //               Text("Payment Failed"),
  //             ],
  //           ),
  //         ],
  //       ),
  //     );
  //   } catch (e) {
  //     print('$e');
  //   }
  // }
  //
  // Future<void> makePayment() async {
  //   try {
  //     //STEP 1: Create Payment Intent
  //     paymentIntent = await createPaymentIntent('100', 'USD');
  //
  //     //STEP 2: Initialize Payment Sheet
  //     await Stripe.instance
  //         .initPaymentSheet(
  //             paymentSheetParameters: SetupPaymentSheetParameters(
  //                 paymentIntentClientSecret: paymentIntent![
  //                     'client_secret'], //Gotten from payment intent
  //                 style: ThemeMode.light,
  //                 merchantDisplayName: 'Ikay'))
  //         .then((value) {});
  //
  //     //STEP 3: Display Payment sheet
  //     displayPaymentSheet();
  //   } catch (err) {
  //     throw Exception(err);
  //   }
  // }

  // Map<String, dynamic>? paymentIntent;
  //
  // Future<void> makePayment() async {
  //   try {
  //     paymentIntent = await createPaymentIntent('10', 'INR');
  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: paymentIntent![
  //             'sk_test_51NwekRSAML6bdyZOaL7wcMhYF9hccpI17oBe3W8XWK4mikZwNtvHRd31LnssaJhYywNtBIoBOW280oUdtd6bXVxT00xb8e2Zu1'],
  //         googlePay: const PaymentSheetGooglePay(
  //             testEnv: true, currencyCode: "INR", merchantCountryCode: "IN"),
  //         merchantDisplayName: 'Flutterwings',
  //         // return URl if you want to add
  //         // returnURL: 'flutterstripe://redirect',
  //       ),
  //     );
  //     displayPaymentSheet();
  //   } catch (e) {
  //     print("exception $e");
  //     if (e is StripeConfigException) {
  //       print("Stripe exception ${e.message}");
  //     } else {
  //       print("exception $e");
  //     }
  //   }
  // }
  //
  // Future<void> displayPaymentSheet() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet();
  //     appSnackBar(message: "Paid successfully");
  //     paymentIntent = null;
  //   } on StripeException catch (e) {
  //     print('Error: $e');
  //     appSnackBar(message: "Payment Cancelled");
  //   } catch (e) {
  //     print("Error in displaying");
  //     print('$e');
  //   }
  // }
  //
  // createPaymentIntent(String amount, String currency) async {
  //   try {
  //     Map<String, dynamic> body = {
  //       'amount': ((int.parse(amount)) * 100).toString(),
  //       'currency': currency,
  //       'payment_method_types=': 'card',
  //     };
  //     var secretKey =
  //         "sk_test_51NwekRSAML6bdyZOaL7wcMhYF9hccpI17oBe3W8XWK4mikZwNtvHRd31LnssaJhYywNtBIoBOW280oUdtd6bXVxT00xb8e2Zu1";
  //     var response = await http.post(
  //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //       headers: {
  //         'Authorization': 'Bearer $secretKey',
  //         'Content-Type': 'application/x-www-form-urlencoded'
  //       },
  //       body: body,
  //     );
  //     print('Payment Intent Body: ${response.body.toString()}');
  //     return jsonDecode(response.body.toString());
  //   } catch (err) {
  //     print('Error charging user: ${err.toString()}');
  //   }
  // }

  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('10', 'INR');
      log('paymentIntent![]==========>>>>>${paymentIntent?['client_secret']}');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "INR", merchantCountryCode: "IN"),
          merchantDisplayName: 'Flutterwings',
          // return URl if you want to add
          returnURL: 'flutterstripe://redirect',
        ),
      );
      displayPaymentSheet();
    } catch (e) {
      print("exception $e");
      if (e is StripeConfigException) {
        print("Stripe exception ${e.message}");
      } else {
        print("exception $e");
      }
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      appSnackBar(message: "Paid Successfully");
      await FirebaseFirestore.instance.collection("User").doc(PreferenceManager.getUserId()).update({"StripePayment": "true"});
      var data = await FirebaseFirestore.instance.collection("User").doc(PreferenceManager.getUserId()).get();
      String stripePayment = data["StripePayment"];
      await PreferenceManager.setStripePayment(stripePayment);
      log('PreferenceManager.getStripePayment==========>>>>>${PreferenceManager.getStripePayment()}');
      PreferenceManager.getStripePayment() == "true" ? Get.toNamed(Routes.bottomBar) : Get.toNamed(Routes.invoice);
      paymentIntent = null;
      update();
    } on StripeException catch (e) {
      print('Error: $e');
      appSnackBar(message: "Payment Cancelled");
      var data = await FirebaseFirestore.instance.collection("User").doc(PreferenceManager.getUserId()).get();
      String stripePayment = data["StripePayment"];
      await PreferenceManager.setStripePayment(stripePayment);
      log('PreferenceManager.getStripePayment==========>>>>>${PreferenceManager.getStripePayment()}');
      Get.toNamed(Routes.invoice);
    } catch (e) {
      print("Error in displaying");
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((int.parse(amount)) * 100).toString(),
        'currency': currency,
        'payment_method_types[]': "card",
      };
      log('body==========>>>>>${body}');

      var secretKey = "sk_test_51NwekRSAML6bdyZOaL7wcMhYF9hccpI17oBe3W8XWK4mikZwNtvHRd31LnssaJhYywNtBIoBOW280oUdtd6bXVxT00xb8e2Zu1";

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {'Authorization': 'Bearer $secretKey', 'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );
      print('Payment Intent Body: ${response.body.toString()}');
      print('Payment statusCode Body: ${response.statusCode.toString()}');
      return jsonDecode(response.body.toString());
    } catch (err) {
      print('Error charging user: ${err.toString()}');
    }
  }
}
