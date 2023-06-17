import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(width: 100, height: 20, child: Image.asset("images/hgt.png")),
      Text("Profesyonel Yazılım Sistemleri")
    ]);
  }
}
