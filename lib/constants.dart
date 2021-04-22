import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const headline1 = TextStyle(
  fontSize: 30.0,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

const headline2 = TextStyle(
  fontSize: 34.0,
  color: Colors.black,
  fontWeight: FontWeight.w500
);

const headline3 = TextStyle(
  fontSize: 20.0,
  color: Colors.black,
  fontWeight: FontWeight.w600,
);

const subtitle1 = TextStyle(
  fontSize: 16.0,
  color: Colors.black38,
);

final TextStyle appTitleStyle = GoogleFonts.montserrat(textStyle: headline1);
final TextStyle dataTextStyle = GoogleFonts.montserrat(textStyle: headline2);
final TextStyle dialogueTitleStyle = GoogleFonts.montserrat(textStyle: headline3);
final TextStyle subheadingStyle = GoogleFonts.roboto(textStyle: subtitle1);

final Color primaryColour = Color(0xFF6FA50F);
final Color primaryColourLight = Color(0xFFEEF6E6);

final ButtonStyle textButtonStyle = TextButton.styleFrom(
  primary: primaryColour,
  onSurface: Color(0x336FA50F)
);