import 'package:flutter/services.dart';
import 'package:generate_invoice_app/utils/preference_manager.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class ClientDetailController extends GetxController {
  Future<Uint8List> generatePdf({
    required String invoiceId,
    final String? clientName,
    final String? clientCity,
    final String? invoiceDate,
    final String? dueDate,
    final dynamic length,
    final String? totalAmount,
    final String? vat,
    final String? totalPayable,
    final String? paymentLink, //
    final String? accountNumber,
    final String? iban,
    final String? bic,
    final String? accountHolder,
    final String? panNumber,
    final pw.Widget Function()? listViewBuilder,
  }) async {
    final pdf = pw.Document();
    final h = Get.height;
    final w = Get.width;
    final data = await rootBundle.load("assets/fonts/open_sans/OpenSans-SemiBold.ttf");
    var myFont = Font.ttf(data.buffer.asByteData());
    pdf.addPage(
      pw.Page(
          build: (context) => pw.Padding(
                padding: pw.EdgeInsets.symmetric(vertical: h * 0.03, horizontal: w * 0.02),
                child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                    pw.Text("Invoice", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 35, font: myFont)),
                  ]),
                  pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Text("+", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 25)),
                    pw.Text("${PreferenceManager.getEmail()}", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 20)),
                  ]),
                  pw.Divider(
                    thickness: 4,
                    color: PdfColors.grey700,
                  ),
                  pw.SizedBox(height: h * 0.01),
                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                    pw.Column(children: [
                      pw.Row(children: [
                        pw.Text("Bill To: ", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 20)),
                        pw.Text("$clientName", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 15)),
                      ]),
                      pw.Padding(
                        padding: pw.EdgeInsets.only(left: w * 0.25),
                        child: pw.Text("$clientCity", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 15)),
                      ),
                    ]),
                    pw.Column(children: [
                      pw.Row(children: [
                        pw.Text("Invoice#  :", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 20)),
                        pw.SizedBox(width: w * 0.02),
                        pw.Text(invoiceId, style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 15)),
                      ]),
                      pw.Row(children: [
                        pw.Text("InvoiceDate  :", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 20)),
                        pw.SizedBox(width: w * 0.02),
                        pw.Text("$invoiceDate", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 15)),
                      ]),
                      pw.Row(children: [
                        pw.Text("DueDate  :", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 18)),
                        pw.SizedBox(width: w * 0.02),
                        pw.Text("$dueDate", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 15)),
                      ]),
                    ]),
                  ]),
                  pw.SizedBox(height: h * 0.04),
                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                    pw.Expanded(
                      flex: 1,
                      child: pw.Container(
                        height: h * 0.04,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black),
                        ),
                        child: pw.Center(child: pw.Text("Description", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique()))),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Container(
                        height: h * 0.04,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black),
                        ),
                        child: pw.Center(
                          child: pw.Text("Quantity", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique())),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Container(
                        height: h * 0.04,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black),
                        ),
                        child: pw.Center(child: pw.Text("Rate", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique()))),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Container(
                        height: h * 0.04,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black),
                        ),
                        child: pw.Center(child: pw.Text("Amount", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique()))),
                      ),
                    ),
                  ]),
                  listViewBuilder!(),
                  pw.SizedBox(height: h * 0.03),
                  // pw.Column(
                  //   mainAxisAlignment: pw.MainAxisAlignment.center,
                  //   children: [
                  //     pw.ListView.builder(
                  //       itemCount: length,
                  //       itemBuilder: (context, index) {
                  //         return pw.Row(children: [
                  //           pw.Expanded(
                  //             flex: 1,
                  //             child: pw.Container(
                  //               height: h * 0.06,
                  //               decoration: pw.BoxDecoration(
                  //                 border:
                  //                     pw.Border.all(color: PdfColors.black),
                  //               ),
                  //               child: pw.Center(
                  //                   child: pw.Text(
                  //                       //"Description",
                  //                       "$description",
                  //                       style: pw.TextStyle(
                  //                           fontBold: pw.Font
                  //                               .courierBoldOblique()))),
                  //             ),
                  //           ),
                  //           pw.Expanded(
                  //             flex: 1,
                  //             child: pw.Container(
                  //               height: h * 0.06,
                  //               decoration: pw.BoxDecoration(
                  //                 border:
                  //                     pw.Border.all(color: PdfColors.black),
                  //               ),
                  //               child: pw.Center(
                  //                 child: pw.Text(
                  //                     //"Quantity",
                  //                     "$qty",
                  //                     style: pw.TextStyle(
                  //                         fontBold: pw.Font
                  //                             .courierBoldOblique())),
                  //               ),
                  //             ),
                  //           ),
                  //           pw.Expanded(
                  //             flex: 1,
                  //             child: pw.Container(
                  //               height: h * 0.06,
                  //               decoration: pw.BoxDecoration(
                  //                 border:
                  //                     pw.Border.all(color: PdfColors.black),
                  //               ),
                  //               child: pw.Center(
                  //                   child: pw.Text(
                  //                       //"Rate",
                  //                       "$rate",
                  //                       style: pw.TextStyle(
                  //                           fontBold: pw.Font
                  //                               .courierBoldOblique()))),
                  //             ),
                  //           ),
                  //           pw.Expanded(
                  //             flex: 1,
                  //             child: pw.Container(
                  //               height: h * 0.06,
                  //               decoration: pw.BoxDecoration(
                  //                 border:
                  //                     pw.Border.all(color: PdfColors.black),
                  //               ),
                  //               child: pw.Center(
                  //                   child: pw.Text(
                  //                       //"Amount",
                  //                       "$amount",
                  //                       style: pw.TextStyle(
                  //                           fontBold: pw.Font
                  //                               .courierBoldOblique()))),
                  //             ),
                  //           ),
                  //         ]);
                  //       },
                  //     )
                  //   ],
                  // ),
                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                    pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
                      pw.Row(children: [
                        pw.Text("Total :", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 18)),
                        pw.SizedBox(width: w * 0.02),
                        pw.Text("$totalAmount", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 15)),
                      ]),
                      pw.SizedBox(height: h * 0.02),
                      pw.Row(children: [
                        pw.Text("VAT($vat%) :", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 16)),
                        pw.SizedBox(width: w * 0.02),
                        pw.Text("$vat", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 15)),
                      ]),
                      pw.SizedBox(height: h * 0.02),
                      pw.Row(children: [
                        pw.Text("TotalPayable :", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 18)),
                        pw.SizedBox(width: w * 0.02),
                        pw.Text("$totalPayable", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 15)),
                      ]),
                      pw.SizedBox(height: h * 0.02),
                      paymentLink != ''
                          ? pw.Row(children: [
                              pw.Text("Pay Using This Link :", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 18)),
                              pw.SizedBox(width: w * 0.02),
                              pw.UrlLink(
                                  child: pw.Text("${paymentLink ?? 'Not Found'}",
                                      style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 15, color: PdfColors.blue)),
                                  destination: paymentLink ?? ''),
                              // pw.AnnotationLink(replaces: ),
                              // pw.Text("${paymentLink ?? 'Not Found'}", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 15)),
                            ])
                          : pw.SizedBox(),
                      pw.Divider(color: PdfColors.black),
                    ]),
                  ]),
                  pw.SizedBox(height: h * 0.01),
                  pw.Text("BankDetails", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 18)),
                  pw.SizedBox(height: h * 0.01),
                  pw.Text("AccountNumber : $accountNumber", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 15)),
                  pw.Text("IBAN : $iban", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 15)),
                  pw.Text("BIC : $bic", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 15)),
                  pw.Text("AccountHolder : $accountHolder", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 15)),
                  pw.Text("PAN : $panNumber", style: pw.TextStyle(fontBold: pw.Font.courierBoldOblique(), fontSize: 15)),
                ]),
              )),
    );
    final Uint8List pdfBytes = await pdf.save();
    return pdfBytes;
  }
}

