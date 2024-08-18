import 'package:flutter/material.dart';

class ColorSchemeLight {
  static Color primaryColor = const Color(0xff217CF3);
  static Color secondaryColor = const Color(0xff262A35);
  static Color primaryTextColor = const Color(0xff262A35);
  static Color secondaryTextColor = const Color(0xffB3B6BE);
  static Color onSecondary = Colors.white;
  static Color surface = Colors.white;
  static Color backgroundColor = Colors.white;
  static Color onBackgroundColor = Colors.black;
}

class ColorSchemeDark {
  static Color primaryColor = Colors.pink..shade400;
  static Color secondaryColor = Colors.white12;
  static Color primaryTextColor = Colors.white;
  static Color secondaryTextColor = Colors.white.withOpacity(0.6);
  static Color onSecondary = Colors.white;
  static Color surface = const Color(0xff262A35);
  static Color backgroundColor = Colors.black;
  static Color onBackgroundColor = Colors.white;
}

class ConfigThemeApp {
  final Color primary;
  final Color secondaryColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color onSecondary;
  final Color backGroundColor;
  final Color surface;
  final Color onBackground;
  final Brightness brightness;
  final String defualtFontFamily = 'Yekan';

  ConfigThemeApp.light()
      : primary = ColorSchemeLight.primaryColor,
        secondaryColor = ColorSchemeLight.secondaryColor,
        primaryTextColor = ColorSchemeLight.primaryTextColor,
        secondaryTextColor = ColorSchemeLight.secondaryTextColor,
        surface = ColorSchemeLight.surface,
        backGroundColor = ColorSchemeLight.backgroundColor,
        onBackground = ColorSchemeLight.onBackgroundColor,
        onSecondary = ColorSchemeLight.onSecondary,
        brightness = Brightness.light;

  ConfigThemeApp.dark()
      : primary = ColorSchemeDark.primaryColor,
        secondaryColor = ColorSchemeDark.secondaryColor,
        primaryTextColor = ColorSchemeDark.primaryTextColor,
        secondaryTextColor = ColorSchemeDark.secondaryTextColor,
        surface = ColorSchemeDark.surface,
        backGroundColor = ColorSchemeDark.backgroundColor,
        onBackground = ColorSchemeDark.onBackgroundColor,
        onSecondary = ColorSchemeDark.onSecondary,
        brightness = Brightness.dark;

  ThemeData getTheme() {
    return ThemeData(
      
        iconTheme: IconThemeData(
          color: primary,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              textStyle: MaterialStateProperty.all(
                  TextStyle(color: primary, fontFamily: defualtFontFamily))),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: primary),
        inputDecorationTheme:InputDecorationTheme(
          //disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: primary))
        ) ,
        appBarTheme: AppBarTheme(
            backgroundColor: surface,
            foregroundColor: primaryTextColor,
            elevation: 0),
        snackBarTheme: SnackBarThemeData(
            backgroundColor: onBackground,
            contentTextStyle:
                TextStyle(color: primary, fontFamily: defualtFontFamily)),
        textTheme: TextTheme(
            subtitle1: TextStyle(
                fontFamily: defualtFontFamily, color: secondaryTextColor),
            subtitle2: TextStyle(
                fontFamily: defualtFontFamily, color: secondaryTextColor),
            button: TextStyle(fontFamily: defualtFontFamily),
            bodyText1: TextStyle(
                fontFamily: defualtFontFamily,
                color: primaryTextColor,
                fontSize: 16),
            bodyText2: TextStyle(
                fontFamily: defualtFontFamily, color: primaryTextColor),
            caption: TextStyle(
                fontFamily: defualtFontFamily, color: secondaryTextColor),
            headline6: TextStyle(
                fontFamily: defualtFontFamily, fontWeight: FontWeight.bold)),
        colorScheme: ColorScheme.light(
            primary: primary,
            secondary: secondaryColor,
            brightness: brightness,
            onSecondary: onSecondary,
            background: backGroundColor,
            onBackground: onBackground,
            surface: surface));
  }
}
