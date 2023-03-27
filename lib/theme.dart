import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  ThemeData theme = ThemeData(
      appBarTheme: AppBarTheme(
        color: _CustomColors().milk,
        elevation: 0,
      ),
      colorScheme: ColorScheme(
        primary: _CustomColors().butterflyBlue,
        secondary: _CustomColors().butterflyBlue,
        surface: _CustomColors().milk,
        background: _CustomColors().milk,
        error: _CustomColors().butterflyBlue,
        onPrimary: _CustomColors().eliteBlue,
        onSecondary: _CustomColors().eliteBlue,
        onSurface: _CustomColors().stoneCold,
        onBackground: _CustomColors().stoneCold,
        onError: _CustomColors().eliteBlue,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: _CustomColors().milk,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _CustomColors().butterflyBlue,
          textStyle: TextStyle(color: _CustomColors().winterOasis),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 33,
          fontWeight: FontWeight.w400,
          color: _CustomColors().butterflyBlue,
          fontFamily: GoogleFonts.righteous().fontFamily,
        ),
        headlineSmall: TextStyle(
            fontSize: 17,
            color: _CustomColors().textGray,
            fontWeight: FontWeight.w500,
            fontFamily: GoogleFonts.poppins().fontFamily),
        bodyMedium: TextStyle(
          color: _CustomColors().stoneCold,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w400,
          fontSize: 15,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          color: _CustomColors().winterOasis,
          fontWeight: FontWeight.w700,
          fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
      ));
}

class _CustomColors {
  final Color butterflyBlue = const Color.fromRGBO(33, 158, 188, 1);
  final Color eliteBlue = const Color.fromRGBO(29, 53, 87, 1);
  final Color textGray = const Color.fromRGBO(141, 141, 141, 1);
  final Color stoneCold = const Color.fromRGBO(85, 85, 85, 1);
  final Color winterOasis = const Color.fromRGBO(241, 250, 238, 1);
  final Color milk = const Color.fromRGBO(250, 255, 243, 1);
}
