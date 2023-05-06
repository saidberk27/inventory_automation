import 'package:envanter_kontrol/screens/home.dart';
import 'package:flutter/material.dart';
import 'utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final String _appTitle = 'Can\'s Gömlek Envanter Takip Yazılımı';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appTitle,
      theme: ThemeData(
        primarySwatch: ProjectColors.customPrimarySwatch,
      ),
      home: HomePage(title: _appTitle),
    );
  }
}
