import 'package:envanter_kontrol/utils/colors.dart';
import 'package:flutter/material.dart';

import '../utils/text_styles.dart';

class CustomFab extends StatelessWidget {
  const CustomFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {},
      focusColor: ProjectColors.projectRed,
      backgroundColor: ProjectColors.projectRed,
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
