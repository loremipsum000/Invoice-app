import 'package:generate_invoice_app/ui/auth_screen/auth_screen.dart';
import 'package:generate_invoice_app/ui/auth_screen/forgot_password/forgot_password_screen.dart';
import 'package:generate_invoice_app/ui/bottom_bar/bottom_bar_view.dart';
import 'package:generate_invoice_app/ui/client_screen/add_new_client/add_new_client_screen.dart';
import 'package:generate_invoice_app/ui/client_screen/client_detail/client_detail_screen.dart';
import 'package:generate_invoice_app/ui/client_screen/edit_client/edit_client_screen.dart';
import 'package:generate_invoice_app/ui/client_screen/payment_detail/payment_detail_screen.dart';
import 'package:generate_invoice_app/ui/home_screen/create_invoice/create_invoice.dart';
import 'package:generate_invoice_app/ui/home_screen/edit_invoice/edit_Invoice_screen.dart';
import 'package:generate_invoice_app/ui/home_screen/slelect_client/select_client_screen.dart';
import 'package:get/get.dart';

class Routes {
  static String invoice = "/invoice";
  static String bottomBar = "/bottomBar";
  static String addNewClient = "/AddNewClientS";
  static String clientDetail = "/clientDetail";
  static String paymentDetail = "/paymentDetail";
  static String selectClient = "/SelectClient";
  static String createInvoice = "/CreateInvoice";
  static String editInvoice = "/EditInvoice";
  static String forgotPassword = "/ForgotPassword";
  static String editClient = "/EditClient";

  static List<GetPage> routes = [
    GetPage(
      name: invoice,
      page: () => const InvoiceView(),
      // transition: Transition.rightToLeft
    ),
    GetPage(
      name: bottomBar,
      page: () => const BottomBarView(),
    ),
    GetPage(
      name: addNewClient,
      page: () => const AddNewClientScreen(),
    ),
    GetPage(
      name: clientDetail,
      page: () => const ClientDetailScreen(),
    ),
    GetPage(
      name: paymentDetail,
      page: () => const PaymentDetailScreen(),
    ),
    GetPage(
      name: selectClient,
      page: () => const SelectClientScreen(),
    ),
    GetPage(
      name: createInvoice,
      page: () => const CreateInvoiceScreen(),
    ),
    GetPage(
      name: editInvoice,
      page: () => const EditInvoiceScreen(),
    ),
    GetPage(
      name: forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: editClient,
      page: () => const EditClientScreen(),
    ),
  ];
}
