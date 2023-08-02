import 'package:envanter_kontrol/screens/category_details.dart';
import 'package:envanter_kontrol/utils/colors.dart';
import 'package:envanter_kontrol/viewmodel/category_vm.dart';
import 'package:envanter_kontrol/widgets/footer.dart';
import 'package:envanter_kontrol/utils/text_styles.dart';
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
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: CustomFooter(),
      ),
      body: FutureBuilder(
        //OUTER FUTURE BUILDER FOR FETCH CATEGORIES
        future: CategoryViewModel().getAllCategories(),
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
                      flex: 3,
                      child: Center(
                          child: Column(
                        children: [
                          Image.asset("images/main_logo.png", height: 200),
                          SizedBox(height: 20),
                          Text(
                            "Envanter Takip Yazılımı",
                            style: ProjectTextStyle.redMediumStrong,
                          ),
                        ],
                      )),
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
        return Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.category,
                color: ProjectColors.projectOrange,
              ),
              title: Text(
                categoriesList[index]["title"],
                style: ProjectTextStyle.redMediumStrong,
              ),
              subtitle: Text(
                categoriesList[index]["description"],
                style: ProjectTextStyle.grey3Small,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryPage(
                            categoryName: categoriesList[index]["title"],
                            categoryID: categoriesList[index]["id"])));
              },
            ),
            const Divider(thickness: 1)
          ],
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
}