///
/// OLD CODE
///

// import 'package:flutter/services.dart';
// import 'package:generate_invoice_app/utils/preference_manager.dart';
// import 'package:get/get.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/widgets.dart';
//
// class ClientDetailController extends GetxController {
//
//   Future<Uint8List> generatePdf({
//     required String invoiceId,
//     final String? clientName,
//     final String? clientCity,
//     final String? invoiceDate,
//     final String? dueDate,
//     final dynamic length,
//     final String? totalAmount,
//     final String? vat,
//     final String? totalPayable,
//     final String? accountNumber,
//     final String? iban,
//     final String? bic,
//     final String? accountHolder,
//     final String? panNumber,
//     final pw.Widget Function()? listViewBuilder,
//   }) async {
//     final pdf = pw.Document();
//     final h = Get.height;
//     final w = Get.width;
//     final data =
//         await rootBundle.load("assets/fonts/open_sans/OpenSans-SemiBold.ttf");
//     var myFont = Font.ttf(data.buffer.asByteData());
//     pdf.addPage(
//       pw.Page(
//           build: (context) => pw.Padding(
//                 padding: pw.EdgeInsets.symmetric(
//                     vertical: h * 0.03, horizontal: w * 0.02),
//                 child: pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: [
//                       pw.Row(
//                           mainAxisAlignment: pw.MainAxisAlignment.end,
//                           children: [
//                             pw.Text("Invoice",
//                                 style: pw.TextStyle(
//                                     fontBold: pw.Font.courierBoldOblique(),
//                                     fontSize: 35,
//                                     font: myFont)),
//                           ]),
//                       pw.Column(
//                           crossAxisAlignment: pw.CrossAxisAlignment.start,
//                           children: [
//                             pw.Text("+",
//                                 style: pw.TextStyle(
//                                     fontBold: pw.Font.courierBoldOblique(),
//                                     fontSize: 25)),
//                             pw.Text("${PreferenceManager.getEmail()}",
//                                 style: pw.TextStyle(
//                                     fontBold: pw.Font.courierBoldOblique(),
//                                     fontSize: 20)),
//                           ]),
//                       pw.Divider(
//                         thickness: 4,
//                         color: PdfColors.grey700,
//                       ),
//                       pw.SizedBox(height: h * 0.01),
//                       pw.Row(
//                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                           children: [
//                             pw.Column(children: [
//                               pw.Row(children: [
//                                 pw.Text("Bill To: ",
//                                     style: pw.TextStyle(
//                                         fontBold: pw.Font.courierBoldOblique(),
//                                         fontSize: 20)),
//                                 pw.Text("$clientName",
//                                     style: pw.TextStyle(
//                                         fontBold: pw.Font.courierBoldOblique(),
//                                         fontSize: 15)),
//                               ]),
//                               pw.Padding(
//                                 padding: pw.EdgeInsets.only(left: w * 0.25),
//                                 child: pw.Text("$clientCity",
//                                     style: pw.TextStyle(
//                                         fontBold: pw.Font.courierBoldOblique(),
//                                         fontSize: 15)),
//                               ),
//                             ]),
//                             pw.Column(children: [
//                               pw.Row(children: [
//                                 pw.Text("Invoice#  :",
//                                     style: pw.TextStyle(
//                                         fontBold: pw.Font.courierBoldOblique(),
//                                         fontSize: 20)),
//                                 pw.SizedBox(width: w * 0.02),
//                                 pw.Text(invoiceId,
//                                     style: pw.TextStyle(
//                                         fontBold: pw.Font.courierBoldOblique(),
//                                         fontSize: 15)),
//                               ]),
//                               pw.Row(children: [
//                                 pw.Text("InvoiceDate  :",
//                                     style: pw.TextStyle(
//                                         fontBold: pw.Font.courierBoldOblique(),
//                                         fontSize: 20)),
//                                 pw.SizedBox(width: w * 0.02),
//                                 pw.Text("$invoiceDate",
//                                     style: pw.TextStyle(
//                                         fontBold: pw.Font.courierBoldOblique(),
//                                         fontSize: 15)),
//                               ]),
//                               pw.Row(children: [
//                                 pw.Text("DueDate  :",
//                                     style: pw.TextStyle(
//                                         fontBold: pw.Font.courierBoldOblique(),
//                                         fontSize: 18)),
//                                 pw.SizedBox(width: w * 0.02),
//                                 pw.Text("$dueDate",
//                                     style: pw.TextStyle(
//                                         fontBold: pw.Font.courierBoldOblique(),
//                                         fontSize: 15)),
//                               ]),
//                             ]),
//                           ]),
//                       pw.SizedBox(height: h * 0.04),
//                       pw.Row(
//                           mainAxisAlignment: pw.MainAxisAlignment.center,
//                           children: [
//                             pw.Expanded(
//                               flex: 1,
//                               child: pw.Container(
//                                 height: h * 0.04,
//                                 decoration: pw.BoxDecoration(
//                                   border: pw.Border.all(color: PdfColors.black),
//                                 ),
//                                 child: pw.Center(
//                                     child: pw.Text("Description",
//                                         style: pw.TextStyle(
//                                             fontBold:
//                                                 pw.Font.courierBoldOblique()))),
//                               ),
//                             ),
//                             pw.Expanded(
//                               flex: 1,
//                               child: pw.Container(
//                                 height: h * 0.04,
//                                 decoration: pw.BoxDecoration(
//                                   border: pw.Border.all(color: PdfColors.black),
//                                 ),
//                                 child: pw.Center(
//                                   child: pw.Text("Quantity",
//                                       style: pw.TextStyle(
//                                           fontBold:
//                                               pw.Font.courierBoldOblique())),
//                                 ),
//                               ),
//                             ),
//                             pw.Expanded(
//                               flex: 1,
//                               child: pw.Container(
//                                 height: h * 0.04,
//                                 decoration: pw.BoxDecoration(
//                                   border: pw.Border.all(color: PdfColors.black),
//                                 ),
//                                 child: pw.Center(
//                                     child: pw.Text("Rate",
//                                         style: pw.TextStyle(
//                                             fontBold:
//                                                 pw.Font.courierBoldOblique()))),
//                               ),
//                             ),
//                             pw.Expanded(
//                               flex: 1,
//                               child: pw.Container(
//                                 height: h * 0.04,
//                                 decoration: pw.BoxDecoration(
//                                   border: pw.Border.all(color: PdfColors.black),
//                                 ),
//                                 child: pw.Center(
//                                     child: pw.Text("Amount",
//                                         style: pw.TextStyle(
//                                             fontBold:
//                                                 pw.Font.courierBoldOblique()))),
//                               ),
//                             ),
//                           ]),
//                       listViewBuilder!(),
//                       pw.SizedBox(height: h * 0.03),
//                       // pw.Column(
//                       //   mainAxisAlignment: pw.MainAxisAlignment.center,
//                       //   children: [
//                       //     pw.ListView.builder(
//                       //       itemCount: length,
//                       //       itemBuilder: (context, index) {
//                       //         return pw.Row(children: [
//                       //           pw.Expanded(
//                       //             flex: 1,
//                       //             child: pw.Container(
//                       //               height: h * 0.06,
//                       //               decoration: pw.BoxDecoration(
//                       //                 border:
//                       //                     pw.Border.all(color: PdfColors.black),
//                       //               ),
//                       //               child: pw.Center(
//                       //                   child: pw.Text(
//                       //                       //"Description",
//                       //                       "$description",
//                       //                       style: pw.TextStyle(
//                       //                           fontBold: pw.Font
//                       //                               .courierBoldOblique()))),
//                       //             ),
//                       //           ),
//                       //           pw.Expanded(
//                       //             flex: 1,
//                       //             child: pw.Container(
//                       //               height: h * 0.06,
//                       //               decoration: pw.BoxDecoration(
//                       //                 border:
//                       //                     pw.Border.all(color: PdfColors.black),
//                       //               ),
//                       //               child: pw.Center(
//                       //                 child: pw.Text(
//                       //                     //"Quantity",
//                       //                     "$qty",
//                       //                     style: pw.TextStyle(
//                       //                         fontBold: pw.Font
//                       //                             .courierBoldOblique())),
//                       //               ),
//                       //             ),
//                       //           ),
//                       //           pw.Expanded(
//                       //             flex: 1,
//                       //             child: pw.Container(
//                       //               height: h * 0.06,
//                       //               decoration: pw.BoxDecoration(
//                       //                 border:
//                       //                     pw.Border.all(color: PdfColors.black),
//                       //               ),
//                       //               child: pw.Center(
//                       //                   child: pw.Text(
//                       //                       //"Rate",
//                       //                       "$rate",
//                       //                       style: pw.TextStyle(
//                       //                           fontBold: pw.Font
//                       //                               .courierBoldOblique()))),
//                       //             ),
//                       //           ),
//                       //           pw.Expanded(
//                       //             flex: 1,
//                       //             child: pw.Container(
//                       //               height: h * 0.06,
//                       //               decoration: pw.BoxDecoration(
//                       //                 border:
//                       //                     pw.Border.all(color: PdfColors.black),
//                       //               ),
//                       //               child: pw.Center(
//                       //                   child: pw.Text(
//                       //                       //"Amount",
//                       //                       "$amount",
//                       //                       style: pw.TextStyle(
//                       //                           fontBold: pw.Font
//                       //                               .courierBoldOblique()))),
//                       //             ),
//                       //           ),
//                       //         ]);
//                       //       },
//                       //     )
//                       //   ],
//                       // ),
//                       pw.Row(
//                           mainAxisAlignment: pw.MainAxisAlignment.end,
//                           children: [
//                             pw.Column(
//                                 crossAxisAlignment: pw.CrossAxisAlignment.end,
//                                 children: [
//                                   pw.Row(children: [
//                                     pw.Text("Total :",
//                                         style: pw.TextStyle(
//                                             fontBold:
//                                                 pw.Font.courierBoldOblique(),
//                                             fontSize: 18)),
//                                     pw.SizedBox(width: w * 0.02),
//                                     pw.Text("$totalAmount",
//                                         style: pw.TextStyle(
//                                             fontBold:
//                                                 pw.Font.courierBoldOblique(),
//                                             fontSize: 15)),
//                                   ]),
//                                   pw.SizedBox(height: h * 0.02),
//                                   pw.Row(children: [
//                                     pw.Text("VAT($vat%) :",
//                                         style: pw.TextStyle(
//                                             fontBold:
//                                                 pw.Font.courierBoldOblique(),
//                                             fontSize: 16)),
//                                     pw.SizedBox(width: w * 0.02),
//                                     pw.Text("$vat",
//                                         style: pw.TextStyle(
//                                             fontBold:
//                                                 pw.Font.courierBoldOblique(),
//                                             fontSize: 15)),
//                                   ]),
//                                   pw.SizedBox(height: h * 0.02),
//                                   pw.Row(children: [
//                                     pw.Text("TotalPayable :",
//                                         style: pw.TextStyle(
//                                             fontBold:
//                                                 pw.Font.courierBoldOblique(),
//                                             fontSize: 18)),
//                                     pw.SizedBox(width: w * 0.02),
//                                     pw.Text("$totalPayable",
//                                         style: pw.TextStyle(
//                                             fontBold:
//                                                 pw.Font.courierBoldOblique(),
//                                             fontSize: 15)),
//                                   ]),
//                                   pw.Divider(color: PdfColors.black),
//                                 ]),
//                           ]),
//                       pw.Text("BankDetails",
//                           style: pw.TextStyle(
//                               fontBold: pw.Font.courierBoldOblique(),
//                               fontSize: 18)),
//                       pw.SizedBox(height: h * 0.01),
//                       pw.Text("AccountNumber : $accountNumber",
//                           style: pw.TextStyle(
//                               fontBold: pw.Font.courierBoldOblique(),
//                               fontSize: 15)),
//                       pw.Text("IBAN : $iban",
//                           style: pw.TextStyle(
//                               fontBold: pw.Font.courierBoldOblique(),
//                               fontSize: 15)),
//                       pw.Text("BIC : $bic",
//                           style: pw.TextStyle(
//                               fontBold: pw.Font.courierBoldOblique(),
//                               fontSize: 15)),
//                       pw.Text("AccountHolder : $accountHolder",
//                           style: pw.TextStyle(
//                               fontBold: pw.Font.courierBoldOblique(),
//                               fontSize: 15)),
//                       pw.Text("PAN : $panNumber",
//                           style: pw.TextStyle(
//                               fontBold: pw.Font.courierBoldOblique(),
//                               fontSize: 15)),
//                     ]),
//               )),
//     );
//     final Uint8List pdfBytes = await pdf.save();
//     return pdfBytes;
//   }
// }
