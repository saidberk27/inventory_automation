import 'package:envanter_kontrol/model/product.dart';
import 'package:envanter_kontrol/screens/home.dart';
import 'package:envanter_kontrol/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:envanter_kontrol/viewmodel/product_vm.dart';

class AddNewProductsPage extends StatelessWidget {
  AddNewProductsPage({super.key});
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productDescriptionController = TextEditingController();
  TextEditingController _productStockInfoController = TextEditingController();
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
                SizedBox(
                    width: 200,
                    height: 100,
                    child: ElevatedButton(
                        onPressed: () {
                          _addNewProduct();
                          Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return HomePage(title: "Ana Sayfa");
                            },
                          ));
                        },
                        child: const Text("Yeni Ürün Ekle")))
              ],
            ),
          ),
        )),
      ),
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

  void _addNewProduct() {
    print("Adding new product");

    Product product = Product(
        title: _productNameController.text,
        description: _productDescriptionController.text,
        stockCount: int.parse(_productStockInfoController.text));
    ProductViewModel vm = ProductViewModel();
    vm.addNewProduct(product: product);
  }
}
