import 'package:envanter_kontrol/model/product.dart';
import 'package:envanter_kontrol/model/project_firestore.dart';

class ProductViewModel {
  Product product;
  ProductViewModel({required Product this.product});

  Future<void> addNewProduct() async {
    ProjectFirestore db = ProjectFirestore();
  }
}
