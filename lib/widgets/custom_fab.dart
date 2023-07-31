import 'package:envanter_kontrol/utils/colors.dart';
import 'package:flutter/material.dart';

import '../utils/text_styles.dart';

class CustomFab extends StatelessWidget {
  final String route;
  final String text;
  const CustomFab({super.key, required this.route, required this.text});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => Navigator.pushNamed(context, route),
      focusColor: ProjectColors.projectBlue2,
      backgroundColor: ProjectColors.projectBlue2,
      hoverColor: ProjectColors.projectOrange,
      tooltip: text,
      label: Row(
        children: [
          Text(text, style: ProjectTextStyle.whiteSmallStrong),
          const Icon(Icons.add)
        ],
      ),
    );
  }
}
