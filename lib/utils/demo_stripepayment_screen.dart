import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:generate_invoice_app/widgets/app_snackbar.dart';
import 'common_textstyle.dart';
import 'package:http/http.dart' as http;

class DemoStripePaymentScreen extends StatefulWidget {
  const DemoStripePaymentScreen({super.key});

  @override
  State<DemoStripePaymentScreen> createState() => _DemoStripePaymentScreenState();
}

class _DemoStripePaymentScreenState extends State<DemoStripePaymentScreen> {
  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('10', 'INR');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent?['client_secret'],
          googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "INR", merchantCountryCode: "IN"),
          merchantDisplayName: 'Flutterwings',
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
      appSnackBar(message: "Paid successfully");
      setState(() {
        paymentIntent = null;
      });
    } on StripeException catch (e) {
      print('Error: $e');
      appSnackBar(message: "Payment Cancelled");
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
        'payment_method_types': 'card',
      };
      var secretKey = "sk_test_51NwekRSAML6bdyZOaL7wcMhYF9hccpI17oBe3W8XWK4mikZwNtvHRd31LnssaJhYywNtBIoBOW280oUdtd6bXVxT00xb8e2Zu1";
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {'Authorization': 'Bearer $secretKey', 'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );
      print('Payment Intent Body: ${response.body.toString()}');
      return jsonDecode(response.body.toString());
    } catch (err) {
      print('Error charging user: ${err.toString()}');
    }
  }

  // createPaymentIntent(String amount, String currency) async {
  //   try {
  //     Map<String, dynamic> body = {
  //       'amount': ((int.parse(amount)) * 100).toString(),
  //       'payment_method_types[]': ['card'], // Change to array format
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
  //     print('Error charging user: $err');
  //   }
  // }

  // Map<String, dynamic>? paymentIntent;
  // Future<void> payment() async {
  //   try {
  //     Map<String, dynamic> body = {"amount": 10000, "currency": "INR"};
  //     var secretKey =
  //         "sk_test_51NwekRSAML6bdyZOaL7wcMhYF9hccpI17oBe3W8XWK4mikZwNtvHRd31LnssaJhYywNtBIoBOW280oUdtd6bXVxT00xb8e2Zu1";
  //     var response = await http.post(
  //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //       headers: {
  //         "Authorization": "Bearer $secretKey",
  //         "Content-Type": "application/x-www-form-urlencoded"
  //       },
  //     );
  //     paymentIntent = json.decode(response.body);
  //     log("body===>${response.body}");
  //   } catch (error) {
  //     'Transaction failed: ${error.toString()}';
  //   }
  //
  //   // var gpay = const PaymentSheetGooglePay(
  //   //     merchantCountryCode: "GB", currencyCode: "GBP", testEnv: true);
  //   await Stripe.instance
  //       .initPaymentSheet(
  //           paymentSheetParameters: SetupPaymentSheetParameters(
  //         style: ThemeMode.light,
  //         paymentIntentClientSecret: paymentIntent!["client_secret"],
  //         merchantDisplayName: "shruti",
  //         //googlePay: gpay
  //       ))
  //       .then((value) => {});
  //   try {
  //     await Stripe.instance
  //         .presentPaymentSheet()
  //         .then((value) => {print("payment success")});
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkResponse(
              onTap: () async {
                await makePayment();
                //await payment();
              },
              child: Center(child: Text("Payment", style: CommonTextStyle.kBlack15OpenSansRegular))),
        ],
      ),
    );
  }
}
