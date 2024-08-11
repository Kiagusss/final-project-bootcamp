class Product {
  final String id;
  final String name;
  final int stock;
  final String category;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.stock,
    required this.category,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromFirestore(Map<String, dynamic> json, String id) {
    return Product(
      id: id,
      name: json['name'],
      stock: json['stock'],
      category: json['category'],
      price: json['price'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'stock': stock,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}
