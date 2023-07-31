class Product {
  String title;
  String description;
  int stockCount;
  String? mediaURL;
  String categoryID;

  Product(
      {this.mediaURL,
      required this.title,
      required this.description,
      required this.stockCount,
      required this.categoryID});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        title: json['title'] as String,
        description: json['description'] as String,
        stockCount: json['stockCount'] as int,
        mediaURL: json['mediaURL'] as String,
        categoryID: json['categoryID'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'stockCount': stockCount,
      'mediaURL': mediaURL,
      'categoryID': categoryID,
    };
  }
}
