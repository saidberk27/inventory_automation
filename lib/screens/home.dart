import 'package:envanter_kontrol/utils/colors.dart';
import 'package:envanter_kontrol/utils/text_styles.dart';
import 'package:envanter_kontrol/widgets/custom_fab.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, double> dataMap = {
    "Gömlek": 23,
    "Tişört": 67,
    "Eşofman Altı": 97,
  };

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
              Expanded(
                flex: 1,
                child: headerSection(),
              ),
              Expanded(
                flex: 4,
                child: productsListView(),
              ),
              Expanded(flex: 3, child: pieChart(dataMap: dataMap))
            ],
          ),
        ),
      ),
      floatingActionButton: const CustomFab(),
    );
  }

  PieChart pieChart({required Map<String, double> dataMap}) => PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(seconds: 2),
      );

  Row headerSection() {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "KATEGORİ ADI",
                  style: ProjectTextStyle.redMediumStrong,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Toplam Stok: 345",
                  style: ProjectTextStyle.redMedium,
                )
              ],
            )),
        Expanded(flex: 1, child: searchTextField()),
      ],
    );
  }

  ListView productsListView() {
    return ListView(
      children: [
        ListTile(
          leading: Image.asset("assets/images/tshirt.png"),
          title: const Text("Siyah Tişört"),
          subtitle: const Text("Stok: 67"),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {},
        ),
        ListTile(
          leading: Image.asset("assets/images/shirt.png"),
          title: const Text("Siyah Gömlek"),
          subtitle: const Text("Stok: 23"),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {},
        ),
        ListTile(
          leading: Image.asset("assets/images/pants.png"),
          title: const Text("Siyah Eşofman Altı"),
          subtitle: const Text("Stok: 97"),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {},
        ),
      ],
    );
  }

  TextField searchTextField() {
    return TextField(
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      style: ProjectTextStyle.redSmallStrong,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
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
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              borderSide:
                  BorderSide(width: 5, color: ProjectColors.projectRed))),
    );
  }
}
