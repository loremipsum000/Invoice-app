import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:generate_invoice_app/utils/app_routes.dart';
import 'package:generate_invoice_app/utils/preference_manager.dart';
import 'package:generate_invoice_app/utils/theme_data.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_localization/flutter_localization.dart';

import 'const/app_string.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51NwekRSAML6bdyZO4NOPKru7kSFF82gVzH0muIkEuf12Cl7ck8708z5MQB2AaTJxUtWGbcWLXKAXAq4qypDyQwzl000IkaU923';
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(const MyApp());
}

final FlutterLocalization localization = FlutterLocalization.instance;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    log("PreferenceManager.getLanguage==>>${PreferenceManager.getLanguage()}");
    return GetMaterialApp(
      translations: LocalString(),
      locale: Locale(PreferenceManager.getLanguage() ?? 'en', 'US'),
      fallbackLocale: Locale(PreferenceManager.getLanguage() ?? 'en', 'US'),
      // supportedLocales: const [
      //   Locale('en', 'US'),
      //   Locale('hr', 'HR'),
      //  ],
      //  localizationsDelegates: localization.localizationsDelegates,
      //     localizationsDelegates: [
      //       GlobalMaterialLocalizations.delegate,
      //       GlobalWidgetsLocalizations.delegate,
      //       GlobalCupertinoLocalizations.delegate,
      //     ],
      debugShowCheckedModeBanner: false,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      title: 'Flutter Demo',
      initialRoute: PreferenceManager.getUserId() == null ? Routes.invoice : Routes.bottomBar,
      getPages: Routes.routes,
      //home: DemoStripePaymentScreen(),
    );
  }
}
