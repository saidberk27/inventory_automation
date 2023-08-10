import 'package:envanter_kontrol/model/category.dart';
import 'package:envanter_kontrol/screens/home_categories.dart';

import 'package:envanter_kontrol/utils/colors.dart';
import 'package:envanter_kontrol/utils/text_styles.dart';
import 'package:envanter_kontrol/viewmodel/category_vm.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/navigation_animation.dart';

class AddNewCategoryPage extends StatefulWidget {
  final String? categoryPath;
  const AddNewCategoryPage({super.key, String? this.categoryPath});

  @override
  State<AddNewCategoryPage> createState() => _AddNewCategoryPageState();
}

class _AddNewCategoryPageState extends State<AddNewCategoryPage> {
  final TextEditingController _categoryNameController = TextEditingController();

  final TextEditingController _categoryDescriptionController =
      TextEditingController();

  String filename = "";
  FilePickerResult? result;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ProjectColors.projectWhite,
        title: Text("Yeni Kategori Ekle",
            style: ProjectTextStyle.whiteSmallStrong),
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
                    title: "Kategori Adı",
                    textEditingController: _categoryNameController),
                const Divider(thickness: 2),
                titleAndInput(
                    title: "Kategori Açıklaması",
                    textEditingController: _categoryDescriptionController),
                SizedBox(
                    width: 200,
                    height: 100,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (await _addNewCategory()) {
                            Navigator.of(context).push(SlideUpPageRoute(
                                page: const HomePageCategories()));
                          }
                        },
                        child: Text(
                          "Yeni Kategori Ekle",
                          style: ProjectTextStyle.whiteSmallStrong,
                        )))
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

  Future<bool> _addNewCategory() async {
    try {
      CategoryViewModel vm = CategoryViewModel();
      if (widget.categoryPath == null) {
        // Main Category
        ProductCategory category = ProductCategory(
            title: _categoryNameController.text,
            description: _categoryDescriptionController.text);
        vm.addNewCategory(category: category);
        return true;
      } else {
        ProductCategory category = ProductCategory(
            title: _categoryNameController.text,
            description: _categoryDescriptionController.text);
        vm.addNewCategory(
            categoryPath: "${widget.categoryPath}/subcategories/",
            category: category);

        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print("e");
      }
      return false;
    }
  }
}
