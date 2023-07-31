import 'package:envanter_kontrol/viewmodel/category_vm.dart';
import 'package:envanter_kontrol/widgets/footer.dart';
import 'package:envanter_kontrol/utils/text_styles.dart';
import 'package:envanter_kontrol/viewmodel/product_vm.dart';
import 'package:envanter_kontrol/widgets/custom_fab.dart';
import 'package:flutter/material.dart';

class HomePageCategories extends StatefulWidget {
  const HomePageCategories({super.key});

  @override
  State<HomePageCategories> createState() => _HomePageCategoriesState();
}

class _HomePageCategoriesState extends State<HomePageCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: const Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: CustomFooter(),
      ),
      body: FutureBuilder(
        //OUTER FUTURE BUILDER FOR FETCH CATEGORIES
        future: CategoryVieModel().getAllCategories(),
        builder: (context, snapshotOUT) {
          if (snapshotOUT.hasData) {
            List<Map<String, dynamic>>? categoryList = snapshotOUT.data;

            //----------------------------------------
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(child: Text("Ana Sayfa")),
                    ),
                    Expanded(
                      flex: 4,
                      child: categoriesListView(categoriesList: categoryList!),
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
      floatingActionButton: const CustomFab(
        text: "Yeni Kategori Ekle",
        route: "/addNewCategory",
      ),
    );
  }

  ListView categoriesListView({required List categoriesList}) {
    return ListView.builder(
      itemCount: categoriesList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.category),
          title: Text(categoriesList[index]["title"]),
          subtitle: Text(categoriesList[index]["description"]),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            categoryDialog(
              title: categoriesList[index]["title"],
            );
          },
        );
      },
    );
  }

  Future<dynamic> categoryDialog({
    required String title,
  }) {
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
                children: const [],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Diyalog penceresini kapatır
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
                                Navigator.of(context).pop();
                              },
                              child: const Text("Ürünü Sil")),
                          TextButton(
                              onPressed: () async {
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
                          docID: productID, newStock: stockController.text)) {
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
