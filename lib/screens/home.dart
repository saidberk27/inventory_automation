import 'package:envanter_kontrol/utils/colors.dart';
import 'package:envanter_kontrol/utils/text_styles.dart';
import 'package:envanter_kontrol/widgets/custom_fab.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Text(
                        "KATEGORİ ADI",
                        style: ProjectTextStyle.redMediumStrong,
                        textAlign: TextAlign.center,
                      )),
                  Expanded(flex: 1, child: searchTextField()),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: const CustomFab(),
    );
  }

  TextField searchTextField() {
    return TextField(
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      style: ProjectTextStyle.redSmallStrong,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          suffix: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.send,
                color: ProjectColors.projectRed,
              )),
          hintText: "Ara...",
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 5, color: ProjectColors.projectRed)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              borderSide:
                  BorderSide(width: 5, color: ProjectColors.projectRed))),
    );
  }
}
