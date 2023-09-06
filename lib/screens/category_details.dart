import 'package:envanter_kontrol/screens/add_new_category.dart';
import 'package:envanter_kontrol/screens/add_new_product.dart';
import 'package:envanter_kontrol/screens/home_categories.dart';
import 'package:envanter_kontrol/screens/subcategory_details.dart';
import 'package:envanter_kontrol/viewmodel/category_vm.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../local_functions/product_stats.dart';
import '../utils/colors.dart';
import '../utils/navigation_animation.dart';
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
  final TextEditingController _categoryNameUpdateController =
      TextEditingController();

  final TextEditingController _categoryDescUpdateController =
      TextEditingController();
  final TextEditingController _searchFieldController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _categoryListItems;
  late Future<List<Map<String, dynamic>>> _subCategoryListItems;

  final TextEditingController _productTitleController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();
  final TextEditingController _tagPriceController = TextEditingController();
  final TextEditingController _buyPriceController = TextEditingController();
  final TextEditingController _retailPriceController = TextEditingController();

  late String _categoryMainText;
  late TextButton _categoryMainButton;

  FilePickerResult? result;
  String filename = "";
  @override
  void initState() {
    super.initState();
    _categoryListItems = ProductViewModel().getAllItemsOfCategory(
        categoryID: widget.categoryID,
        itemType: "products",
        orderField:
            "timestamp"); // Arama sonuclarina gore hangi itemin dizilecegi degisiyor.
    _subCategoryListItems = ProductViewModel().getAllItemsOfCategory(
        categoryID: widget.categoryID,
        itemType: "subcategories",
        orderField: "title");
    _categoryMainText = widget.categoryName; // Arama sonuclarina gore degisecek
    _categoryMainButton =
        editCategoryButton(); //Arama sonuclarina gore degisecek
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: CustomFooter(),
        ),
        appBar: AppBar(
          foregroundColor: ProjectColors.projectWhite,
          title: Text(
            widget.categoryName,
            style: ProjectTextStyle.whiteSmallStrong,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: TextField(
                      controller: _searchFieldController,
                      decoration: InputDecoration(
                        hintText: 'Arama yapın...',
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(18))),
                        filled: true,
                        fillColor: ProjectColors.projectWhite,
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        _categoryListItems = ProductViewModel().searchProduct(
                            categoryID: widget.categoryID,
                            productName: _searchFieldController.text);
                        _categoryMainText =
                            "${_searchFieldController.text} için arama sonuçları: ";

                        _categoryMainButton = TextButton(
                            onPressed: () {
                              //!!!! GERI DON TUSUNA BASILINCA BUTUN WIDGETLER ILK HALINE DONUYOR.
                              _categoryListItems = ProductViewModel()
                                  .getAllItemsOfCategory(
                                      categoryID: widget.categoryID,
                                      itemType: "products",
                                      orderField: "timestamp");

                              _categoryMainText = widget.categoryName;

                              _categoryMainButton = editCategoryButton();
                              setState(() {});
                            },
                            child: Text(
                              "Kategoriye Geri Dön",
                              style: ProjectTextStyle.brownSmallStrong,
                            ));
                        setState(() {});
                      },
                      icon: const Icon(Icons.search))
                ],
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: _categoryListItems,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Map<String, dynamic>>? productList = snapshot.data;
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
                        flex: 3,
                        child: headerSection(totalStocks: totalNumberOfStocks),
                      ),
                      Expanded(flex: 4, child: subcategoriesFutureBuilder()),
                      const Divider(),
                      Expanded(
                        flex: 4,
                        child: productsListView(productList: productList),
                      ),
                      Expanded(
                        flex: 3,
                        child: dataChartSection(),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: Stack(children: [
          Positioned(
              bottom: 16.0, right: 16.0, child: fabAddSubCategory(context)),
          Positioned(
              bottom: 72.0, right: 16.0, child: fabAddNewProduct(context))
        ]));
  }

  Widget dataChartSection() {
    if (MediaQuery.of(context).size.width < 750) {
      return Row(
        children: [
          Expanded(flex: 9, child: pieChart(dataMap: dataMap)),
          const Expanded(flex: 10, child: SizedBox())
        ],
      );
    } else {
      return pieChart(dataMap: dataMap);
    }
  }

  FutureBuilder<List<Map<String, dynamic>>> subcategoriesFutureBuilder() {
    return FutureBuilder(
      future: _subCategoryListItems,
      builder: (context, snapshotIN) {
        if (snapshotIN.hasData) {
          return subCategoriesListView(subCategoriesList: snapshotIN.data);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  FloatingActionButton fabAddNewProduct(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => Navigator.push(
          context,
          SlideUpPageRoute(
              page: AddNewProductsPage(
                  categoryName: widget.categoryName,
                  categoryID: widget.categoryID))),
      focusColor: ProjectColors.projectBlue2,
      backgroundColor: ProjectColors.projectBlue2,
      hoverColor: ProjectColors.projectOrange,
      heroTag: "btn2",
      tooltip: "Yeni Ürün Ekle",
      label: Row(
        children: [
          Text("Yeni Ürün Ekle", style: ProjectTextStyle.whiteSmallStrong),
          const Icon(Icons.add)
        ],
      ),
    );
  }

  FloatingActionButton fabAddSubCategory(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => Navigator.push(
          context,
          SlideUpPageRoute(
            page: AddNewCategoryPage(
                categoryPath: "categories/${widget.categoryID}"),
          )),
      focusColor: ProjectColors.projectOrange,
      backgroundColor: ProjectColors.projectOrange,
      hoverColor: ProjectColors.projectBlue2,
      tooltip: "Yeni Alt Kategori Ekle",
      heroTag: "btn1",
      label: Row(
        children: [
          Text("Yeni Alt Kategori Ekle",
              style: ProjectTextStyle.whiteSmallStrong),
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
                  _categoryMainText,
                  style: ProjectTextStyle.redMediumStrong,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Toplam Stok: $totalStocks",
                  style: ProjectTextStyle.redMedium,
                ),
                const SizedBox(height: 10),
                _categoryMainButton,
              ],
            )),
      ],
    );
  }

  TextButton editCategoryButton() {
    return TextButton(
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
                        controller: _categoryNameUpdateController,
                        decoration: InputDecoration(
                          hintText: "YENİ KATEGORİ ADI",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24)),
                          prefixIcon: const Icon(Icons.abc),
                        ),
                      ),
                    ),
                    const Expanded(flex: 1, child: SizedBox()),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _categoryDescUpdateController,
                        decoration: InputDecoration(
                          hintText: "YENİ KATEGORİ AÇIKLAMASI",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24)),
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
                      warningDialog(context);
                    },
                    child: const Text("Kategoriyi Sil")),
                TextButton(
                    onPressed: () async {
                      CategoryViewModel vm = CategoryViewModel();
                      vm.updateCategoryInfo(
                          categoryID: widget.categoryID,
                          categoryTitle: _categoryNameUpdateController.text,
                          categoryDesc: _categoryDescUpdateController.text);
                      await Future.delayed(const Duration(milliseconds: 700))
                          .then(
                        (value) => Navigator.of(context).push(
                            SlideUpPageRoute(page: const HomePageCategories())),
                      );
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
      child: Text("Kategoriyi Düzenle", style: ProjectTextStyle.redSmallStrong),
    );
  }

  Future<dynamic> warningDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "DİKKAT",
            style: ProjectTextStyle.redMedium,
          ),
          content: const Text(
            "Bu işlem geri alınamaz. Devam etmek istiyor musunuz?",
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  if (await CategoryViewModel()
                      .deleteCategory(categoryID: widget.categoryID)) {
                    await Future.delayed(const Duration(milliseconds: 500));
                    setState(() {});
                  }

                  Navigator.of(context).pop();
                  Navigator.push(context,
                      SlideUpPageRoute(page: const HomePageCategories()));
                },
                child: const Text("Evet")),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Hayır"))
          ],
        );
      },
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
                buyPrice: productList[index]["buyPrice"],
                tagPrice: productList[index]["tagPrice"],
                retailPrice: productList[index]["retailPrice"],
                productID: productList[index]["id"],
                barcodeNumber: productList[index]["barcodeNumber"],
                mediaURL: productList[index]["mediaURL"]);
          },
        );
      },
    );
  }

  ListView subCategoriesListView(
      {required List<Map<String, dynamic>>? subCategoriesList}) {
    return ListView.builder(
      itemCount: subCategoriesList!.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(
            Icons.category,
            color: ProjectColors.projectOrange,
          ),
          title: Text(subCategoriesList[index]["title"]),
          subtitle: const Text("Alt Kategori"),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
                context,
                SlideUpPageRoute(
                    page: SubCategoryPage(
                        subCategoryName: subCategoriesList[index]["title"],
                        categoryID: widget.categoryID,
                        subCategoryID: subCategoriesList[index]["id"])));
          },
        );
      },
    );
  }

  SizedBox leadingImgCustom(List<dynamic> productList, int index) {
    return SizedBox(
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
      required int buyPrice,
      required int tagPrice,
      required int retailPrice,
      required String barcodeNumber,
      required String mediaURL}) {
    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Text(title),
            contentPadding: const EdgeInsets.all(20),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
                mainAxisSize: MainAxisSize.min, // eklenen mainAxisSize
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Stok: ${stock.toString()}'),
                  Text(
                      'Alış Fiyatı ${buyPrice == -1 ? "Bilgi Yok" : buyPrice.toString()}'),
                  Text('Liste Fiyatı: ${tagPrice.toString()}'),
                  Text('PSF: ${retailPrice.toString()}'),
                  Text('Barkod Numarası: ${barcodeNumber}'),
                  Text(descrption),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Image.network(mediaURL),
                          );
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2, color: ProjectColors.projectRed)),
                      height: 100,
                      width: 100,
                      child: mediaURL != ""
                          ? Image.network(
                              mediaURL,
                              fit: BoxFit.fill,
                            )
                          : Image.asset("assets/images/shirt.png"),
                    ),
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
                  Navigator.of(context).pop(); // Diyalog penceresini kapatır

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Ürünü Düzenle"),
                        content: SizedBox(
                          height: MediaQuery.of(context).size.height / 1.2,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: alertDialogTextFormField(
                                    controller: _productTitleController,
                                    hintText: "Yeni Ürün İsmi"),
                              ),
                              const Expanded(flex: 1, child: SizedBox()),
                              Expanded(
                                flex: 3,
                                child: alertDialogTextFormField(
                                    controller: _productDescriptionController,
                                    hintText: "Yeni Ürün Açıklaması"),
                              ),
                              const Expanded(flex: 1, child: SizedBox()),
                              Expanded(
                                flex: 3,
                                child: alertDialogTextFormField(
                                    controller: _buyPriceController,
                                    hintText: "Yeni Alış Fiyatı"),
                              ),
                              const Expanded(flex: 1, child: SizedBox()),
                              Expanded(
                                flex: 3,
                                child: alertDialogTextFormField(
                                    controller: _tagPriceController,
                                    hintText: "Yeni Liste Fiyatı"),
                              ),
                              const Expanded(flex: 1, child: SizedBox()),
                              Expanded(
                                flex: 3,
                                child: alertDialogTextFormField(
                                    controller: _retailPriceController,
                                    hintText: "Yeni PSF"),
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
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    SlideUpPageRoute(
                                        page: CategoryPage(
                                            categoryName: widget.categoryName,
                                            categoryID: widget
                                                .categoryID)), // Yeni sayfa
                                    (Route<dynamic> route) => route
                                        .isFirst, // Tüm önceki sayfaları temizle
                                  );
                                }
                              },
                              child: const Text("Ürünü Sil")),
                          TextButton(
                              onPressed: () async {
                                ProductViewModel productViewModel =
                                    ProductViewModel();
                                if (await productViewModel.updateProductInfo(
                                  categoryID: widget.categoryID,
                                  docID: productID,
                                  productTitle: _productTitleController.text,
                                  productDescrption:
                                      _productDescriptionController.text,
                                  tagPrice: _tagPriceController.text == ""
                                      ? null
                                      : int.parse(_tagPriceController.text),
                                  retailPrice: _retailPriceController.text == ""
                                      ? null
                                      : int.parse(_retailPriceController.text),
                                  buyPrice: _buyPriceController.text == ""
                                      ? null
                                      : int.parse(_buyPriceController.text),
                                )) {
                                  await Future.delayed(
                                          const Duration(milliseconds: 750))
                                      .then((value) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      SlideUpPageRoute(
                                          page: CategoryPage(
                                              categoryName: widget.categoryName,
                                              categoryID: widget
                                                  .categoryID)), // Yeni sayfa
                                      (Route<dynamic> route) => route
                                          .isFirst, // Tüm önceki sayfaları temizle
                                    );
                                  });
                                }
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

  TextFormField alertDialogTextFormField(
      {required TextEditingController controller, required String hintText}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
        prefixIcon: const Icon(Icons.abc),
      ),
    );
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
