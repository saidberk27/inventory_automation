class Product {
  String title;
  String description;
  int stockCount;

  Product({
    required this.title,
    required this.description,
    required this.stockCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'] as String,
      description: json['description'] as String,
      stockCount: json['stockCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'stockCount': stockCount,
    };
  }
}
