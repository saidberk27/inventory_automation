import 'package:flutter/material.dart';

class ProjectColors {
  static Map<int, Color> color = {
    50: const Color.fromRGBO(41, 128, 185, .1),
    100: const Color.fromRGBO(41, 128, 185, .2),
    200: const Color.fromRGBO(41, 128, 185, .3),
    300: const Color.fromRGBO(41, 128, 185, .4),
    400: const Color.fromRGBO(41, 128, 185, .5),
    500: const Color.fromRGBO(41, 128, 185, .6),
    600: const Color.fromRGBO(41, 128, 185, .7),
    700: const Color.fromRGBO(41, 128, 185, .8),
    800: const Color.fromARGB(228, 58, 99, 126),
    900: const Color.fromRGBO(41, 128, 185, 1),
  };
  static MaterialColor get customPrimarySwatch =>
      MaterialColor(0XFF3B3936, color);

  static Color projectRed = const Color(0XFFBD2A2E);
  static Color projectBrown = const Color(0XFF3B3936);
  static Color projectGrey1 = const Color(0XFFB2BEBF);
  static Color projectGrey2 = const Color(0XFF889C9B);
  static Color projectGrey3 = const Color(0XFF486966);
  static Color projectWhite = const Color(0xFFFFFFFF);
}
