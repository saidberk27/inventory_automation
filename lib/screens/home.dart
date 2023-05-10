import 'package:envanter_kontrol/local_functions/product_stats.dart';
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
  late Map<String, double> dataMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        //OUTER FUTURE BUILDER FOR FETCH PRODUCTS
        future: ProductViewModel().getAllProducts(),
        builder: (context, snapshotOUT) {
          if (snapshotOUT.hasData) {
            List<Map<String, dynamic>>? productList = snapshotOUT.data;
            //INITIALIZING STATS AND TOTAL STOCK COUNT
            int totalNumberOfStocks = ProductStats(productList: productList!)
                .calculateTotalStockCount();
            dataMap = ProductStats(productList: productList)
                .createPieChartDataMap()
                .cast<String, double>();
            //----------------------------------------
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: headerSection(totalStocks: totalNumberOfStocks),
                    ),
                    Expanded(
                      flex: 4,
                      child: productsListView(productList: productList),
                    ),
                    Expanded(flex: 3, child: pieChart(dataMap: dataMap))
                  ],
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
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

  Row headerSection({required int totalStocks}) {
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
                  "Toplam Stok: $totalStocks",
                  style: ProjectTextStyle.redMedium,
                )
              ],
            )),
      ],
    );
  }

  ListView productsListView({required List productList}) {
    return ListView.builder(
      itemCount: productList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: leadingImgCustom(productList, index),
          title: Text(productList[index]["title"]),
          subtitle: Text("Stok: ${productList[index]["stockCount"]}"),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            productDialog(
                title: productList[index]["title"],
                stock: productList[index]["stockCount"],
                descrption: productList[index]["description"],
                productID: productList[index]["id"],
                mediaURL: productList[index]["mediaURL"]);
          },
        );
      },
    );
  }

  Container leadingImgCustom(List<dynamic> productList, int index) {
    return Container(
        width: 75,
        height: 100,
        child: productList[index]["mediaURL"] != ""
            ? Image.network(
                productList[index]["mediaURL"],
                fit: BoxFit.fill,
              )
            : Image.asset("assets/images/shirt.png"));
  }

  Future<dynamic> productDialog(
      {required String title,
      required int stock,
      required String descrption,
      required String productID,
      required String mediaURL}) {
    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Text(title),
            contentPadding: EdgeInsets.all(20),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min, // eklenen mainAxisSize
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Stok: ${stock.toString()}'),
                  Text(descrption),
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: mediaURL != ""
                        ? Image.network(
                            mediaURL,
                            fit: BoxFit.fill,
                          )
                        : Image.asset("assets/images/shirt.png"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Diyalog penceresini kapatır
                  enterNewStockInfo(context, productID: productID);
                },
                child: const Text('Stok Düzenle'),
              ),
              TextButton(
                onPressed: () {
                  TextEditingController _productTitleController =
                      TextEditingController();
                  TextEditingController _productDescriptionController =
                      TextEditingController();
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
                                  controller: _productTitleController,
                                  decoration: InputDecoration(
                                    hintText: "YENİ ÜRÜN ADI",
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
                                  controller: _productDescriptionController,
                                  decoration: InputDecoration(
                                    hintText: "YENİ ÜRÜN AÇIKLAMASI",
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
                                ProductViewModel productViewModel =
                                    ProductViewModel();
                                productViewModel.deleteProduct(
                                    docID: productID);
                                setState(() {});
                                Navigator.of(context).pop();
                              },
                              child: const Text("Ürünü Sil")),
                          TextButton(
                              onPressed: () {
                                ProductViewModel productViewModel =
                                    ProductViewModel();
                                productViewModel.updateProductInfo(
                                    docID: productID,
                                    productTitle: _productTitleController.text,
                                    productDescrption:
                                        _productDescriptionController.text);
                                setState(() {});
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

  Future<dynamic> enterNewStockInfo(BuildContext context,
      {required String productID}) {
    TextEditingController _stockController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Yeni Stok Bilgisi Gir"),
          content: SizedBox(
            height: 100,
            child: Column(
              children: [
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    controller: _stockController,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      ProductViewModel productViewModel = ProductViewModel();
                      productViewModel.updateStockInfo(
                          docID: productID, newStock: _stockController.text);
                      setState(() {});
                      Navigator.of(context).pop();
                    },
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
}
