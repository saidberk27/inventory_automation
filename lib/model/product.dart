class Product {
  String title;
  String description;
  int stockCount;
  String buyPrice;
  String tagPrice;
  String retailPrice; // PSF
  String? barcodeNumber;
  String? mediaURL;
  String categoryID;

  Product({
    this.mediaURL,
    required this.title,
    required this.description,
    required this.stockCount,
    required this.categoryID,
    required this.buyPrice,
    required this.tagPrice,
    required this.retailPrice,
    required this.barcodeNumber,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        title: json['title'] as String,
        description: json['description'] as String,
        stockCount: json['stockCount'] as int,
        buyPrice: json['buyPrice'] as String,
        tagPrice: json['tagPrice'] as String,
        retailPrice: json['retailPrice'] as String,
        barcodeNumber: json['barcodeNumber'] as String,
        mediaURL: json['mediaURL'] as String,
        categoryID: json['categoryID'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'stockCount': stockCount,
      'buyPrice': buyPrice,
      'tagPrice': tagPrice,
      'retailPrice': retailPrice,
      'barcodeNumber': barcodeNumber,
      'mediaURL': mediaURL,
      'categoryID': categoryID,
    };
  }
}
