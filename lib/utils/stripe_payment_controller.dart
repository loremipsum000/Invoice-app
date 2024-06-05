import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class StripePaymentController extends GetxController {
  Map<String, dynamic> linkData = {};
  Map<String, dynamic> paymentStatusData = {};

  /// Create Price Id

  createPriceId(
      {required String currency,
      required String amount,
      required String recurringInterval,
      required String name,
      required String invoiceId}) async {
    String secretKey = "sk_test_51NwekRSAML6bdyZOaL7wcMhYF9hccpI17oBe3W8XWK4mikZwNtvHRd31LnssaJhYywNtBIoBOW280oUdtd6bXVxT00xb8e2Zu1";
    Map<String, dynamic> body = {
      'currency': currency,
      'unit_amount': ((double.parse(amount)) * 100).toStringAsFixed(0).toString(),
      "recurring[interval]": recurringInterval,
      "product_data[name]": name
    };

    // log('body==========create payment link Price Id =>>>>${body}');
    try {
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/prices'),
        headers: {'Authorization': 'Bearer $secretKey', 'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );
      // print('Payment Link Create Price Id Body: ${response.body.toString()}');
      // print('Payment Link Create Price Id statusCode Body: ${response.statusCode.toString()}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // log('data===========>>>>${data['id']}');
        await createPaymentLink(priceId: "${data['id'] ?? ''}", quantity: "1", invoiceId: invoiceId);
      } else {
        print("Error During Create Link");
      }
      return jsonDecode(response.body.toString());
    } catch (e) {
      log("error create payment link Price Id :: $e");
    }
  }

  /// Create Payment Link
  createPaymentLink({required String priceId, required String quantity, required String invoiceId}) async {
    String secretKey = "sk_test_51NwekRSAML6bdyZOaL7wcMhYF9hccpI17oBe3W8XWK4mikZwNtvHRd31LnssaJhYywNtBIoBOW280oUdtd6bXVxT00xb8e2Zu1";
    Map<String, dynamic> body = {
      "line_items[0][price]": priceId,
      "line_items[0][quantity]": quantity,
      "restrictions[completed_sessions][limit]": "1",
    };

    // log('body==========create payment link=>>>>${body}');
    try {
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_links'),
        headers: {'Authorization': 'Bearer $secretKey', 'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );
      // log('Payment Link Create Body: ${response.body.toString()}');
      // print('Payment Link Create statusCode Body: ${response.statusCode.toString()}');

      if (response.statusCode == 200) {
        linkData = jsonDecode(response.body.toString());
        update();
        print("payment link create Successfully");

        // log("stripePaymentController.linkData['id']::::::::::::::::::::::${linkData['id']}");
        // log("stripePaymentController.linkData['url']::::::::::::::::::::::${linkData['url']}");

        FirebaseFirestore.instance
            .collection("GenerateInvoice")
            .doc(invoiceId)
            .update({"PaymentLink": "${linkData['url']}", "PaymentId": "${linkData['id']}"});
      } else {
        print("Error During Create Link");
      }

      return jsonDecode(response.body.toString());
    } catch (e) {
      log("error create payment link :: $e");
    }
  }

  /// Check Payment Status
  checkSinglePaymentStatus({required String paymentId}) async {
    String secretKey = "sk_test_51NwekRSAML6bdyZOaL7wcMhYF9hccpI17oBe3W8XWK4mikZwNtvHRd31LnssaJhYywNtBIoBOW280oUdtd6bXVxT00xb8e2Zu1";

    try {
      var response = await http.get(
        Uri.parse('https://api.stripe.com/v1/payment_links/$paymentId'),
        headers: {'Authorization': 'Bearer $secretKey', 'Content-Type': 'application/x-www-form-urlencoded'},
      );
      // log('Check Payment Status Body: ${response.body.toString()}');
      // print('Check Payment Status statusCode Body: ${response.statusCode.toString()}');

      if (response.statusCode == 200) {
        paymentStatusData = jsonDecode(response.body.toString());
        update();
        // log('data.url===========>>>>${paymentStatusData['url']}');
        print("Check Payment Status Successfully");
      } else {
        print("Error During Check Payment Status");
      }

      return jsonDecode(response.body.toString());
    } catch (e) {
      log("error Check Payment Status :: $e");
    }
  }

  /// Check Payment Status
// checkPaymentStatus({required String priceId, required String quantity, required String redirect}) async {
//   String secretKey = "sk_test_51NwekRSAML6bdyZOaL7wcMhYF9hccpI17oBe3W8XWK4mikZwNtvHRd31LnssaJhYywNtBIoBOW280oUdtd6bXVxT00xb8e2Zu1";
//   Map<String, dynamic> body = {
//     "line_items[0][price]": priceId,
//     "line_items[0][quantity]": quantity,
//     "after_completion[type]": redirect,
//   };
//
//   // log('body==========Check Payment Status=>>>>${body}');
//   try {
//     var response = await http.get(
//       Uri.parse('https://api.stripe.com/v1/payment_links'),
//       headers: {'Authorization': 'Bearer $secretKey', 'Content-Type': 'application/x-www-form-urlencoded'},
//       // body: body,
//     );
//     // log('Check Payment Status Body: ${response.body.toString()}');
//     // print('Check Payment Status statusCode Body: ${response.statusCode.toString()}');
//
//     if (response.statusCode == 200) {
//       paymentStatusData = jsonDecode(response.body.toString());
//       update();
//       // log('data.url===========>>>>${paymentStatusData['url']}');
//       print("Check Payment Status Successfully");
//     } else {
//       print("Error During Check Payment Status");
//     }
//
//     return jsonDecode(response.body.toString());
//   } catch (e) {
//     log("error Check Payment Status :: $e");
//   }
// }
}
