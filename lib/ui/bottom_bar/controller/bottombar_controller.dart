import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:generate_invoice_app/utils/preference_manager.dart';
import 'package:generate_invoice_app/utils/stripe_payment_controller.dart';
import 'package:get/get.dart';

class BottomBarController extends GetxController {
  StripePaymentController stripePaymentController = Get.put(StripePaymentController());

  int selected = 0;
  var generateInvoiceData;

  updateBottomBar(int index) {
    selected = index;
    update();
  }

  getGenerateInvoiceData() async {
    generateInvoiceData = await FirebaseFirestore.instance
        .collection("GenerateInvoice")
        .where("UserId", isEqualTo: PreferenceManager.getUserId())
        .where("PaymentStatus", isEqualTo: "Unpaid")
        .get();

    for (var i = 0; i < generateInvoiceData.docs.length; i++) {
      // log('data==========$i=>>>>${generateInvoiceData.docs[i].id}');

      if (generateInvoiceData.docs[i]["PaymentId"] != "") {
        await stripePaymentController.checkSinglePaymentStatus(paymentId: "${generateInvoiceData.docs[i]["PaymentId"]}").then((value) {
          log('stripePaymentController.paymentStatusData["active"] ===========>>>>ID :: ${generateInvoiceData.docs[i].id},  ${stripePaymentController.paymentStatusData["active"]}');
          if (stripePaymentController.paymentStatusData["active"] == false) {
            FirebaseFirestore.instance
                .collection("GenerateInvoice")
                .doc("${generateInvoiceData.docs[i].id}")
                .update({"PaymentStatus": "Paid"});
          }
        });
      } else {
        log("Payment Id == null");
      }
    }
  }
}
