import 'package:flutter/foundation.dart';

class ProductStats {
  late List<Map<String, dynamic>> productList;
  ProductStats({required this.productList}) {
    if (kDebugMode) {
      print("Product Stats is working");
    }
  }

  int calculateTotalStockCount() {
    int sum = 0;
    if (kDebugMode) {
      print("calculate here");
    }

    for (var product in productList) {
      int currentProductStock =
          product["stockCount"].toInt(); // num to int converter
      sum = sum + currentProductStock;
    }
    if (kDebugMode) {
      print("Sum: $sum");
    }
    return sum;
  }

  Map<String, int> createPieChartDataMap() {
    Map<String, int> pieChartMap = {};
    if (productList.length <= 0) {
      return {"Kaydedilmiş Ürün Bulunamadı": 0};
    }
    for (var product in productList) {
      String productName = product["title"];
      int productCount = product["stockCount"].toInt();
      pieChartMap.addAll({productName: productCount});
    }

    if (kDebugMode) {
      print(pieChartMap);
    }
    return pieChartMap;
  }
}
