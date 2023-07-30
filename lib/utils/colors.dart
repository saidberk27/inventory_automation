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
      MaterialColor(0XFF36B1BF, color);

  static Color projectRed = const Color(0XFFF2385A);
  static Color projectOrange = const Color(0XFFF5A503);
  static Color projectGrey = const Color(0XFFE9F1DF);
  static Color projectBlue1 = const Color(0XFF4AD9D9);
  static Color projectBlue2 = const Color(0XFF36B1BF);
  static Color projectWhite = const Color(0xFFFFFFFF);
}
