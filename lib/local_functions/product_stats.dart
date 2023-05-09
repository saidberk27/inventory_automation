class ProductStats {
  late List<Map<String, dynamic>> productList;
  ProductStats({required this.productList}) {
    print("Product Stats is working");
  }

  int calculateTotalStockCount() {
    int sum = 0;
    print("calculate here");

    for (var product in productList) {
      int currentProductStock =
          product["stockCount"].toInt(); // num to int converter
      sum = sum + currentProductStock;
    }
    print("Sum: $sum");
    return sum;
  }

  Map<String, int> createPieChartDataMap() {
    Map<String, int> pieChartMap = {};
    if (productList.length <= 0) {
      return {"No Product Found": 0};
    }
    for (var product in productList) {
      String productName = product["title"];
      int productCount = product["stockCount"].toInt();
      pieChartMap.addAll({productName: productCount});
    }

    print(pieChartMap);
    return pieChartMap;
  }
}
