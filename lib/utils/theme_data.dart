import 'package:flutter/material.dart';
import 'package:generate_invoice_app/const/app_color.dart';

class MyThemes {
  static final darkTheme = ThemeData(
      scaffoldBackgroundColor: darkModeScaffoldColor,
      appBarTheme: const AppBarTheme(backgroundColor: darkModePrimaryColor),
      brightness: Brightness.dark,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        unselectedItemColor: whiteColor,
        selectedItemColor: whiteColor,
      ),
      bottomAppBarTheme: const BottomAppBarTheme(color: darkModeBottomBarColor),
      primaryColorDark: darkModePrimaryColor,
      indicatorColor: darkModePrimaryColor,
      //  dividerColor: greyColor,
      buttonTheme: const ButtonThemeData(buttonColor: darkModePrimaryColor));

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: lightModeScaffoldColor,
    appBarTheme: const AppBarTheme(backgroundColor: lightModePrimaryColor),
    brightness: Brightness.light,
    primaryColorLight: lightModePrimaryColor,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      unselectedItemColor: Colors.black,
      selectedItemColor: Colors.black,
    ),
    bottomAppBarTheme: BottomAppBarTheme(color: whiteColor),
    indicatorColor: lightModePrimaryColor,
    //  dividerColor: lightGreyColor,
    buttonTheme: const ButtonThemeData(buttonColor: lightModePrimaryColor),
  );
}
