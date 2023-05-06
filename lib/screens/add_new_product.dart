import 'package:envanter_kontrol/utils/text_styles.dart';
import 'package:flutter/material.dart';

class AddNewProductsPage extends StatelessWidget {
  const AddNewProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yeni Ürün Ekle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
            child: Container(
          width: MediaQuery.of(context).size.width / 1.5,
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                titleAndInput(title: "Ürün Adı"),
                Divider(thickness: 2),
                titleAndInput(title: "Ürün Açıklaması"),
                Divider(thickness: 2),
                titleAndInput(title: "Ürün Stok Sayısı"),
                Container(
                    width: 200,
                    height: 100,
                    child: ElevatedButton(
                        onPressed: () {}, child: Text("Yeni Ürün Ekle")))
              ],
            ),
          ),
        )),
      ),
    );
  }

  Column titleAndInput({required String title}) {
    return Column(
      children: [
        Text(
          title,
          style: ProjectTextStyle.grey3SmallStrong,
        ),
        SizedBox(height: 5),
        TextFormField(
          decoration: InputDecoration(
            hintText: title,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
            prefixIcon: const Icon(Icons.abc),
          ),
        ),
      ],
    );
  }
}
