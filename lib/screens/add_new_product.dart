import 'package:envanter_kontrol/model/product.dart';
import 'package:envanter_kontrol/screens/home_categories.dart';
import 'package:envanter_kontrol/screens/home_products.dart';
import 'package:envanter_kontrol/utils/colors.dart';
import 'package:envanter_kontrol/utils/text_styles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:envanter_kontrol/viewmodel/product_vm.dart';

class AddNewProductsPage extends StatefulWidget {
  final String categoryID;
  const AddNewProductsPage({super.key, required this.categoryID});

  @override
  State<AddNewProductsPage> createState() => _AddNewProductsPageState();
}

class _AddNewProductsPageState extends State<AddNewProductsPage> {
  final TextEditingController _productNameController = TextEditingController();

  final TextEditingController _productDescriptionController =
      TextEditingController();

  final TextEditingController _productStockInfoController =
      TextEditingController();
  String filename = "";
  FilePickerResult? result;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yeni Ürün Ekle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
            child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.5,
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                titleAndInput(
                    title: "Ürün Adı",
                    textEditingController: _productNameController),
                const Divider(thickness: 2),
                titleAndInput(
                    title: "Ürün Açıklaması",
                    textEditingController: _productDescriptionController),
                const Divider(thickness: 2),
                titleAndInput(
                    title: "Ürün Stok Sayısı",
                    textEditingController: _productStockInfoController),
                filePickerSection(),
                SizedBox(
                    width: 200,
                    height: 100,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (await _addNewProduct()) {
                            Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return const HomePageCategories();
                              },
                            ));
                          }
                        },
                        child: const Text("Yeni Ürün Ekle")))
              ],
            ),
          ),
        )),
      ),
    );
  }

  Row filePickerSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['jpg', 'png'],
            );

            if (result != null) {
              PlatformFile file = result!.files.first;
              filename = file.name;
              await Future.delayed(const Duration(milliseconds: 500));
              setState(() {});
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ProjectColors.projectWhite,
            side: BorderSide(
              color: ProjectColors.projectRed,
              width: 2.0,
            ),
          ),
          child: Text('Dosya Seç', style: ProjectTextStyle.redSmallStrong),
        ),
        const SizedBox(width: 10),
        Text(
          filename,
          style: ProjectTextStyle.brownSmallStrong,
        )
      ],
    );
  }

  Column titleAndInput(
      {required String title,
      required TextEditingController textEditingController}) {
    return Column(
      children: [
        Text(
          title,
          style: ProjectTextStyle.grey3SmallStrong,
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: textEditingController,
          decoration: InputDecoration(
            hintText: title,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
            prefixIcon: const Icon(Icons.abc),
          ),
        ),
      ],
    );
  }

  Future<bool> _addNewProduct() async {
    try {
      String productMediaURL = "";
      ProductViewModel vm = ProductViewModel();

      if (result != null) {
        productMediaURL = await vm.getMediaURL(result: result!);
      }

      Product product = Product(
          title: _productNameController.text,
          description: _productDescriptionController.text,
          stockCount: int.parse(_productStockInfoController.text),
          mediaURL: productMediaURL,
          categoryID: widget.categoryID);
      vm.addNewProduct(product: product, categoryID: widget.categoryID);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("e");
      }
      return false;
    }
  }
}
