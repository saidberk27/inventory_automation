import 'package:envanter_kontrol/utils/colors.dart';
import 'package:flutter/material.dart';

import '../utils/text_styles.dart';

class CustomFab extends StatelessWidget {
  final String route;
  const CustomFab({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => Navigator.pushNamed(context, route),
      focusColor: ProjectColors.projectGrey3,
      backgroundColor: ProjectColors.projectGrey3,
      hoverColor: ProjectColors.projectBrown,
      tooltip: 'YENİ ÜRÜN EKLE',
      label: Row(
        children: [
          Text('YENİ ÜRÜN EKLE', style: ProjectTextStyle.whiteSmallStrong),
          const Icon(Icons.add)
        ],
      ),
    );
  }
}
