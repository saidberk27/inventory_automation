import 'package:envanter_kontrol/model/project_firestore.dart';
import 'package:envanter_kontrol/utils/colors.dart';
import 'package:envanter_kontrol/utils/text_styles.dart';
import 'package:envanter_kontrol/viewmodel/product_vm.dart';
import 'package:envanter_kontrol/widgets/custom_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      floatingActionButton: const CustomFab(
        route: "/addNewProduct",
      ),
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

  FutureBuilder productsListView() {
    return FutureBuilder(
      future: ProductViewModel().getAllProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Map<String, dynamic>> productList = snapshot.data;
          return ListView.builder(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.asset("assets/images/tshirt.png"),
                title: Text(productList[index]["title"]),
                subtitle: Text("Stok: ${productList[index]["stockCount"]}"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  productDialog(
                      title: productList[index]["title"],
                      stock: productList[index]["stockCount"],
                      descrption: productList[index]["description"]);
                  ProductViewModel productViewModel = ProductViewModel();
                  productViewModel.getAllProducts();
                },
              );
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Future<dynamic> productDialog(
      {required String title, required int stock, required String descrption}) {
    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Text(title),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 8,
              child: Column(
                children: [
                  Text('Stok: ${stock.toString()}'),
                  Expanded(child: Text(descrption))
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Diyalog penceresini kapatır
                  enterNewStockInfo(context);
                },
                child: const Text('Stok Düzenle'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Diyalog penceresini kapatır

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Ürünü Düzenle"),
                        content: SizedBox(
                          height: 100,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "ÜRÜN ADI",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    prefixIcon: const Icon(Icons.abc),
                                  ),
                                ),
                              ),
                              const Expanded(flex: 1, child: SizedBox()),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "ÜRÜN AÇIKLAMASI",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    prefixIcon: const Icon(Icons.abc),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Ürünü Güncelle")),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("İptal Et"))
                        ],
                      );
                    },
                  ); // Diyalog penceresini kapatır
                },
                child: const Text('Ürünü Düzenle'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Diyalog penceresini kapatır
                },
                child: const Text('Kapat'),
              ),
            ],
          );
        }));
  }

  Future<dynamic> enterNewStockInfo(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Yeni Stok Bilgisi Gir"),
          content: SizedBox(
            height: 100,
            child: Column(
              children: [
                const SizedBox(
                  width: 50,
                  child: TextField(
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () {},
                    child: const Text("Stok Bilgisini Güncelle"))
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("İptal Et"))
          ],
        );
      },
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
