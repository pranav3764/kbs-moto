import 'package:mynotes/utils/theme/widget_theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class kbsAppTheme {

  kbsAppTheme._(); //to make it private

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: kbsTextTheme.lightTextTheme,
    // primarySwatch: MaterialColor(0xFF820300, <int, Color>{
    //   50: Color(0xFF820300),
    //   100: Color(0xFF820300),
    //   200: Color(0xFF820300),
    //   300: Color(0xFF820300),
    //   400: Color(0xFF820300),
    //   500: Color(0xFF820300),
    //   600: Color(0xFF820300),
    //   700: Color(0xFF820300),
    //   800: Color(0xFF820300),
    // }),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: kbsTextTheme.darkTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom())
    );
}
