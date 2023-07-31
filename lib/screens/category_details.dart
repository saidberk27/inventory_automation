import 'package:envanter_kontrol/screens/add_new_product.dart';
import 'package:envanter_kontrol/screens/home_categories.dart';
import 'package:envanter_kontrol/viewmodel/category_vm.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../local_functions/product_stats.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import '../viewmodel/product_vm.dart';
import '../widgets/footer.dart';

class CategoryPage extends StatefulWidget {
  late final String categoryName;
  late final String categoryID;

  CategoryPage(
      {super.key, required this.categoryName, required this.categoryID});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Map<String, double> dataMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: const CustomFooter(),
        ),
        appBar: AppBar(
          title: Text(widget.categoryName),
        ),
        body: FutureBuilder(
          future: ProductViewModel()
              .getAllProductsOfCategory(categoryID: widget.categoryID),
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
                        flex: 2,
                        child: headerSection(totalStocks: totalNumberOfStocks),
                      ),
                      Expanded(
                        flex: 4,
                        child: productsListView(productList: productList),
                      ),
                      Expanded(flex: 3, child: pieChart(dataMap: dataMap)),
                      const Text(
                        "Said Berk © HGT AJANS 2023",
                        style: TextStyle(fontSize: 8),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        floatingActionButton: customFAB(context));
  }

  FloatingActionButton customFAB(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AddNewProductsPage(categoryID: widget.categoryID))),
      focusColor: ProjectColors.projectBlue2,
      backgroundColor: ProjectColors.projectBlue2,
      hoverColor: ProjectColors.projectOrange,
      tooltip: "Yeni Ürün Ekle",
      label: Row(
        children: [
          Text("Yeni Ürün Ekle", style: ProjectTextStyle.whiteSmallStrong),
          const Icon(Icons.add)
        ],
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
                  widget.categoryName,
                  style: ProjectTextStyle.redMediumStrong,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "Toplam Stok: $totalStocks",
                  style: ProjectTextStyle.redMedium,
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Kategoriyi Düzenle"),
                          content: SizedBox(
                            height: 100,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "YENİ KATEGORİ ADI",
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
                                      hintText: "YENİ KATEGORİ AÇIKLAMASI",
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
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          "DİKKAT",
                                          style: ProjectTextStyle.redMedium,
                                        ),
                                        content: Text(
                                          "Bu işlem geri alınamaz. Devam etmek istiyor musunuz?",
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () async {
                                                ProductViewModel
                                                    productViewModel =
                                                    ProductViewModel();
                                                if (await CategoryViewModel()
                                                    .deleteCategory(
                                                        categoryID: widget
                                                            .categoryID)) {
                                                  await Future.delayed(
                                                      const Duration(
                                                          milliseconds: 500));
                                                  setState(() {});
                                                }

                                                Navigator.of(context).pop();
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                  builder: (context) {
                                                    return HomePageCategories();
                                                  },
                                                ));
                                              },
                                              child: Text("Evet")),
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text("Hayır"))
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text("Kategoriyi Sil")),
                            TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Kategoriyi Güncelle")),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("İptal Et"))
                          ],
                        );
                      },
                    );
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(
                        BorderSide(color: ProjectColors.projectRed, width: 2)),
                    foregroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: Text("Kategoriyi Düzenle",
                      style: ProjectTextStyle.redSmallStrong),
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
            contentPadding: const EdgeInsets.all(20),
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
                  TextEditingController productTitleController =
                      TextEditingController();
                  TextEditingController productDescriptionController =
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
                                  controller: productTitleController,
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
                                  controller: productDescriptionController,
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
                              onPressed: () async {
                                ProductViewModel productViewModel =
                                    ProductViewModel();
                                if (await productViewModel.deleteProduct(
                                    categoryID: widget.categoryID,
                                    docID: productID)) {
                                  await Future.delayed(
                                      const Duration(milliseconds: 500));
                                  setState(() {});
                                }

                                Navigator.of(context).pop();
                              },
                              child: const Text("Ürünü Sil")),
                          TextButton(
                              onPressed: () async {
                                ProductViewModel productViewModel =
                                    ProductViewModel();
                                if (await productViewModel.updateProductInfo(
                                    categoryID: widget.categoryID,
                                    docID: productID,
                                    productTitle: productTitleController.text,
                                    productDescrption:
                                        productDescriptionController.text)) {
                                  await Future.delayed(
                                      const Duration(milliseconds: 500));
                                  setState(() {});
                                }

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
    TextEditingController stockController = TextEditingController();
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
                    controller: stockController,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () async {
                      ProductViewModel productViewModel = ProductViewModel();
                      if (await productViewModel.updateStockInfo(
                          categoryID: widget.categoryID,
                          docID: productID,
                          newStock: stockController.text)) {
                        await Future.delayed(const Duration(
                            milliseconds: 500)); // state updates too early
                        setState(() {});
                      }

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
