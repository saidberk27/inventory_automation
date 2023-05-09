import 'package:envanter_kontrol/local_functions/time.dart';
import 'package:envanter_kontrol/screens/add_new_product.dart';
import 'package:envanter_kontrol/screens/home.dart';
import 'package:flutter/material.dart';
import 'utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      routes: {"/addNewProduct": (context) => AddNewProductsPage()},
    );
  }
}
